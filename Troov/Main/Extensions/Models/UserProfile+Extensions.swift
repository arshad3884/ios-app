//
//  UserProfile+Extensions.swift
//  Troov
//
//  Created by Leo on 04.04.23.
//

import Foundation

extension UserProfile {
    init() {}

    private var userId: String? {
        return ProfileViewModel.shared.user?.userId
    }
    
    var images: [TServerImage] {
        return profileMedia?.map({ $0.serverImage(by: userId ?? "" )}) ?? []
    }
    
    var allProperiesAreNil: Bool {
        return firstName == nil &&
        gender == nil &&
        interestedIn == nil &&
        age == nil &&
        education == nil &&
        almaMater == nil &&
        politics == nil &&
        religion == nil &&
        // race == nil && // TODO: Add back
        occupation == nil &&
        company == nil &&
        profileMedia == nil &&
        numDatesCompleted == nil &&
        numDatesFlaked == nil &&
        bio == nil &&
        activityInterests == nil &&
        ethnicity == nil &&
        height == nil &&
        lowResThumbnail == nil &&
        relationshipInterests == nil &&
        verified == nil
    }
    
    var userProfileWithUserId: UserProfileWithUserId? {
        UserProfileWithUserId(userProfile: self)
    }

    static var preview: UserProfile {
        var profile = UserProfile()
        profile.age = 18
        profile.bio = "Test bio"
        profile.company = "Test company"
        profile.education = .masters
        profile.ethnicity = [.black]
        profile.firstName = "Test"
        profile.gender = .male
        profile.interestedIn = [.female]
        profile.numDatesCompleted = 0
        profile.numDatesFlaked = 0
        profile.occupation = "Test"
        profile.profileMedia = []
        profile.politics = .liberal
        profile.relationshipInterests = [.datingLongTerm]
        profile.religion = .christian
        profile.verified = true
        return profile
    }
}
