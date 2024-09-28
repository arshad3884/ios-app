//
//  RegisterViewModel.swift
//  mango
//
//  Created by Leo on 21.01.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import UIKit

@Observable class RegisterViewModel: AppProtocol {
    private(set) var user: User

    private let adminService = TAdminService()
    private let mediaService = TMediaService()
    private let verifyService = TVerifyService()

    var createProfile: Bool = false

    private(set) var triggerValidationAttention: Bool = false
    private(set) var media: [TProfileMedia] = TProfileMedia.initialMedia
    private(set) var selectedActivities: [TroovActivity] = []
    private var validationState: ValidationState = .valid
    private var latestStep: RegistrationStep = .phoneNumber

    var skip = false
    private var troovActivitySections: [TroovActivitySection] = []
    var showSkipRegisterPrompt = true
    var showImagePicker = false
    var blockScreen = false
    var showImageUploadWarning = false
    
    var allowToProceedImageUpload: Bool {
        let count = media.filter({
            $0.failure == nil &&
            $0.image != nil
        }).count
        return count >= minimumMediaCount
    }

    private var phoneNumber: PhoneNumber?
    private let minimumMediaCount: Int = 2

    var isNextAllowed: Bool {
        validationState == .valid
    }
    
    var filteredMedia: [TProfileMedia] {
        media.filter({ $0.image != nil && $0.data != nil})
    }

    func filteredTroovActivitySections(searchText: String) -> [TroovActivitySection] {
        if searchText.isClean {
            return troovActivitySections
        } else {
            var allMatchingActivities = troovActivitySections.flatMap(\.activities)
                .filter({ $0.name?.range(of: searchText,
                                         options: .caseInsensitive) != nil })

            if allMatchingActivities.isEmpty {
                allMatchingActivities = [.init(name: searchText)]
            }
            
            return [TroovActivitySection(activities: allMatchingActivities,
                                         title: "Search Results")]
        }
    }
    
    @MainActor func picked(_ images: [(UIImage, Data)]) {
        clean()
    
        for index in images.indices {
            let imageItem = images[index]
            media[index].image = imageItem.0
            media[index].data = imageItem.1
        }

        validateMedia()
    }

    @MainActor func profileMediaUpdateSetup(serverImages: [TServerImage]) async {
        clean()

        let viewModel = TImageViewModel()
        viewModel.installServer(images: serverImages)
        let images = viewModel.tfImages

        for index in images.indices {
         let image = images[index]
            if index < self.media.count {
                await MainActor.run {
                    self.media[index].data = image.uiImage?.jpegData(compressionQuality: 1)
                    self.media[index].image = image.uiImage
                    self.media[index].mediaId = image.id
                    self.media[index].element2.image = image.uiImage
                    self.media[index].rank = image.rank
                }
            }
        }
    }
    
    @MainActor private func clean() {
        for index in media.indices {
            self.media[index].data = nil
            self.media[index].image = nil
        }
    
        resetTheProgress()
    }

    func validateMedia() {
        if media.filter({
            $0.image != nil &&
            $0.failure == nil}).count >= minimumMediaCount {
            validate(.valid)
        } else {
            validate(.invalid)
        }
    }
    
    
    func unselect(media: TProfileMedia?) {
        if let media = media,
           let index = self.media.firstIndex(where: {$0.id == media.id}) {
            self.media[index].image = nil
            self.media[index].mediaType = nil
            self.media[index].data = nil
        }
        validateMedia()
    }

    private func imageRank(of media: TProfileMedia) -> Int? {
        if let index = filteredMedia.firstIndex(where: {$0.id == media.id}) {
            return index
        }
        return nil
    }

    private func filterRanks() async {
        await MainActor.run {
            for index in media.indices {
                let media = media[index]
                let rank = imageRank(of: media)
                self.media[index].rank = rank
            }
        }
    }
    
    @MainActor private func resetTheProgress() {
        for index in media.indices {
            self.media[index].inProgress = false
            self.media[index].finished = false
            self.media[index].failure = nil
        }
    }

    private func hitTheProgresss() async {
        await MainActor.run {
            for index in media.indices {
                self.media[index].inProgress = true
            }
        }
    }

    private func mediaUploadFinished() async {
        await MainActor.run {
            for index in media.indices {
                self.media[index].finished = true
            }
        }
    }
    
