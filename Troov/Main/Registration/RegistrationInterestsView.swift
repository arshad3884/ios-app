//
//  RegistrationInterestsView.swift
//  Troov
//
//  Created by Levon Arakelyan on 17.11.23.
//

import SwiftUI

struct RegistrationInterestsView: View {
    
    @Environment(RegisterViewModel.self) var registerViewModel: RegisterViewModel
    
    @State private var opacity: Double = 0
    @State private var searchText: String = ""
    
    private var activitySections: [TroovActivitySection] {
        return registerViewModel.filteredTroovActivitySections(searchText: searchText)
    }
    
    private var selectedActivites: [TroovActivity] {
        registerViewModel.selectedActivities
    }
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: 0) {
            HStack(alignment: .top) {
                Text(RegistrationStep.activityInterests.bodyTitle.highlighted(text: RegistrationStep.activityInterests.highlightedTextInTitle))
                    .foregroundStyle(Color.rgba(33, 33, 33, 1))
                    .fontWithLineHeight(font: .poppins400(size: 15), lineHeight: 22)
                    .multilineTextAlignment(.leading)
                Spacer()
            }.padding(.vertical, 12)
            SearchView(searchText: $searchText)
            ForEach(activitySections, id: \.id) { section in
                VStack(alignment: .leading, spacing: 12) {
                    Text(section.title)
                        .fontWithLineHeight(font: .poppins600(size: 14), lineHeight: 21)
                        .foregroundStyle(Color.rgba(33, 33, 33))
                    GridView(isSearching: section.isSearching,
                             activities: section.activities,
                             selectedActivites: selectedActivites,
                             select: select(_:))
                }
            }.padding(.top, 12)
                .opacity(opacity)
                .animation(.easeInOut(duration: 0.5).delay(0.5), value: opacity)
            Spacer()
        }.onAppear {
            opacity = 1.0
        }.onDisappear {
            opacity = 0.0
        }
    }
    
    private func select(_ activity: TroovActivity) {
        registerViewModel.select(activity: activity)
    }
}

#Preview {
    RegistrationInterestsView()
}

extension RegistrationInterestsView {
    struct GridView: View {
        let isSearching: Bool
        let activities: [TroovActivity]
        let selectedActivites: [TroovActivity]
        let select: (TroovActivity) -> ()
        
        var body: some View {
            VStack(alignment: .center,
                   spacing: 0) {
                if isSearching,
                   let activity = activities.first,
                   activity.category == nil {
                    VStack(alignment: .center,
                           spacing: 17) {
                        Text("No results found! Add it to your\nlist from below")
                            .foregroundStyle(Color(hex: "222222"))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                        CustomItem(activity: activity,
                                   isSelected: isSelected(activity),
                                   remove: removeActivity,
                                   select: select)
                    }.padding(.horizontal, 10)
                        .padding(.vertical, 15)
                } else {
                    ScrollView(.horizontal) {
                        FlexibleStack(alignment: .leading) {
                            ForEach(activities) { activity in
                                if activity.category == .other {
                                    CustomItem(activity: activity,
                                               isSelected: isSelected(activity),
                                               remove: removeActivity,
                                               select: select)
                                } else {
                                    Button { select(activity) } label: {
                                        Item(activity: activity,
                                             isSelected: isSelected(activity))
                                    }.buttonStyle(.scalable)
                                }
                            }
                        }.containerRelativeFrame(.horizontal, { width, _ in
                            return width*1.125
                        }).padding(.horizontal, 10)
                            .padding(.vertical, 15)
                    }
                }
            }.background(RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "F6F6F6")))
        }
        
        private func isSelected(_ activity: TroovActivity) -> Bool {
            return selectedActivites.contains(where: {$0.name == activity.name})
        }
        
        private func activityIsEditable(_ activity: TroovActivity) -> Bool {
            if let category = activity.category {
                return !TroovActivityCategory.allCases.contains(category)
            } else {
                return true
            }
        }
        
        private func removeActivity(_ activity: TroovActivity) {
            select(activity)
        }
    }
}

extension RegistrationInterestsView.GridView {
    struct Item: View {
        let activity: TroovActivity
        let isSelected: Bool
        
        var body: some View {
            HStack(spacing: 10) {
                if let emoji = activity.emoji {
                    Text(emoji)
                }
                if let name = activity.name {
                    Text(name)
                        .fontWithLineHeight(font: .lato400(size: 16), lineHeight: 19)
                        .foregroundColor(.black)
                }
            }.padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Capsule().fill(isSelected ? Color.primaryTroovColor.opacity(0.1) : .white))
                .overlay {
                    if isSelected {
                        Capsule()
                            .stroke(Color.primaryTroovColor, lineWidth: 2)
                    }
                }
        }
    }
    
    struct CustomItem: View {
        let activity: TroovActivity
        let isSelected: Bool
        let remove: ((TroovActivity) -> Void)
        let select: ((TroovActivity) -> Void)
        
        var body: some View {
            HStack(spacing: 10) {
                if isSelected {
                    Text("❓")
                } else {
                    Image("t.plus")
                }
                if let name = activity.name {
                    Text(name)
                        .fontWithLineHeight(font: .lato400(size: 16), lineHeight: 19)
                        .foregroundStyle(Color.black)
                }
                
                if isSelected {
                    Image("t.xmark")
                        .renderingMode(.template)
                        .foregroundStyle(Color.primaryTroovColor)
                        .highPriorityGesture(TapGesture().onEnded({ _ in
                            remove(activity)
                        }))
                }
            }.padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Capsule().fill(isSelected ? Color.primaryTroovColor.opacity(0.1) : .white))
                .overlay {
                    if isSelected {
                        Capsule()
                            .stroke(Color.primaryTroovColor, lineWidth: 2)
                    }
                }.onTapGesture {
                    guard !isSelected && activity.category != .other else { return }
                    select(activity)
                }
        }
    }
}

extension RegistrationInterestsView {
    struct SearchView: View {
        @Binding var searchText: String
        @FocusState private var isFocused: Bool
        
        var body: some View {
            TextField("Search",
                      text: $searchText)
            .focused($isFocused)
            .fontWithLineHeight(font: .poppins400(size: 16), lineHeight: 16)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.leading)
            .submitLabel(.done)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding(.horizontal, 42)
            .padding(.vertical, 12)
            .background {
                Capsule()
                    .stroke(Color(hex: "E9EBED"), lineWidth: 1)
                    .frame(height: 44)
            }
            .overlay(alignment: .leading) {
                Image("t.search")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color(hex: "A7AFB8"))
                    .frame(width: 14, height: 14)
                    .padding(.leading, 16)
            }.overlay(alignment: .trailing) {
                Button(action: { clean() },
                       label: {
                    Image("t.x.circle")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.primaryBlack)
                        .frame(width: 20, height: 20)
                }).buttonStyle(.scalable(value: 0.9))
                    .padding(.trailing, 16)
                    .opacity(searchText.isClean ? 0.0 : 1.0)
            }.onChange(of: isFocused) { _, newValue in
                if !newValue {
                    withAnimation {
                        searchText = ""
                    }
                }
            }
        }
        
        @MainActor private func clean() {
            searchText = ""
            isFocused = false
        }
    }
}
