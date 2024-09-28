//
//  CreateTroovStepGeneralView.swift
//  Troov
//
//  Created by Levon Arakelyan on 18.09.23.
//

import SwiftUI

struct CreateTroovStepGeneralView: View {
    @Environment(CreateTroovViewModel.self) var viewModel

    private let interestedIn = RelationshipInterest.allCases.map({$0.filterUsageRawValue})
    @State private var selectedInterests: [String] = []
    
    @State private var hashTags: [String] = []
    @State private var tag: String = ""

    @State private var showingPicker = false
    @State private var date: Date?

    @State private var showingLocationSearch = false
    @State private var location: Location?
    @State private var locationIsNotHidden = true
    @State private var locationValidity: ValidationState = .missing
    @State private var dateValidity: ValidationState = .missing
    @State private var interestedInValidity: ValidationState = .missing

    @State private var tagSize: CGSize = .zero
    
    private let dateTimePlaceholder = "Pick Date and Time"

    private var dateTimeNotPicked: Bool {
        return dateTime == dateTimePlaceholder
    }
    
    private var dateTime: String {
        if let date = date {
            return date.getLongDayAndHourFromDate
        }
    
        return dateTimePlaceholder
    }
    
    private var locationName: String {
        if let name = location?.name {
            return name
        }
        return "Add Location"
    }

    
    private var locationDirectName: String {
        if let name = location?.name {
            return name
        }
        return ""
    }

    var body: some View {
        VStack(alignment: .center,
               spacing: 0) {
            Button(action: datePicker) {
                TQuaternaryLabel(text: dateTime,
                                 image: "t.calendar",
                                 foregroundColor: dateTimeNotPicked ? Color(hex: "A7AFB8") : .rgba(33, 33, 33, 1),
                                 triggerAttention: viewModel.triggerValidationAttention,
                                 ceaseAnimation: !dateTimeNotPicked)
            }.buttonStyle(.scalable)
            Button(action: { locationSearch() }) {
                TQuaternaryLabel(text: locationName,
                                 image: "t.filter.location",
                                 foregroundColor: locationDirectName.isClean ? Color(hex: "A7AFB8") : .rgba(33, 33, 33, 1),
                                 triggerAttention: viewModel.triggerValidationAttention,
                                 ceaseAnimation: !locationDirectName.isClean )
            }.buttonStyle(.scalable)
             .padding(.top, 12.relative(to: .height))
            HStack {
                Text("Location Is \(locationIsNotHidden ? "Public" : "Private")")
                    .foregroundColor(.rgba(33, 33, 33, 1))
                    .fontWithLineHeight(font: .poppins400(size: 14), lineHeight: 21)
                Spacer()
                Toggle("", isOn: $locationIsNotHidden)
                    .toggleStyle(.gradient)
            }.padding(.top, 22.relative(to: .height))
             .padding(.horizontal, 10.relative(to: .width))
            InfoFillLabel(text: "If you mark the location as private, then other users will only see the distance from them to your troov's location")
                .padding(.top, 20.relative(to: .height))
            TTagsView(tags: interestedIn,
                      selectedTags: $selectedInterests)
            .padding(5)
            .softAttentionAnimation(triggerAttention: viewModel.triggerValidationAttention,
                                    ceaseAnimation: selectedInterests.count > 0,
                                    background: .roundedRectangle(radius: 15))
            .padding(.top, 12.relative(to: .height))
            TTagTextField(placeholder: "Add Tags",
                          tags: $hashTags,
                          tag: $tag)
            .padding(.top, 12.relative(to: .height))
            .onChange(of: tag, { _, newValue in
                change(newValue)
            })
            .readSize { size in
                if viewModel.keyboardPadding != size.height/4 {
                    viewModel.keyboardPadding = size.height/4
                }
            }
        }.padding(.top, 22.relative(to: .height))
         .padding(.horizontal, 14.relative(to: .width))
         .onChange(of: locationDirectName) {
             _, newValue in
             locationNameChanged(newValue)
         }
         .onChange(of: date, { _, _ in
             dateChange()
         })
         .onChange(of: selectedInterests, { _, _ in
             interestedInChange()
         })
         .onChange(of: viewModel.createHashtag, { _, _ in
             tag += ","
         })
         .navigationDestination(isPresented: $showingLocationSearch) {
             TLocationSearchView(result: save(location:))
         }
         .sheet(isPresented: $showingPicker) {
             CustomDatePickerView(initialDate: date,
                                  selectedDate: selected(_:),
                                  range: .now...Date().addingTimeInterval(2 * 365.25 * 24 * 60 * 60))
             .presentationDetents([.fraction(0.68)])
             .presentationDragIndicator(.visible)
             .presentationCornerRadius(24)
         }
         .onAppear(perform: { appear() })
         .onDisappear(perform: { saveResults() })
    }

   @MainActor private func appear() {
        let troov = viewModel.troov
        date = troov?.startTime
        if let relationshipInterests = troov?.troovCoreDetails?.relationshipInterests {
            selectedInterests = relationshipInterests.map({$0.filterUsageRawValue})
        }
        self.location = troov?.locationDetails?.location

        if let hidden = troov?.locationDetails?.hidden {
            locationIsNotHidden = !hidden
        }
        if let tags = troov?.troovCoreDetails?.tags {
            hashTags = tags
        }
        locationNameChanged(locationDirectName)
        dateChange()
        interestedInChange()
    }

    @MainActor private func saveResults() {
        viewModel.saveGeneralInfo(date: date,
                                  location: location,
                                  locationIsHidden: !locationIsNotHidden,
                                  ineterstedIn: selectedInterests,
                                  tags: hashTags)
    }

    @MainActor private func locationSearch() {
        saveResults()
        showingLocationSearch = true
    }
    
    private func selected(_ date: Date) {
        self.date = date
    }

    private func datePicker() {
        showingPicker = true
    }

    private func addTag() {
        let components = tag.components(separatedBy: ",").map({$0.cleanLeadingTrailing})
        for tag in components {
            if !hashTags.map({$0.uppercased()}).contains(tag.uppercased()) {
                hashTags.append(tag)
            }
        }
        tag = ""
        checkValidity()
    }

    private func change(_ value: String) {
        guard value.last == "," else { return }
        var cleanValue = value.replacingOccurrences(of: ",", with: "").clean
        guard !cleanValue.isEmpty else { return }
        if cleanValue.count > 11 {
            cleanValue = "\(cleanValue.prefix(11))"
        }
        if !hashTags.contains(where: {$0.uppercased().clean == cleanValue.uppercased()}) {
            hashTags.append(cleanValue)
        }
        tag = ""
        checkValidity()
    }

    private func locationNameChanged(_ newName: String) {
        if newName.isClean {
            locationValidity = .missing
        } else {
            locationValidity = .valid
        }
        checkValidity()
    }

    private func dateChange() {
        if date?.isValidTroovDate == true {
            dateValidity = .valid
        } else {
            dateValidity = .missing
        }

        checkValidity()
    }

    private func interestedInChange() {
        if !selectedInterests.isEmpty {
            interestedInValidity = .valid
        } else {
            interestedInValidity = .missing
        }

        checkValidity()
    }

    private func checkValidity() {
        if locationValidity == .valid && dateValidity == .valid && interestedInValidity == .valid {
            viewModel.validate(.valid)
        } else {
            viewModel.validate(.invalid)
        }
    }

    private func save(location: Location?) {
        self.location = location
        self.viewModel.save(location: location)
    }
}

struct CreateTroovStepGeneralView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTroovStepGeneralView()
    }
}