    private func uploadMedia() async throws {
        await filterRanks()
        let filtredMedia = media.filter({$0.data != nil})
        if filtredMedia.count > 1 {
            await resetTheProgress()
            await hitTheProgresss()
            switch await mediaService.cleanUploadProfilePhotos(filtredMedia) {
            case .success(let response):
                if let failed_upload = response.failed_upload, failed_upload.count > 0 {
                    for failedMedia in failed_upload {
                        if let index = self.media.firstIndex(where: {$0.id == failedMedia.profileMedia.mediaId}) {
                            await MainActor.run {
                                self.media[index].element2.failure = failedMedia.errorMessage
                            }
                        }
                    }
                    await mediaUploadFinished()
                    throw TRequestError.mediaFailed(response.failed_upload)
                } else {
                    await mediaUploadFinished()
                }
            case .failure(let error):
                await mediaUploadFinished()
                throw TRequestError.mediaFailed(filtredMedia.map({$0.failedRespone(reason: error.localizedDescription)}))
            }
        } else {
            await mediaUploadFinished()
            throw TRequestError.mediaFailed([])
        }
    }

    func uploadMediaAndFetchUser(step: RegistrationStep?) async throws {
        let uploadedMediaCount = media.filter({$0.finished && $0.failure == nil && $0.image != nil}).count
        if uploadedMediaCount < minimumMediaCount {
            try await uploadMedia()
            validateMedia()

            if let user = await ProfileViewModel.asyncGetUser() {
                await MainActor.run {
                    ProfileViewModel.shared.setUpdateLocalUser(user)
                }
                self.user = user
                if let images = user.userProfile?.images {
                    let imageViewModel = TImageViewModel()
                    imageViewModel.installServer(images: images)
                }
            }
        }
        
        if let step = step {
            await updateUserAccount(registrationStatus: step)
        }
    }

    func save(firstName: String, lastName: String, dateOfBirth: Date, step: RegistrationStep) {
        attachUserProfileToUser()
        user.userProfile?.age = Int64(dateOfBirth.age)
        user.userProfile?.firstName = firstName
        user.firstName = firstName
        user.lastName = lastName
        user.dateOfBirth = .init(wrappedDate: dateOfBirth)
        Task { await updateUserAccount(registrationStatus: step) }
    }

    func save(height: Int) {
        attachUserProfileToUser()
        user.userProfile?.height = .init(length: height)
        Task { await updateUserAccount(registrationStatus: .height) }
    }

    func save(generalInfo: [String], step: RegistrationStep) {
        attachUserProfileToUser()
        if step == .marketingChannels {
            if let newUpdatedUser = step.generateGeneralInfo(info: generalInfo, user: user) {
                user = newUpdatedUser
            }
        } else if let profile = user.userProfile,
           let newProfile = step.generateGeneralInfo(info: generalInfo,
                                               userProfile: profile) {
            user.userProfile = newProfile
        }
    
        Task { await updateUserAccount(registrationStatus: step) }
    }

    func save(almaMater: String, occupation: String, company: String, step: RegistrationStep) {
        attachUserProfileToUser()
        user.userProfile?.almaMater = [almaMater]
        user.userProfile?.occupation = occupation
        user.userProfile?.company = company
        Task { await updateUserAccount(registrationStatus: step) }
    }

    func saveActivityInterests() {
        attachUserProfileToUser()
        self.user.userProfile?.activityInterests = selectedActivities
        Task { await updateUserAccount(registrationStatus: .activityInterests) }
    }
    
    func validate(_ state: ValidationState) {
        if Thread.isMainThread {
            self.validationState = state
        } else {
            DispatchQueue.main.async {
                self.validationState = state
            }
        }
    }
    
    func allowNext() -> Bool {
        if validationState == .valid {
            triggerValidationAttention = false
            return true
        } else {
            triggerValidationAttention.toggle()
            hapticFeedback()
            return false
        }
    }
    
    private func attachUserProfileToUser() {
        if user.userProfile == nil {
            user.userProfile = .init()
        }
    }

    func select(activity: TroovActivity) {
        if let index = selectedActivities.firstIndex(where: {$0.name == activity.name}) {
            selectedActivities.remove(at: index)
            if activity.category == .other || activity.category == nil {
                removeCustomActivity(activity: activity)
            }
        } else {
            if activity.category == nil || activity.category == .other {
                var customActivity = activity
                customActivity.emoji = "❓"
                customActivity.category = .other
                appendCustomActivity(activity: customActivity)
                selectedActivities.append(customActivity)
            } else {
                selectedActivities.append(activity)
            }
        }
    }

