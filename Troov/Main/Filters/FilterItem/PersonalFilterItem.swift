//
//  PersonalFilterItem.swift
//  Troov
//
//  Created by  Levon Arakelyan on 20.09.2023.
//

import SwiftUI

enum PersonalFilterItem: Identifiable, Equatable, CaseIterable {

    var id: String {
        switch self {
        case .education(let items): return items?.map({$0.rawValue}).joined(separator: ", ") ?? name
        case .religion(let items): return items?.map({$0.rawValue}).joined(separator: ", ") ?? name
        case .ethnicity(let items): return items?.map({$0.rawValue}).joined(separator: ", ") ?? name
        case .gender(let items): return items?.map({$0.rawValue}).joined(separator: ", ") ?? name
        case .politics(let items): return items?.map({$0.rawValue}).joined(separator: ", ") ?? name
        }
    }
    
    static func == (lhs: PersonalFilterItem, rhs: PersonalFilterItem) -> Bool {
        switch (lhs, rhs) {
        case (.education(let item), .education(let item1)):
            return item == item1
        case (.religion(let items), .religion(let items1)):
            return items == items1
        case (.ethnicity(let item), .ethnicity(let item1)):
            return item == item1
        case (.gender(let item), .gender(let item1)):
            return item == item1
        case (.politics(let item), .politics(let item1)):
            return item == item1
        default:
            return lhs.id == rhs.id
        }
    }
    
    static var allCases: [PersonalFilterItem] {
        return [.education(),
                .religion(),
                .ethnicity(),
                .gender(),
                .politics()]
    }
    
    case education(_ selection: [Education]? = nil)
    case religion(_ selection: [Religion]? = nil)
    case ethnicity(_ selection: [Ethnicity]? = nil)
    case gender(_ selection: [Gender]? = nil)
    case politics(_ selection: [PoliticalAffiliation]? = nil)
    
    var name: String {
        switch self {
        case .education: return "Education"
        case .religion: return "Religion"
        case .ethnicity: return "Ethnicity"
        case .gender: return "Gender"
        case .politics: return "Politics"
        }
    }
    
    var generalInfo: [String] {
        switch self {
        case .education:
            return Education.allCases.map({$0.rawValue})
        case .religion:
            return Religion.allCases.map({$0.rawValue})
        case .ethnicity:
            return Ethnicity.allCases.map({$0.rawValue})
        case .gender:
            return Gender.allCases.map({$0.rawValue})
        case .politics:
            return PoliticalAffiliation.allCases.map({$0.rawValue})
        }
    }

    var filtered: String? {
        switch self {
        case .education(let items):
            return items?.map({$0.rawValue}).joined(separator: ", ")
        case .religion(let items):
            return items?.map({$0.rawValue}).joined(separator: ", ")
        case .ethnicity(let items):
            return items?.map({$0.rawValue}).joined(separator: ", ")
        case .gender(let items):
            return items?.map({$0.rawValue}).joined(separator: ", ")
        case .politics(let items):
            return items?.map({$0.rawValue}).joined(separator: ", ")
        }
    }
    
    var filteredArray: [String]? {
        switch self {
        case .education(let items):
            return items?.map({$0.rawValue})
        case .religion(let items):
            return items?.map({$0.rawValue})
        case .ethnicity(let items):
            return items?.map({$0.rawValue})
        case .gender(let items):
            return items?.map({$0.rawValue})
        case .politics(let items):
            return items?.map({$0.rawValue})
        }
    }

    var detents: Set<PresentationDetent> {
        var itemsCount: Int = 0
        switch self {
        case .education:
            itemsCount = Education.allCases.count
        case .religion:
            itemsCount = Religion.allCases.count
        case .ethnicity:
            itemsCount = Ethnicity.allCases.count
        case .gender:
            itemsCount = Gender.allCases.count
        case .politics:
            itemsCount = PoliticalAffiliation.allCases.count
        }
        
        let div = CGFloat(itemsCount)/8.0
        let min = min(div, 1.0)
        return [.fraction(min)]
    }
}

