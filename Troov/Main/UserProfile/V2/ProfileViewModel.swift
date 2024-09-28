//
//  ProfileViewModel.swift
//  Troov
//
//  Created by Leo on 28.03.23.

import Foundation

@Observable class ProfileViewModel {
    static let shared = ProfileViewModel()
    private let service = TUserService()

    var adminUserProfile: UserProfile?
    
    private(set) var user: User?

    func updateHeight(height: Int) async throws {
        if let profile = user?.userProfile {
            if profile.height?.length != height {
                await MainActor.run {
                    user?.userProfile?.height = .init(length: height, unit: ._in)
                }
                try await updateUserProfile()
            }
        } else {
            await MainActor.run {
                user?.userProfile = .init()
                user?.userProfile?.height = .init(length: height, unit: ._in)
            }
            try await updateUserProfile()
        }
    }
    
    func updateAge(age: Int64) async throws {
        if let profile = user?.userProfile {
            if profile.age != age {
                await MainActor.run {
                    user?.userProfile?.age = age
                }
                try await updateUserProfile()
            }
        } else {
            await MainActor.run {
                user?.userProfile = .init()
                user?.userProfile?.age = age
            }
            try await updateUserProfile()
        }
    }

    func update(occupation: String) async throws {
        if let profile = user?.userProfile {
            if profile.occupation?.uppercased() != occupation.uppercased() {
                await MainActor.run {
                    user?.userProfile?.occupation = occupation
                }
                try await updateUserProfile()
            }
        } else {
            await MainActor.run {
                user?.userProfile = .init()
                user?.userProfile?.occupation = occupation
            }
            try await updateUserProfile()
        }
    }
    
    func update(firstName: String) async throws {
        if let profile = user?.userProfile {
            if profile.firstName?.uppercased() != firstName.uppercased() {
                /**
                 Shouldn't we keep only one firstName?
                 */
                await MainActor.run {
                    user?.firstName = firstName
                    user?.userProfile?.firstName = firstName
                }
                try await updateUserProfile()
            }
        } else {
            await MainActor.run {
                user?.userProfile = .init()
                /**
                 Shouldn't we keep only one firstName?
                 */
                user?.firstName = firstName
                user?.userProfile?.firstName = firstName
            }
            try await updateUserProfile()
        }
    }
    
    func update(gender: String) async throws {
        if let profile = user?.userProfile {
            if profile.gender?.rawValue.cleanEnums.uppercased() != gender.uppercased() {
                await MainActor.run {
                    user?.userProfile?.gender = .init(rawValue: gender.withEnums)
                }
                try await updateUserProfile()
            }
        } else {
            await MainActor.run {
                user?.userProfile = .init()
                user?.userProfile?.gender = .init(rawValue: gender.withEnums)
            }
            try await updateUserProfile()
        }
    }
    
    func update(education: String) async throws {
        if let profile = user?.userProfile {
            if profile.education?.rawValue.cleanEnums.uppercased() != education.uppercased() {
                await MainActor.run {
                    user?.userProfile?.education = .init(rawValue: education.withEnums)
                }
                try await updateUserProfile()
            }
        } else {
            await MainActor.run {
                user?.userProfile = .init()
                user?.userProfile?.education = .init(rawValue: education.withEnums)
            }
            try await updateUserProfile()
        }
    }
    
    func update(religion: String) async throws {
        if let profile = user?.userProfile {
            if profile.religion?.rawValue.cleanEnums.uppercased() != religion.uppercased() {
                await MainActor.run {
                    user?.userProfile?.religion = .init(rawValue: religion.withEnums)
                }
                try await updateUserProfile()
            }
        } else {
            await MainActor.run {
                user?.userProfile = .init()
                user?.userProfile?.religion = .init(rawValue: religion.withEnums)
            }
            try await updateUserProfile()
        }
    }
    
    func update(ethnicity: [String]) async throws {
        if let profile = user?.userProfile {
            if profile.ethnicity?.map({$0.rawValue.cleanEnums.uppercased()}) != ethnicity.map({$0.uppercased()}) {
                await MainActor.run {
                    user?.userProfile?.ethnicity = ethnicity
                        .filter({Ethnicity(rawValue: $0.withEnums) != nil})
                        .map({Ethnicity(rawValue: $0.withEnums)!})
                }
                try await updateUserProfile()
            }
        } else {
            await MainActor.run {
                user?.userProfile = .init()
                user?.userProfile?.ethnicity = ethnicity
                    .filter({Ethnicity(rawValue: $0.withEnums) != nil})
                    .map({Ethnicity(rawValue: $0.withEnums)!})
            }
            try await updateUserProfile()
        }
    }

    func update(politics: String) async throws {
        if let profile = user?.userProfile {
            if profile.politics?.rawValue.cleanEnums.uppercased() != politics.uppercased() {
                await MainActor.run {
                    user?.userProfile?.politics = .init(rawValue: politics.withEnums)
                }
                try await updateUserProfile()
            }
        } else {
            await MainActor.run {
                user?.userProfile = .init()
                user?.userProfile?.politics = .init(rawValue: politics.withEnums)
            }
            try await updateUserProfile()
        }
    }
    
    func cleanUp() {
        self.setUpdateLocalUser(nil)
    }
    
    func setUpdateUserLocalAndServer(user: User) {
        debugPrint("🧚‍♀️ =====>>>>  set user: \(user.userId) ")
        
        DispatchQueue.main.async {
            self.setUpdateLocalUser(user)
            self.updateUserNotificationToken()
        }
    }

    /**
     Set or Update user object only here
     */
    func setUpdateLocalUser(_ user: User?) {
        if let user = user {
            let previousStatus = self.user?.registrationStatus
            self.user = user
            /*
            Make sure to keep registration step completed
            */
            if previousStatus == .complete &&
               user.registrationStatus != .complete {
               self.user?.registrationStatus = .complete
           }
        } else {
            self.user = nil
        }
    }

     func updateUserNotificationToken() {
        self.user?.assignNotificationTokenLocally()
        if let _user = self.user {
            Task {
                await ProfileViewModel.shared.updateUserAccountOnServer(user: _user)
            }
        }
    }
    
    
    func updateUserAccountOnServer(user: User) async {
       await service.updateUserAccount(user)
    }
    
   @MainActor private func updateUserProfile() async throws {
        guard let profile = user?.userProfile else { return }
        switch await service.update(userProfile: profile) {
        case .success:
            self.user?.userProfile = profile
        case .failure(let error):
            debugPrint("🧚‍♀️ =====>>>>  update user profile erro: \(String(describing: error))".uppercased())
            throw error
        }
    }
}

extension ProfileViewModel {    
   @discardableResult class func asyncGetUser() async -> User? {
        switch await ProfileViewModel.shared.service.user() {
        case .success(let user):
            return user
        case .failure(let error):
            debugPrint(String(describing: error))
            return nil
        }
    }
    
    class func setUpdateUserLocalAndServer(user: User) {
        ProfileViewModel.shared.setUpdateUserLocalAndServer(user: user)
    }
    
    class func create(user: User) async throws {
        switch await shared.service.create(user: user) {
        case .success(let response):
            debugPrint(" =====>> Create User Response: \(response)")
            setUpdateUserLocalAndServer(user: user)
        case .failure(let failure):
            throw TRequestError.custom(message: failure.message)
        }
    }

    class func updateRegistration(step: RegistrationStep) async {
        if var user = await asyncGetUser() {
            user.registrationStatus = step
            setUpdateUserLocalAndServer(user: user)
        }
    }
}
