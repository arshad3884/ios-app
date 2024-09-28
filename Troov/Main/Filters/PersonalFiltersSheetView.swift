//
//  PersonalFiltersSheetView.swift
//  Troov
//
//  Created by Levon Arakelyan on 24.10.23.
//

import SwiftUI

struct PersonalFiltersSheetView: View {
    @Environment(\.dismiss) var dismiss

    let item: PersonalFilterItem
    let selection: (PersonalFilterItem) -> ()
    let erase: (PersonalFilterItem) -> ()

    @State private var selectedInfo: [String] = []
    
    var body: some View {
        VStack(spacing: 0) {
            PrimaryTopToolbarView(title: item.name,
                                  action: onDismiss)
            VStack(alignment: .center, spacing: 15) {
                ForEach(item.generalInfo, id: \.self) { info in
                    let isSelected = selectedInfo.contains(info)
                    Button(action: { select(info) }) {
                        if isSelected {
                            TPrimaryLabel(text: info.cleanEnums)
                        } else {
                            TTertiaryLabel(text: info.cleanEnums)
                        }
                    }.buttonStyle(.scalable)
                }
            }.padding(.top, 30)
             .padding(.horizontal, 17)
            Spacer()
        }.ignoresSafeArea()
            .onAppear(perform: appear)
    }
    
    private func select(_ info: String) {
        if let index = selectedInfo.firstIndex(of: info) {
            
            selectedInfo.remove(at: index)
            if let newItem = PersonalFilterItem(item: item,
                                                info: selectedInfo) {
                erase(newItem)
            } else {
                erase(PersonalFilterItem(emptyItem: item))
            }
        } else {
            selectedInfo.append(info)
            if let selectionItem = PersonalFilterItem(item: item,
                                                      info: selectedInfo) {
                selection(selectionItem)
            }
        }
    }

    private func onDismiss() {
        dismiss()
    }

    private func appear() {
        if let array = item.filteredArray {
            selectedInfo = array
        }
    }
}

#Preview {
    PersonalFiltersSheetView(item: .education()) { _ in } erase: {_ in}
}
