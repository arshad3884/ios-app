//
//  Filters.TimeSheetView.swift
//  Troov
//
//  Created by Levon Arakelyan on 19.06.24.
//

import SwiftUI

extension Filters {
    struct TimeSheetView: View {
        @Environment(\.dismiss) var dismiss
        @Binding var selectedTimes: [String]
            
        private let times = TimeOfDay.allCases
        
        var body: some View {
            VStack(alignment: .leading,
                   spacing: 0) {
                PrimaryTopToolbarView(title: "Time",
                                      action: onDismiss)
                Text("Time of day")
                    .fontWithLineHeight(font: .poppins700(size: 16), lineHeight: 16)
                    .foregroundColor(.black)
                    .padding(.horizontal, 31)
                    .padding(.top, 25)
                    .padding(.bottom, 10)
                VStack(alignment: .center,
                       spacing: 10, content: {
                    ForEach(times, id: \.id) { time in
                        Button(action: { selectTime(time)},
                               label: {
                            TTertiaryLabel(image: nil,
                                           text: time.rawValue.cleanEnums,
                                           isSelected: selectedTimes.contains(time.rawValue.cleanEnums),
                                           height: 40,
                                           fontSize: 14)
                        })
                    }
                    .padding(.horizontal, 31)
                })
                Spacer()
            }
        }
        
        private func selectTime(_ time: TimeOfDay) {
            if let index = selectedTimes.firstIndex(where: {$0 == time.rawValue.cleanEnums}) {
                selectedTimes.remove(at: index)
            } else {
                selectedTimes.append(time.rawValue.cleanEnums)
            }
        }

        private func onDismiss() {
            dismiss()
        }
    }
}

#Preview {
    Filters.TimeSheetView(selectedTimes: .constant([]))
}
