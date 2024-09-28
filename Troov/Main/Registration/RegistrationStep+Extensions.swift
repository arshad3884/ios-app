//
//  RegistrationStep+Extensions.swift
//  Troov
//
//  Created by Leo on 01.09.2023.
//

import Foundation

extension RegistrationStep {
    
    static var readOnlyBrowsingCases: [String] { return ["CREATE_PROFILE", "DO_IT_LATER"] }
    static var firstStep: RegistrationStep { return allStepsInOrder[0] }
    
    static var allStepsInOrder: [RegistrationStep] {
        return [.relationshipInterests,
                .activityInterests,
                .readOnlyBrowsing,
                .phoneNumber,
                .codeSent,
                .codeReceived,
                .nameAndBirthday,
                .gender,
                .almaMaterOccupationCompany,
                .height,
                .education,
                .religion,
                .politics,
                .ethnicity,
                .imageUpload,
                .complete]
    }
    
    var progress: Double {
        let allCases = Self.allStepsInOrder
        if let index = allCases.firstIndex(of: self) {
            return Double(index)*(100.0/Double(allCases.count))
        }
        return 0
    }
    
    var index: Int {
        switch self {
        case .readOnlyBrowsing:
            return 2
        case .phoneNumber, .codeSent, .codeReceived, .marketingChannels:
            return 3
        case .relationshipInterests:
            return 0
        case .activityInterests:
            return 1
        case .nameAndBirthday:
            return 3
        case .gender:
            return 3
        case .almaMaterOccupationCompany:
            return 4
        case .height:
            return 5
        case .education:
            return 5
        case .ethnicity:
            return 5
        case .politics:
            return 5
        case .religion:
            return 5
        case .imageUpload:
            return 6
        case .tutorial:
            return 0
        case .complete:
            return 0
        default: return 0
        }
    }
    
    var progressIndicatorsCount: Int {
        switch self {
        case .readOnlyBrowsing, .tutorial, .complete:
            return 0
        case .phoneNumber,
             .codeSent,
             .codeReceived,
             .nameAndBirthday,
             .gender,
             .almaMaterOccupationCompany,
             .education,
             .height,
             .ethnicity,
             .politics,
             .religion,
             .imageUpload,
             .marketingChannels,
             .relationshipInterests,
             .activityInterests:
            return 7
        default: return 0
        }
    }
    
    var image: String {
        switch self {
        case .phoneNumber, .codeSent, .codeReceived: return "iphone.icon"
        case .marketingChannels, .relationshipInterests: return "t.light.bulb.fill"
        case .nameAndBirthday, .gender: return "person.circle"
        case .ethnicity, .politics, .religion, .height: return "person.heart.circle"
        case .education, .almaMaterOccupationCompany: return "t.education.fill.circle"
        case .imageUpload: return "image.icon"
        case .complete, .activityInterests, .tutorial: return ""
        case .readOnlyBrowsing: return "t.light.bulb.fill"
        default: return ""
        }
    }
    
    var title: String {
        switch self {
        case .phoneNumber, .codeSent, .codeReceived: return "Verify Your Phone Number"
        case .ethnicity, .politics, .religion, .height, .education: return "Dating Profile"
        case .nameAndBirthday, .gender: return "Personal Information"
        case .almaMaterOccupationCompany: return "Professional Information"
        case .imageUpload: return "Add Your Pictures"
        case .activityInterests: return "Interests"
        case .complete, .relationshipInterests, .marketingChannels, .tutorial: return ""
        default: return ""
        }
    }

    var canSkip: Bool {
        [RegistrationStep.ethnicity, .politics, .religion, .height, .education].contains(self)
    }
    
    var bodyTitle: String {
        switch self {
        case .gender: return "With which gender do you identify?"
        case .ethnicity: return "Select Your Ethnicity (Select all that apply)"
        case .politics: return "Select Your Political Preference"
        case .religion: return "Select Your Religion"
        case .education: return "Select Your Education Level"
        case .height:
            return "Select Your Height"
        case .marketingChannels: return "How did you find out about us?"
        case .relationshipInterests: return "Troov lets you propose one-on-one activities to our community. Tell us a little more about your goals:"
        case .activityInterests: return "Troov is all about making meaningful connections doing what you love so please share with us what you do for fun:"
        case .readOnlyBrowsing: return "To create or join a one-on-one activity idea or troov, you need a profile, but you can still browse all active troovs without one."
        default: return ""
        }
    }
    
