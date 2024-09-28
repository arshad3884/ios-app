//
//  UserProfileWithUserId+Extension.swift
//  Troov
//
//  Created by Chad Newbry on 6/16/23.
//

import Foundation

extension UserProfileWithUserId {    
    init?(userProfile: UserProfile) {
        guard let userId = ProfileViewModel.shared.user?.userId else {
            return nil
        }
        self.age = userProfile.age
        self.almaMater = userProfile.almaMater
        self.bio = userProfile.bio
        self.company = userProfile.company
        self.education = userProfile.education
        self.ethnicity = userProfile.ethnicity
        self.firstName = userProfile.firstName
        self.gender = userProfile.gender
        self.height = userProfile.height
        self.interestedIn = userProfile.interestedIn
        self.numDatesCompleted = userProfile.numDatesCompleted
        self.numDatesFlaked = userProfile.numDatesFlaked
        self.occupation = userProfile.occupation
        self.profileMedia = userProfile.profileMedia
        self.politics = userProfile.politics
        self.relationshipInterests = userProfile.relationshipInterests
        self.religion = userProfile.religion
        self.verified = userProfile.verified
        self.userId = userId
    }

    var images: [TServerImage] {
        profileMedia?.map({ $0.serverImage(by: userId)}) ?? []
    }
}
