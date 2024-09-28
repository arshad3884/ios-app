//
//  CustomDatePickerView.swift
//  mango
//
//  Created by Leo on 21.01.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct CustomDatePickerView: View {
    @Environment(\.dismiss) private var dismiss
    let initialDate: Date?
    let selectedDate: (Date) -> ()
    let range: ClosedRange<Date>
    var showHours = true
    @State private var date: Date = .now
    @State private var selectedHour: Int = 0
    @State private var selectedMinute: Int = 0
    @State private var selectedAmPm: String = "PM"
    
    private let hours: [Int] = Array(1...12)
    private let minutes: [Int] = Array(stride(from: 0, to: 60, by: 5))
    private let amPm = ["AM", "PM"]
    private let padding: CGFloat = 25

    private func updateHoursAndMinutes(date: Date) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        self.selectedHour = hour % 12 == 0 ? 12 : hour % 12
        self.selectedMinute = (minute / 5) * 5
        self.selectedAmPm = hour >= 12 ? "PM" : "AM"
    }

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                Button(action: { dismiss() }) {
                    Text("Done")
                        .fontWithLineHeight(font: .poppins400(size: 12), lineHeight: 12)
                        .foregroundStyle(Color.primaryTroovColor)
                }.padding(.trailing, 10)
            }
    
            DatePicker("Select Date", selection: $date, in: range, displayedComponents: .date)
                .datePickerStyle(.graphical)
            if showHours {
                HStack(alignment: .center) {
                    Picker("Hour", selection: $selectedHour) {
                        ForEach(hours, id: \.self) { hour in
                            Text("\(hour)").tag(hour)
                        }
                    }
                    .pickerStyle(.wheel)

                    Picker("Minute", selection: $selectedMinute) {
                        ForEach(minutes, id: \.self) { minute in
                            Text(String(format: "%02d", minute)).tag(minute)
                        }
                    }
                    .pickerStyle(.wheel)

                    Picker("AM/PM", selection: $selectedAmPm) {
                        ForEach(amPm, id: \.self) { period in
                            Text(period).tag(period)
                        }
                    }
                    .pickerStyle(.segmented)
                }.onChange(of: selectedHour) { _, _ in
                    addTimeToDate()
                }
                .onChange(of: selectedMinute) { _, _ in
                    addTimeToDate()
                }
                .onChange(of: selectedAmPm) { _, _ in
                    addTimeToDate()
                }
            }
        }.padding(padding)
         .onChange(of: date, { _, _ in
             addTimeToDate()
         })
         .onAppear(perform: appear)
    }

    private func addTimeToDate() {
        if showHours {
            let isPM = selectedAmPm == "PM"
            let dateObject = date.addTimeToDate(hours: selectedHour, minutes: selectedMinute, isPM: isPM)
            if let newDate = dateObject.date {
                selectedDate(newDate)
                if dateObject.reset {
                    withAnimation {
                        self.updateHoursAndMinutes(date: newDate)
                    }
                }
            }
        } else {
            selectedDate(date)
        }
    }

    private func appear() {
        if showHours {
            guard let validDate = validDate else { return }
            if let initialDate = initialDate {
                if initialDate < validDate {
                    date = validDate
                } else {
                    date = initialDate
                }
            } else {
                date = validDate
            }
        
            updateHoursAndMinutes(date: date)
        } else {
            if let initialDate = initialDate {
                date = initialDate
            }
        }
    }

    private var validDate: Date? {
        Date.now.addMinutesToDate(minutes: 5)
    }
}

struct CustomDatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomDatePickerView(initialDate: .now, selectedDate: {_ in}, range: Date().addingTimeInterval(-1000000)...Date())
    }
}