    var highlightedTextInTitle: String {
        switch self {
        case .relationshipInterests:
            return "one-on-one activities"
        case .activityInterests:
            return "doing what you love"
        case .readOnlyBrowsing:
            return "one-on-one activity idea or troov"
        default:
            return ""
        }
    }
    
    var buttonName: String {
        switch self {
        case .phoneNumber: return "Send Me One-Time Passcode"
        case .complete, .tutorial: return "Continue"
        default: return "Next"
        }
    }
    
    func next() -> RegistrationStep? {
        let allCases = RegistrationStep.allStepsInOrder
        if let index = allCases.firstIndex(of: self), index < allCases.count - 1 {
            return allCases[index + 1]
        }
        return nil
    }
    
    func previous() -> RegistrationStep? {
        let allCases = RegistrationStep.allStepsInOrder
        if let index = allCases.firstIndex(of: self), index > 0 {
            return allCases[index - 1]
        }
        return nil
    }

    func isHigherInOrder(than step: RegistrationStep) -> Bool {
        let allCases = RegistrationStep.allStepsInOrder
        if let selfIndex = allCases.firstIndex(of: self),
           let index = allCases.firstIndex(of: step) {
            return selfIndex > index
        }
        return false
    }
    
    var generalInfo: [String] {
        switch self {
        case .gender:
            return Gender.allCases.map({$0.rawValue})
        case .ethnicity:
            return Ethnicity.allCases.map({$0.rawValue})
        case .politics:
            return PoliticalAffiliation.allCases.map({$0.rawValue})
        case .religion:
            return Religion.allCases.map({$0.rawValue})
        case .education:
            return Education.allCases.map({$0.rawValue})
        case .marketingChannels:
            return MarketingChannels.allCases.map({$0.rawValue})
        case .relationshipInterests:
            return RelationshipInterest.registrationGeneralInfo
        case .readOnlyBrowsing:
            return RegistrationStep.readOnlyBrowsingCases
        default:
            return []
        }
    }
    
    func generateGeneralInfo(info: [String], userProfile: UserProfile) -> UserProfile? {
        guard info.count > 0 else { return nil }
        switch self {
        case .gender:
            if let item = Gender(rawValue: info[0]) {
                var profile = userProfile
                profile.gender = item
                return profile
            }
        case .ethnicity:
            let items = info.map({Ethnicity(rawValue: $0)!})
            var profile = userProfile
            profile.ethnicity = items
            return profile
        case .politics:
            if let item = PoliticalAffiliation(rawValue: info[0]) {
                var profile = userProfile
                profile.politics = item
                return profile
            }
        case .religion:
            if let item = Religion(rawValue: info[0]) {
                var profile = userProfile
                profile.religion = item
                return profile
            }
        case .education:
            if let item = Education(rawValue: info[0]) {
                var profile = userProfile
                profile.education = item
                return profile
            }
        case .relationshipInterests:
            var profile = userProfile
            profile.relationshipInterests = RelationshipInterest.convertIntoRelationshipInterests(keys: info)
            return profile
        default:
            return nil
        }
        return nil
    }
    
    func generateGeneralInfo(info: [String], user: User) -> User? {
        guard info.count > 0 else { return nil }
        switch self {
        case .marketingChannels:
            if let item = MarketingChannels(rawValue: info[0]) {
                var user = user
                user.heardOfTroovFrom = item
                return user
            }          
        default:
            return nil
        }
        return nil
    }

    func getGeneralInfo(userProfile: UserProfile) -> [String] {
        switch self {
        case .gender:
            if let item = userProfile.gender {
                return [item.rawValue]
            }
        case .ethnicity:
            if let item = userProfile.ethnicity {
                return item.map({$0.rawValue})
            }
        case .politics:
            if let item = userProfile.politics {
                return [item.rawValue]
            }
        case .religion:
            if let item = userProfile.religion {
                return [item.rawValue]
            }
        case .education:
            if let item = userProfile.education {
                return [item.rawValue]
            }
        case .relationshipInterests:
            if let interests = userProfile.relationshipInterests {
                if interests.count >= RelationshipInterest.allCases.count {
                    return ["OPEN_TO_ANYTHING".cleanEnums]
                } else {
                    return interests.map { $0.generalUsageRawValue }
                }
            }
        default:
            return []
        }
        return []
    }
    
    func getGeneralInfo(user: User) -> [String] {
        switch self {
        case .marketingChannels:
            if let item = user.heardOfTroovFrom {
                return [item.rawValue]
            }
        default:
            return []
        }
        return []
    }
}
