//
//  CreateTroovViewModel.swift
//  mango
//
//  Created by Leo on 26.02.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

@Observable class CreateTroovViewModel: AppProtocol {
     private(set) var troov: Troov?
     private var validationState: ValidationState = .valid
     private(set) var triggerValidationAttention = false

     var previewCellIsBig = true
     var createHashtag = false
     var keyboardPadding: CGFloat = 0

    var isNextAllowed: Bool {
        validationState == .valid
    }
    
    func allowNext() -> Bool {
        if validationState == .valid {
            return true
        } else {
            triggerValidationAttention.toggle()
            hapticFeedback()
            return false
        }
    }

    func initialSetup(troov: Troov? = nil) {
        guard let userProfileWithUserId = ProfileViewModel.shared.user?.userProfile?.userProfileWithUserId else { return }
        if let troov = troov {
            self.troov = troov
        } else {
            self.troov = .init(troovId: UUID().uuidString,
                               createdBy: userProfileWithUserId)
        }
    }

    func save(title: String) {
        setupTroov()
        troov?.troovCoreDetails?.title = title
    }

    func save(rating: ExpenseRating?,
              and details: String) {
        setupTroov()
        troov?.troovCoreDetails?.expenseRating = rating
        troov?.troovCoreDetails?.details = details
    }

    func saveGeneralInfo(date: Date?,
                         location: Location?,
                         locationIsHidden: Bool,
                         ineterstedIn: [String],
                         tags: [String]) {
        setupTroov()
        save(location: location)
        troov?.locationDetails?.hidden = locationIsHidden
        troov?.troovCoreDetails?.startTime = date
        troov?.troovCoreDetails?.tags = tags
        troov?.troovCoreDetails?.relationshipInterests = ineterstedIn.map({RelationshipInterest(filterUsageRawValue: $0)})
    }

    func save(location: Location?) {
        setupTroov()

        troov?.locationDetails?.location = location
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

    private func setupTroov() {
        if troov?.troovCoreDetails == nil {
            troov?.troovCoreDetails = .init()
        }
    
        if troov?.locationDetails == nil {
            troov?.locationDetails = .init()
        }
    }
}

extension CreateTroovViewModel {
    enum Response {
        case success
        case failure
        case moderationFailure
    }
}
