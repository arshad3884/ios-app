//
//  RelationshipInterest+Extensions.swift
//  Troov
//
//  Created by Levon Arakelyan on 19.03.24.
//

import Foundation

extension RelationshipInterest {
    
    static var relationshipInterestCasesToDisplay = [RelationshipInterest.friendship,
                                                     RelationshipInterest.datingLongTerm,
                                                     RelationshipInterest.collaboration]
    
    static var relationshipInterestCasesToFilter = [RelationshipInterest.datingShortTerm,
                                                    RelationshipInterest.datingLongTerm,
                                                    RelationshipInterest.friendship,
                                                    RelationshipInterest.collaboration]
    
    var generalUsageRawValue: String {
        switch self {
        case .datingShortTerm, .datingLongTerm:
            return "DATING".cleanEnums
        case .friendship:
            return rawValue.cleanEnums
        case .collaboration:
            return rawValue.cleanEnums
        default:
            /*
             TODO: - replace with logging with Datadog
             */
            debugPrint("New missing RelationshipInterest")
            return ""
        }
    }
    
    var filterUsageRawValue: String {
        switch self {
        case .datingShortTerm:
            return "Casual Dating"
        case .datingLongTerm:
            return "Romantic Partnership"
        default:
            return rawValue.cleanEnums
        }
    }

    init(generalUsageRawValue: String) {
        if generalUsageRawValue == "DATING".cleanEnums {
            self = .datingShortTerm
        } else if generalUsageRawValue == RelationshipInterest.friendship.rawValue.cleanEnums {
            self = .friendship
        } else {
            self = .collaboration
        }
    }
    
    init(filterUsageRawValue: String) {
        if filterUsageRawValue == "Casual Dating" {
            self = .datingShortTerm
        } else if filterUsageRawValue == "Romantic Partnership" {
            self = .datingLongTerm
        } else {
            self = RelationshipInterest(rawValue: filterUsageRawValue.withEnums) ?? .friendship
        }
    }

    static var registrationGeneralInfo: [String] {
        var relationshipInterestTexts = Self.relationshipInterestCasesToDisplay.map({$0.generalUsageRawValue})
        relationshipInterestTexts.append("OPEN_TO_ANYTHING".cleanEnums)
        return relationshipInterestTexts
    }

    /*
     TODO: - Try to replace enum inits with dict key-value at some point, if it's better that way
    var registrationRelationshipMapping: Dictionary<String, [RelationshipInterest]> {
        ["Dating": [RelationshipInterest.datingShortTerm, .datingLongTerm],
         "Friendship": [RelationshipInterest.friendship],
         "Collaboration": [RelationshipInterest.collaboration],
         "Open To Anything": RelationshipInterest.allCases]
    }
     */
    
    static func convertIntoRelationshipInterests(keys: [String]) -> [RelationshipInterest] {
        var relationshipInterests: [RelationshipInterest] = []
        
        if keys.contains("OPEN_TO_ANYTHING".cleanEnums) {
            relationshipInterests = RelationshipInterest.allCases
        } else {
            for key in keys {
                if key == "DATING".cleanEnums {
                    relationshipInterests.append(contentsOf: [RelationshipInterest.datingLongTerm, .datingShortTerm])
                } else {
                    relationshipInterests.append(RelationshipInterest(generalUsageRawValue: key))
                }
            }
        }
        return Array(Set(relationshipInterests))
    }
}
