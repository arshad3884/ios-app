//
//  RegistrationNameAndAgeView.swift
//  Troov
//
//  Created by Levon Arakelyan on 05.02.24.
//

import SwiftUI

struct RegistrationNameAndAgeView: View, KeyboardReadable {
    @Environment(RegisterViewModel.self) var registerViewModel: RegisterViewModel
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var showingPicker = false

    private let minAge = Int(UserProfile.ageRule.minimum!)
    private let maxAge = Int(UserProfile.ageRule.maximum!)
    @State private var date: Date?
    
    @State private var firstNameValidationState: ValidationState = .missing
    @State private var lastNameValidationState: ValidationState = .missing

    private var initialDateForBirthday: Date {
        date ?? Date().adding(years: -minAge).adding(months: -1)
    }
    
    private var birthday: String {
        if let date = date {
            return date.getYearWeekDayMonth
        }
        return "Date Of Birth"
    }

    private var birthdayIsPicked: Bool {
        birthday != "Date Of Birth"
    }

    private var user: User {
        registerViewModel.user
    }

    var body: some View {
        VStack(alignment: .leading,
               spacing: 15.relative(to: .height)) {
            Text("Enter your information below")
                .fontWithLineHeight(font: .poppins400(size: 14),
                                    lineHeight: 24)
                .lineLimit(2)
                .foregroundStyle( Color.rgba(33, 33, 33, 1))
            RegistrationTextFieldView(text: $firstName,
                                      prompt: "First Name (display name)",
                                      triggerAttention: registerViewModel.triggerValidationAttention &&
                                      firstNameValidationState != .valid)
            .overlay(alignment: .trailing) {
                ValidatorView<Int, Float>(input: .string(input: firstName,
                                                         rule: User.firstNameRule),
                                          output: validateFirstName(_:))
                    .padding(.trailing, 5)
            }
            RegistrationTextFieldView(text: $lastName,
                                      prompt: "Last Name",
                                      triggerAttention: registerViewModel.triggerValidationAttention &&
                                      lastNameValidationState != .valid)
            .overlay(alignment: .trailing) {
                ValidatorView<Int, Float>(input: .string(input: lastName,
                                                         rule: User.lastNameRule),
                                          output: validateLastName(_:))
                    .padding(.trailing, 5)
            }
            InfoLabel(text: "Your last name is kept private\nMust be 18 years of age or older to register")
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.primaryTroovColor.opacity(0.1)))
            Button(action: datePicker) {
                TQuaternaryLabel(text: birthday,
                                 image: "t.calendar",
                                 foregroundColor: birthdayIsPicked ? Color.textFieldForeground : Color(hex: "A7AFB8"),
                                 triggerAttention: !birthdayIsPicked && registerViewModel.triggerValidationAttention,
                                 ceaseAnimation: birthdayIsPicked)
            }.buttonStyle(.scalable)
             .sheet(isPresented: $showingPicker) {
                 CustomDatePickerView(initialDate: initialDateForBirthday,
                                      selectedDate: selected(_:),
                                      range: .now.adding(years: -maxAge)...Date().adding(years: -minAge),
                                      showHours: false)
                    .presentationDetents([.fraction(0.55)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(24)
                    .ignoresSafeArea(edges: .all)
                }
            Spacer()
        }.padding(.top, 36.relative(to: .height))
         .onTapGesture(perform: endEditing)
         .onDisappear(perform: disappear)
         .onAppear(perform: appear)
         .onChange(of: date) { _, _ in mainValidation() }
    }

    private func disappear() {
        if let date = date {
            registerViewModel.save(firstName: firstName,
                                   lastName: lastName,
                                   dateOfBirth: date,
                                   step: .nameAndBirthday)
        }
    }

    private func appear() {
        if let firstName = user.firstName {
            self.firstName = firstName
        }
        
        if let lastName = user.lastName {
            self.lastName = lastName
        }

        if let dateOfBirth = user.dateOfBirth {
            self.date = dateOfBirth.wrappedDate
        }
    }

    private func datePicker() {
        showingPicker = true
    }

    private func selected(_ date: Date) {
        self.date = date
    }

    private func validateFirstName(_ state: ValidationState) {
        firstNameValidationState = state
        mainValidation()
    }
    
    private func validateLastName(_ state: ValidationState) {
        lastNameValidationState = state
        mainValidation()
    }
    
    private func mainValidation() {
        if firstNameValidationState == .valid &&
        lastNameValidationState == .valid &&
        date != nil {
            registerViewModel.validate(.valid)
        } else {
            registerViewModel.validate(.invalid)
        }
    }
}

#Preview {
    RegistrationNameAndAgeView()
}
