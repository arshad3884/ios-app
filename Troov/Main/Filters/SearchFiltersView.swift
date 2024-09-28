//
//  SearchFiltersView.swift
//  Troov
//
//  Created by  Levon Arakelyan on 20.09.2023.
//

import SwiftUI

struct SearchFiltersView: View {
    let applyFilters: () -> ()
    
    @Environment(\.dismiss) private var dismiss
    /**
     Filters
     */
    @State private var location: Location?
    @State private var distance: TroovCoreDetailFilterAttributesMaximumDistance?
    @State private var personalFilters: [PersonalFilterItem] = PersonalFilterItem.allCases
    @State private var costInfo = CostInfoSheetView.Info(selectedTags: [])
    @State private var selectedDays: [String] = []
    @State private var selectedTimes: [String] = []
    @State private var selectedInterestedIn: [String] = []
    @State private var minAge: Int?
    @State private var maxAge: Int?
    @State private var minHeight: Int?
    @State private var maxHeight: Int?

    /**
     TextField Filters
     */
    @State private var filters: [DiscoverFilterSettings.Filter] = []
    
    private let interestedIn: [String] = RelationshipInterest.relationshipInterestCasesToFilter.map({$0.filterUsageRawValue})
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PrimaryTopToolbarView(title: "Search filters",
                                  action: { dismiss() })
            ScrollView(.vertical, showsIndicators: false) {
                if filters.count > 0 {
                    SearchFiltersTextFieldView(filters: $filters,
                                               cleanAction: clearAllAction)
                        .padding(.top, 15)
                }
                HStack {
                    Text("Relationship Interests")
                        .fontWithLineHeight(font: .poppins700(size: 16), lineHeight: 16)
                        .foregroundColor(.black)
                        .padding(.horizontal, 8)
                    Spacer()
                }.padding(.top, 16)
                TTagsView(tags: interestedIn,
                          selectedTags: $selectedInterestedIn)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 16)
                SearchActivityFiltersView(location: $location,
                                          distance: $distance,
                                          costInfo: $costInfo,
                                          selectedDays: $selectedDays,
                                          selectedTimes: $selectedTimes)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Personal Detail Filters")
                        .fontWithLineHeight(font: .poppins700(size: 16), lineHeight: 16)
                        .foregroundColor(.black)
                    AgeAndHeightFiltersView(minAge: $minAge,
                                            maxAge: $maxAge,
                                            minHeight: $minHeight,
                                            maxHeight: $maxHeight)
                    .onChange(of: minAge) { _, _ in
                        onAgeChange()
                    }
                    .onChange(of: maxAge) { _, _ in
                        onAgeChange()
                    }.onChange(of: minHeight) { _, _ in
                        onHeightChange()
                    }.onChange(of: maxHeight) { _, _ in
                        onHeightChange()
                    }
                    SearchPersonalFiltresView(items: $personalFilters)
                }.padding(.horizontal, 8)
            }
            HStack(spacing: 10) {
                Button(action: applyFiltersAction,
                       label: {
                    if filters.count > 0 {
                        TPrimaryLabel(text: "Apply Filters", height: 54)
                    } else {
                        TSecondaryLabel(text: "Apply Filters", height: 54)
                    }
                })
                .buttonStyle(.scalable)

                Button(action: clearAllAction,
                       label: {
                    TSecondaryLabel(text: "Clear All", height: 54)
                })
                .buttonStyle(.scalable)
                .padding(.leading, 30)
            }
            
            .padding(.top, 34)
            .padding(.horizontal, 20)
        }
        .task {
            await task()
        }
        .background(Color.white)
        .onChange(of: filters, { oldValue, newValue in
            filtersTextFieldChanged(oldValue, newValue)
        })
        .onChange(of: location) { _, newValue in
            if let name = newValue?.name {
                if let index = filters.firstIndex(where: {$0.type == .location}) {
                    filters[index].text = name
                } else {
                    filters.append(.init(type: .location, text: name))
                }
            } else {
                if let index = filters.firstIndex(where: {$0.type == .location}) {
                    filters.remove(at: index)
                }
            }
            
            updateFiltersSettings()
        }
        .onChange(of: distance) { _, newValue in
            if let length = newValue?.length,
               let distanceText = newValue?.distanceText {
                let hiddenValue = "\(length)"
                if let index = filters.firstIndex(where: {$0.type == .distance}) {
                    filters[index].text = distanceText
                    filters[index].hiddenValue = hiddenValue
                } else {
                    filters.append(.init(type: .distance, text: distanceText, hiddenValue: hiddenValue))
                }
            } else {
                if let index = filters.firstIndex(where: {$0.type == .distance}) {
                    filters.remove(at: index)
                }
            }
            updateFiltersSettings()
        }
        .onChange(of: costInfo.price) { _, newValue in
            if let index = filters.firstIndex(where: {$0.type == .cost}) {
                filters[index].text = newValue
            } else {
                filters.append(.init(type: .cost, text: newValue))
            }
            updateFiltersSettings()
        }
        .onChange(of: selectedDays) { oldValue, newValue in
            guard newValue != oldValue else { return }
            onDaysChanges()
        }
        .onChange(of: selectedTimes) { oldValue, newValue in
            guard newValue != oldValue else { return }
            onTimeChanges()
        }
        .onChange(of: personalFilters) { _, newValue in
            change(newValue)
        }.onChange(of: selectedInterestedIn) { _, _ in
            updateFiltersSettings()
        }
    }

    private func onDaysChanges() {
        filters.removeAll(where: {$0.type == .dates})
        for day in selectedDays {
            filters.append(.init(type: .dates, text: day.cleanEnums))
        }
        updateFiltersSettings()
    }
    
    private func onTimeChanges() {
        filters.removeAll(where: {$0.type == .time})
        for time in selectedTimes {
            filters.append(.init(type: .time, text: time.cleanEnums))
        }
        updateFiltersSettings()
    }
    
    private func onAgeChange() {
        filters.removeAll(where: {$0.type == .age})
        if let minAge = minAge, let maxAge = maxAge {
            filters.append(.init(type: .age, text: "Age \(minAge) - \(maxAge)"))
        }
        updateFiltersSettings()
    }
    
    private func onHeightChange() {
        filters.removeAll(where: {$0.type == .height})
        if let minHeight = minHeight, let maxHeight = maxHeight {
            filters.append(.init(type: .height,
                                 text: "\(ProfileFilterAttributesMinHeight.heightString(of: Double(minHeight)))ft - \(ProfileFilterAttributesMinHeight.heightString(of: Double(maxHeight)))ft"))
        }
        updateFiltersSettings()
    }
    
    private func filtersTextFieldChanged(_ oldValue: [DiscoverFilterSettings.Filter], _ newValue: [DiscoverFilterSettings.Filter]) {
        guard oldValue.count > newValue.count else { return }
        let difference = oldValue.difference(from: newValue)
        
        var personalFilterType: DiscoverFilterSettings.FilterType?
        var dateFilterType: DiscoverFilterSettings.FilterType?
        var timeFilterType: DiscoverFilterSettings.FilterType?
            for filter in difference {
                switch filter.type {
                case .relationship:
                    selectedInterestedIn = []
                case .location:
                    location = nil
                case .distance:
                    distance = nil
                case .cost:
                    costInfo = CostInfoSheetView.Info(selectedTags: [])
                case .dates:
                    dateFilterType = filter.type
                case .time:
                    timeFilterType = filter.type
                case .education, .religion, .ethnicity, .gender, .politics:
                    personalFilterType = filter.type
                    break
                case .age:
                    minAge = nil
                    maxAge = nil
                case .height:
                    minHeight = nil
                    maxHeight = nil
                }
            }
            
            if let dateFilterType = dateFilterType {
                let data = newValue
                    .filter({$0.type == dateFilterType})
                    .map({$0.text})
                self.selectedDays = data
            }
            
            if let timeFilterType = timeFilterType {
                let data = newValue
                    .filter({$0.type == timeFilterType})
                    .map({$0.text})
                self.selectedTimes = data
            }
        
            if let personalFilterType = personalFilterType {
                let data = newValue
                    .filter({$0.type == personalFilterType})
                    .map({$0.text})
                if !data.isEmpty {
                    if let item = PersonalFilterItem(filterType: personalFilterType,
                                                     data: data),
                       let index = personalFilters.firstIndex(where: {$0.selfTypeIsEqual(type: item)})  {
                        personalFilters[index] = item
                    }
                } else if let index = personalFilters.firstIndex(where: {$0.selfTypeIsEqualToAnother(type: personalFilterType)}),
                          let item = PersonalFilterItem(filterType: personalFilterType, data: nil) {
                    personalFilters[index] = item
                }
            }
    
         updateFiltersSettings()
    }
    
   @MainActor private func applyFiltersAction() {
       dismiss()
       applyFilters()
    }

    private func change(_ personalFilters: [PersonalFilterItem]) {
        personalFilters.forEach { item in
            switch item {
            case .education(let educations):
                filters.removeAll(where: {$0.type == .education})
                if let educations = educations {
                    for education in educations {
                        filters.append(.init(type: .education, text: education.rawValue))
                    }
                }
            case .religion(let religions):
                filters.removeAll(where: {$0.type == .religion})
                if let religions = religions {
                    for religion in religions {
                        filters.append(.init(type: .religion, text: religion.rawValue))
                    }
                }
            case .ethnicity(let ethnicities):
                filters.removeAll(where: {$0.type == .ethnicity})
                if let ethnicities = ethnicities {
                    for ethnicity in ethnicities {
                        filters.append(.init(type: .ethnicity, text: ethnicity.rawValue))
                    }
                }
            case .gender(let genders):
                filters.removeAll(where: {$0.type == .gender})
                if let genders = genders {
                    for gender in genders {
                        filters.append(.init(type: .gender, text: gender.rawValue))
                    }
                }
            case .politics(let politics):
                filters.removeAll(where: {$0.type == .politics})
                if let politics = politics {
                    for politic in politics {
                        filters.append(.init(type: .politics, text: politic.rawValue))
                    }
                }
            }
        }
        
        updateFiltersSettings()
    }
    
    private func clearAllAction() {
        Task {
            filters.removeAll()
            selectedInterestedIn.removeAll()
            location = nil
            distance = nil
            personalFilters = PersonalFilterItem.allCases
            costInfo = CostInfoSheetView.Info(selectedTags: [])
            selectedTimes = []
            selectedDays = []
            await SearchFilters.shared.setDefault()
        }
    }

    private func updateFiltersSettings() {
        Task {
            await SearchFilters.shared.update(location: location,
                                       distance: distance,
                                       personalFilters: personalFilters,
                                       costInfo: costInfo,
                                       selectedDays: selectedDays,
                                       selectedTimes: selectedTimes,
                                       selectedInterestedIn: selectedInterestedIn,
                                       minAge: minAge,
                                       maxAge: maxAge,
                                       minHeight: minHeight,
                                       maxHeight: maxHeight)
        }
    }

    private func task() async {
        if let localSettings = await SearchFilters.shared.fetchSettings() {
            let settings = localSettings.element2
            
            let troovFilters = settings.troovFilters

            if let coordinates = troovFilters.originCoordinates {
                self.location = .init(name: localSettings.locationName, coordinates: coordinates)
            }
            
            if let distance = troovFilters.maximumDistance {
                self.distance = distance
            }
            
            let profileFilterAttributes = settings.profileFilters
            if let educationHistory = profileFilterAttributes.educationHistory {
                if let index = personalFilters.firstIndex(where: {$0 == .education()}) {
                    personalFilters[index] = .education(educationHistory)
                }
            }
            
            if let religion = profileFilterAttributes.religion {
                if let index = personalFilters.firstIndex(where: {$0 == .religion()}) {
                    personalFilters[index] = .religion(religion)
                }
            }

            if let ethnicity = profileFilterAttributes.ethnicity {
                if let index = personalFilters.firstIndex(where: {$0 == .ethnicity()}) {
                    personalFilters[index] = .ethnicity(ethnicity)
                }
            }
            
            if let gender = profileFilterAttributes.gender {
                if let index = personalFilters.firstIndex(where: {$0 == .gender()}) {
                    personalFilters[index] = .gender(gender)
                }
            }
            
            if let politics = profileFilterAttributes.politics {
                if let index = personalFilters.firstIndex(where: {$0 == .politics()}) {
                    personalFilters[index] = .politics(politics)
                }
            }
            
            if let days = settings.troovFilters.daysOfWeek {
                let cleanDays = days.map({$0.rawValue.cleanEnums})
                self.selectedDays = cleanDays
            }
            
            if let time = settings.troovFilters.dateStartTimings {
                let cleanTime = time.map({$0.rawValue.cleanEnums})
                self.selectedTimes = cleanTime
            }
        
            if let minAge = profileFilterAttributes.minAge, let maxAge = profileFilterAttributes.maxAge {
                self.minAge = Int(minAge)
                self.maxAge = Int(maxAge)
            }
            
            if let minHeight = profileFilterAttributes.minHeight,
               let maxHeight = profileFilterAttributes.maxHeight {
                self.minHeight = minHeight.length
                self.maxHeight = maxHeight.length
            }
        
            if let relationInterest = troovFilters.relationshipInterests {
                self.selectedInterestedIn = relationInterest.map({$0.filterUsageRawValue})
            }
        
            if let expenseRating = troovFilters.expenseRatings?.first,
               let costInfo = expenseRating.costInfo {
                self.costInfo = costInfo
            }
        }
    }
}

