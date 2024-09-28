//
//  ProfileEditMenuItem.swift
//  Troov
//
//  Created by  Levon Arakelyan on 19.09.2023.
//

import Foundation

enum ProfileEditMenuItem: String, CaseIterable {
    case name
    case gender
    case height
    case age
    case education
    case occupation
    case religion
    case ethnicity
    case politics
    
    var profileDetailsEditorMenuName: String {
        switch self {
        case .name: return "Name"
        case .gender: return "Gender"
        case .height: return "Height"
        case .education: return "Education"
        case .occupation: return "Occupation"
        case .religion: return "Religion"
        case .ethnicity: return "Ethnicity"
        case .politics: return "Politics"
        case .age: return "Age"
        }
    }
    
    var editTitle: String {
        switch self {
        case .name: return "Edit Your Name"
        case .gender: return "Edit Your Gender"
        case .height: return "Edit Your Height"
        case .education: return "Edit Your Education Level"
        case .occupation: return "Edit Your Occupation"
        case .religion: return "Edit Your Religion"
        case .ethnicity: return "Edit Your Ethnicity (Select all that apply)"
        case .politics: return "Edit Your Political Preference"
        case .age:
            return "Edit Your Age"
        }
    }
    
    func profileDetailsEditorMenuValue(userProfile: UserProfile?) -> String {
        switch self {
        case .name: return userProfile?.firstName ?? ""
        case .gender: return userProfile?.gender?.rawValue ?? ""
        case .education: return userProfile?.education?.rawValue ?? ""
        case .occupation: return userProfile?.occupation ?? ""
        case .religion: return userProfile?.religion?.rawValue ?? ""
        case .ethnicity: return userProfile?.ethnicity?.map({$0.rawValue.cleanEnums})
                .joined(separator: ", ") ?? ""
        case .politics: return userProfile?.politics?.rawValue ?? ""
        case .height:
            if let length = userProfile?.height?.length {
                return "\(ProfileFilterAttributesMinHeight.heightString(of: Double(length))) ft"
            }
            return ""
        case .age:
            if let age = userProfile?.age {
                return "\(age)"
            }
            return ""
        }
    }
    
    var generalInfo: [String] {
        switch self {
        case .gender:
            return Gender.allCases.map({$0.rawValue.cleanEnums})
        case .ethnicity:
            return Ethnicity.allCases.map({$0.rawValue.cleanEnums})
        case .politics:
            return PoliticalAffiliation.allCases.map({$0.rawValue.cleanEnums})
        case .religion:
            return Religion.allCases.map({$0.rawValue.cleanEnums})
        case .education:
            return Education.allCases.map({$0.rawValue.cleanEnums})
        default:
            return []
        }
    }

    var fraction: Double {
        switch self {
        case .name, .occupation:
            return 0.5
        case .gender:
            return 0.6
        case .height, .age:
            return 0.4
        case .religion, .ethnicity:
            return 1
        case .politics, .education:
            return 0.8
        }
    }
}
