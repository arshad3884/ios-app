//
//  RegistrationEducationInfoView.swift
//  Troov
//
//  Created by Leo on 01.09.2023.
//

import SwiftUI

struct RegistrationEducationInfoView: View {
    @Environment(RegisterViewModel.self) var registerViewModel: RegisterViewModel

    @State private var almaMater: String = ""

    @State private var occupation: String = ""
    @State private var occupationValidationState: ValidationState = .missing

    @State private var company: String = ""
    @State private var companyValidationState: ValidationState = .missing

    private var userProfile: UserProfile? {
        registerViewModel.user.userProfile
    }
    
    var body: some View {
        VStack(spacing: 20.relative(to: .height)) {
            RegistrationTextFieldView(text: $almaMater,
                                      prompt: "Enter your school (optional)")
            RegistrationTextFieldView(text: $occupation,
                                      prompt: "Enter your occupation (optional)",
                                      triggerAttention: registerViewModel.triggerValidationAttention &&
                                      occupationValidationState != .valid)
            .overlay(alignment: .trailing) {
                ValidatorView<Int, Float>(input: .string(input: occupation,
                                                         rule: UserProfile.occupationRule),
                                          output: occupationRule(_:))
                    .padding(.trailing, 5)
            }
            
            RegistrationTextFieldView(text: $company,
                                      prompt: "Enter your company (optional)",
                                      triggerAttention: registerViewModel.triggerValidationAttention &&
                                      companyValidationState != .valid)
            .overlay(alignment: .trailing) {
                ValidatorView<Int, Float>(input: .string(input: company,
                                                         rule: UserProfile.companyRule),
                                          output: companyRule(_:))
                    .padding(.trailing, 5)
            }
        }
        .padding(.top, 36.relative(to: .height))
        .onDisappear(perform: disappear)
        .onAppear(perform: appear)
    }

    private func companyRule(_ output: ValidationState) {
        if output == .invalid {
            companyValidationState = .invalid
        } else {
            companyValidationState = .valid
        }
        updateMainValidationState()
    }

    private func occupationRule(_ output: ValidationState) {
        if output == .invalid {
            occupationValidationState = .invalid
        } else {
            occupationValidationState = .valid
        }
        updateMainValidationState()
    }

    private func updateMainValidationState() {
        if companyValidationState == .valid &&
            occupationValidationState == .valid {
            registerViewModel.validate(.valid)
        } else {
            registerViewModel.validate(.invalid)
        }
    }

    private func disappear() {
        registerViewModel.save(almaMater: almaMater,
                               occupation: occupation,
                               company: company,
                               step: .almaMaterOccupationCompany)
    }

    private func appear() {
        if let userProfile = userProfile {
            almaMater = userProfile.almaMater?.first ?? ""
            occupation = userProfile.occupation ?? ""
            company = userProfile.company ?? ""
        }
    }
}

struct RegistrationEducationInfoView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationEducationInfoView()
    }
}