#Preview {
    SearchFiltersView {}
}

extension DiscoverFilterSettings {
    struct Filter: Identifiable, Hashable {
        let id = UUID().uuidString
        let type: FilterType
        var text: String
        var hiddenValue: String?
    }
    
    enum FilterType {
        case relationship
        case location
        case distance
        case cost
        case dates
        case time
        case education
        case religion
        case ethnicity
        case gender
        case politics
        case age
        case height
    }
}

extension DiscoverFilterSettings.FilterType {
    var image: String {
        switch self {
        case .location:
            return "t.location.fill"
        case .cost:
            return "t.dollar"
        default:
            return "t.hash"
        }
    }
}

fileprivate extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

extension DiscoverFilterSettings {
    var activeFiltersCount: Int {
        /**
         1. Relationship interest
         2. Location -- By default filter
         3. Distance -- By default filter
         4. Cost
         5. Dates
         6. Age  -- By default filter
         7. Height
         8. Education
         9. Religion
         10. Ethnicity
         11. Gender
         12. Politics`
         */
        var count = 0
        if troovFilters.relationshipInterests != nil {
            count += 1
        }
        
        if troovFilters.expenseRatings != nil {
            count += 1
        }
        
        if troovFilters.daysOfWeek != nil || troovFilters.dateStartTimings != nil {
            count += 1
        }
        
        if profileFilters.educationHistory != nil {
            count += 1
        }
        
        if profileFilters.religion != nil {
            count += 1
        }
        
        if profileFilters.ethnicity != nil {
            count += 1
        }
        
        if profileFilters.gender != nil {
            count += 1
        }
        
        if profileFilters.politics != nil {
            count += 1
        }
        
        return count
    }
}