    private func appendCustomActivity(activity: TroovActivity) {
        if let index = troovActivitySections.firstIndex(where: {$0.activities.first?.category == .other}) {
            if !troovActivitySections[index].activities.contains(where: {$0.name?.uppercased() == activity.name?.uppercased()}) {
                troovActivitySections[index].activities.append(activity)
            }
        } else {
            troovActivitySections.insert(.init(activities: [activity], title: activity.category?.title ?? "Custom"), at: 0)
        }
    }

    private func removeCustomActivity(activity: TroovActivity) {
        if let section = troovActivitySections.firstIndex(where: {$0.activities.first?.category == .other}) {
            troovActivitySections[section].activities.removeAll(where: {$0.name?.uppercased() == activity.name?.uppercased()})
            if troovActivitySections[section].activities.isEmpty {
                troovActivitySections.remove(at: section)
            }
        }
    }

    func updatePhoneNumber(_ number: PhoneNumber?) {
        guard let number = number else { return }
        phoneNumber = number
    }

    func sendSmsCodeForUser(isResendCode: Bool) async {
        if let cleanedPhoneNumber = phoneNumber?.localNumber?.replacingOccurrences(of: " ", with: "") {
            phoneNumber?.localNumber = cleanedPhoneNumber
        }
        
        user.phoneNumber = phoneNumber

        await updateUserAccount(registrationStatus: .phoneNumber,
                                skipStepValidation: isResendCode)

        let result = await verifyService.sendSmsCode()
        switch result {
        case .success(let success):
            debugPrint("sendSmsCode success: ", success)
        case .failure(let failure):
            debugPrint("sendSmsCode failure: ", failure.message)
        }
    }

    func verifySmsCodeForUser() async {
        let result1 = await verifyService.verify(code: .init(userSubmittedCode: 151151))
        switch result1 {
        case .success(let verify):
            debugPrint("verify success: ", verify)
        case .failure(let failure):
            debugPrint("verify failure: ", failure.message)
        }
        
        await updateUserAccount(registrationStatus: .codeSent)
        if let user = await ProfileViewModel.asyncGetUser() {
            self.user = user
        }
    }

    func updateUserAccount(registrationStatus: RegistrationStep,
                           skipStepValidation: Bool = false) async {
        if !skipStepValidation {
            guard let nextStep = registrationStatus.next(),
            nextStep.isHigherInOrder(than: latestStep) else { return }
            latestStep = nextStep
            self.user.registrationStatus = nextStep
            await ProfileViewModel.shared.updateUserAccountOnServer(user: self.user)
            debugPrint("🔄 ===>>>> Updated user account at step: ", nextStep)
        } else {
            debugPrint("!!🔄 ===>>>> Updated user account at step: \(registrationStatus) and skip step validation: ")
            await ProfileViewModel.shared.updateUserAccountOnServer(user: self.user)
        }
    }

    func updateLatestStep(step: RegistrationStep) {
        latestStep = step
    }

    func updateUserStepToDoItLater() async {
        self.user.registrationStatus = .doItLaterOption
        await ProfileViewModel.shared.updateUserAccountOnServer(user: self.user)
        debugPrint("🔄 ===>>>> Updated user account at step: ", RegistrationStep.doItLaterOption)
    }

    /**
     Initiate with the existing User, so there is no RegisterViewModel without an existing User account
     */
    init(withActivities: Bool, user: User) {
        self.user = user
        if let registrationStatus = user.registrationStatus {
            self.latestStep = registrationStatus
        }
        
        if let activityInterests = user.userProfile?.activityInterests {
            selectedActivities = activityInterests
        }

        if withActivities {
            Task {
                    let result = await self.adminService.activities()
                    switch result {
                    case .success(let activities):
                        let activitiesGroup: [[TroovActivity]] = activities.reduce(into: []) {
                            $0.last?.last?.category == $1.category ?
                            $0[$0.index(before: $0.endIndex)].append($1) :
                            $0.append([$1])
                        }
                        var sections: [TroovActivitySection] = []
                        for activityArray in activitiesGroup {
                            if let title = activityArray.first?.category?.title {
                                let section = TroovActivitySection(activities: activityArray,
                                                                   title: title)
                                sections.append(section)
                            }
                        }
                        self.troovActivitySections = sections
                    case .failure(let failure):
                        debugPrint("failure: ", failure)
                    }
            }
        }
    }
}