extension PersonalFilterItem {
    init?(item: PersonalFilterItem,
          info: [String]) {
        switch item {
        case .education:
            if info.count > 0 {
                var educations: [Education] = []
                info.forEach { info in
                    if let education = Education(rawValue: info) {
                        educations.append(education)
                    }
                }
                if educations.count > 0 {
                    self = PersonalFilterItem.education(educations)
                    return
                }
            }
        case .ethnicity:
            if info.count > 0 {
                var ethnicities: [Ethnicity] = []
                info.forEach { info in
                    if let ethnicity = Ethnicity(rawValue: info) {
                        ethnicities.append(ethnicity)
                    }
                }
                if ethnicities.count > 0 {
                    self = PersonalFilterItem.ethnicity(ethnicities)
                    return
                }
            }
        case .gender:
            if info.count > 0 {
                var genders: [Gender] = []
                info.forEach { info in
                    if let gender = Gender(rawValue: info) {
                        genders.append(gender)
                    }
                }
                if genders.count > 0 {
                    self = PersonalFilterItem.gender(genders)
                    return
                }
            }
        case .politics:
            if info.count > 0 {
                var politics: [PoliticalAffiliation] = []
                info.forEach { info in
                    if let politic = PoliticalAffiliation(rawValue: info) {
                        politics.append(politic)
                    }
                }
                if politics.count > 0 {
                    self = PersonalFilterItem.politics(politics)
                    return
                }
            }
        case .religion:
            if info.count > 0 {
                var religions: [Religion] = []
                info.forEach { info in
                    if let religion = Religion(rawValue: info) {
                        religions.append(religion)
                    }
                }
                if religions.count > 0 {
                    self = PersonalFilterItem.religion(religions)
                    return
                }
            }
        }
        return nil
    }

    init(emptyItem: PersonalFilterItem) {
        switch emptyItem {
        case .education:
            self = PersonalFilterItem.education(nil)
        case .ethnicity:
            self = PersonalFilterItem.ethnicity(nil)
        case .gender:
            self = PersonalFilterItem.gender(nil)
        case .politics:
            self = PersonalFilterItem.politics(nil)
        case .religion:
            self = PersonalFilterItem.religion(nil)
        }
    }

    init?(filterType: DiscoverFilterSettings.FilterType, data: [String]?) {
        switch filterType {
        case .education:
            let education = data?
                .filter({Education(rawValue: $0) != nil})
                .map({Education(rawValue: $0)!})
            self = PersonalFilterItem.education(education)
        case .religion:
            let religion = data?
                .filter({Religion(rawValue: $0) != nil})
                .map({Religion(rawValue: $0)!})
            self = PersonalFilterItem.religion(religion)
        case .ethnicity:
            let ethnicity = data?
                .filter({Ethnicity(rawValue: $0) != nil})
                .map({Ethnicity(rawValue: $0)!})
            self = PersonalFilterItem.ethnicity(ethnicity)
        case .gender:
            let gender = data?
                .filter({Gender(rawValue: $0) != nil})
                .map({Gender(rawValue: $0)!})
            self = PersonalFilterItem.gender(gender)
        case .politics:
            let politics = data?
                .filter({PoliticalAffiliation(rawValue: $0) != nil})
                .map({PoliticalAffiliation(rawValue: $0)!})
            self = PersonalFilterItem.politics(politics)
        default:
            return nil
        }
    }
}

extension PersonalFilterItem {
    func selfTypeIsEqual(type: PersonalFilterItem) -> Bool {
        switch (self, type) {
        case (.education, .education):
            return true
        case (.religion, .religion):
            return true
        case (.ethnicity, .ethnicity):
            return true
        case (.gender, .gender):
            return true
        case (.politics, .politics):
            return true
        default:
            return false
        }
    }
    
    func selfTypeIsEqualToAnother(type: DiscoverFilterSettings.FilterType) -> Bool {
        switch (self, type) {
        case (.education, .education):
            return true
        case (.religion, .religion):
            return true
        case (.ethnicity, .ethnicity):
            return true
        case (.gender, .gender):
            return true
        case (.politics, .politics):
            return true
        default:
            return false
        }
    }
}
