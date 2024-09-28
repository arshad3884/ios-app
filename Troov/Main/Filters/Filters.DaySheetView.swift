//
//  Filters.DaySheetView.swift
//  Troov
//
//  Created by Levon Arakelyan on 19.06.24.
//

import SwiftUI

extension Filters {
    struct DaySheetView: View {
        @Environment(\.dismiss) var dismiss
        @Binding var selectedDays: [String]
            
        private let days = DayOfWeek.allCases
        
        private let columns: [GridItem] = [
            GridItem(.flexible(), alignment: .leading),
            GridItem(.flexible(), alignment: .trailing)
        ]
        
        var body: some View {
            VStack(alignment: .leading,
                   spacing: 0) {
                PrimaryTopToolbarView(title: "Days Of Week",
                                      action: onDismiss)
                Text("Day of week")
                    .fontWithLineHeight(font: .poppins700(size: 16), lineHeight: 16)
                    .foregroundColor(.black)
                    .padding(.horizontal, 31)
                    .padding(.top, 25)
                    .padding(.bottom, 10)
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(days, id: \.id) { day in
                        Button(action: { selectDay(day)},
                               label: {
                            TTertiaryLabel(image: nil,
                                           text: day.rawValue.cleanEnums,
                                           isSelected: selectedDays.contains(day.rawValue.cleanEnums),
                                           height: 40,
                                           fontSize: 14)
                        })
                    }
                }
                .padding(.horizontal, 31)
                Spacer()
            }
        }
        
        private func selectDay(_ day: DayOfWeek) {
            if let index = selectedDays.firstIndex(where: {$0 == day.rawValue.cleanEnums}) {
                selectedDays.remove(at: index)
            } else {
                selectedDays.append(day.rawValue.cleanEnums)
            }
        }
        
        private func onDismiss() {
            dismiss()
        }
    }
}

#Preview {
    Filters.DaySheetView(selectedDays: .constant([]))
}
