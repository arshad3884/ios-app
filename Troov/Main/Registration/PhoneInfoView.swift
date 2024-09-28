//
//  PhoneInfoView.swift
//  Troov
//
//  Created by Leo on 01.09.2023.
//

import SwiftUI

struct PhoneInfoView: View, KeyboardReadable {

    let step: RegistrationStep
    
    @Environment(RegisterViewModel.self) var registerViewModel
    @State private var resendCodeState = ResendCode.none
    @State private var phoneNumberValidationState: ValidationState = .invalid
    @State private var codeValidationState: ValidationState = .valid

    var body: some View {
        VStack(alignment: .center,
               spacing: 0) {
            PhoneNumberInputView(step: step,
                                 phoneNumberValidationState: $phoneNumberValidationState)
                .padding(.top, 36.relative(to: .height))
            if step == .phoneNumber {
                InfoLabel(text: "By providing your mobile phone number and opting into this Service, you expressly consent to receive text messages containing an One-Time Passcode from Troov.",
                          lineLimit: 5)
                .padding(.top, 18.relative(to: .height))
            } else if step == .codeSent {
                VStack(alignment: .center,
                       spacing: 15.relative(to: .height)) {
                    Text("A 6 digit code has been sent to your phone.\nEnter that below:")
                        .fontWithLineHeight(font: .poppins400(size: 12), lineHeight: 21)
                        .foregroundColor(.primaryBlack)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    CodeApprovalView(codeValidationState: $codeValidationState)
                    HStack(spacing: 3) {
                        switch resendCodeState {
                        case .none, .inProgress:
                            Text("Didn't receive code?")
                                .fontWithLineHeight(font: .poppins400(size: 14), lineHeight: 14)
                                .foregroundColor(.rgba(36, 36, 36, 1))
                            Button(action: resendCode,
                                   label: {
                                Text("Resend")
                                    .fontWithLineHeight(font: .poppins600(size: 14), lineHeight: 14)
                                    .underline()
                                    .foregroundColor(.rgba(36, 36, 36, 1))
                            }).disabled(resendCodeState == .inProgress)
                            if resendCodeState == .inProgress {
                                ProgressView()
                                    .progressViewStyle(.circular)
                            }
                        case .resent:
                            Text("Your message was resent")
                                .fontWithLineHeight(font: .poppins400(size: 14), lineHeight: 14)
                                .foregroundColor(.rgba(36, 36, 36, 1))
                            Image("t.checkmark.green")
                                .resizable()
                                .frame(width: 15, height: 15)
                        }
                    }
                }.padding(.top, 18.relative(to: .height))
            } else if step == .codeReceived {
                VStack(spacing: 15.relative(to: .height)) {
                    Image("t.checkmark.green")
                    Text("Verified Successfully!")
                        .fontWithLineHeight(font: .poppins500(size: 16), lineHeight: 16)
                        .foregroundColor(.rgba(22, 24, 22, 0.65))
                }.padding(.top, 18.relative(to: .height))
            }
        }.onTapGesture(perform: endEditing)
            .onChange(of: phoneNumberValidationState) { _, _ in
                validatePhoneNumberAndTheCode()
            }.onChange(of: codeValidationState) { _, _ in
                validatePhoneNumberAndTheCode()
            }.onAppear {
                if step == .codeSent {
                    codeValidationState = .invalid
                }
            }.onChange(of: step) { _, newValue in
                if newValue == .codeSent {
                    codeValidationState = .invalid
                } else {
                    codeValidationState = .valid
                }
            }
    }
    
    private func resendCode() {
        Task {
            resendCodeState = .inProgress
            await registerViewModel.sendSmsCodeForUser(isResendCode: true)
            resendCodeState = .resent
            try await Task.sleep(nanoseconds: 3_000_000_000)
            withAnimation {
                resendCodeState = .none
            }
        }
    }

    private func validatePhoneNumberAndTheCode() {
        if phoneNumberValidationState == .valid &&
           codeValidationState == .valid {
            if !registerViewModel.isNextAllowed {
                registerViewModel.validate(.valid)
            }
        } else {
            if registerViewModel.isNextAllowed {
                registerViewModel.validate(.invalid)
            }
        }
    }
}

struct PhoneInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneInfoView(step: .phoneNumber)
    }
}

extension PhoneInfoView {
    enum ResendCode {
        case none
        case inProgress
        case resent
    }
}
