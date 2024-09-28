//
//  PhoneNumberInputView.swift
//  Troov
//
//  Created by Leo on 31.08.2023.
//

import SwiftUI

struct PhoneNumberInputView: View {
    @Environment(RegisterViewModel.self) var registerViewModel: RegisterViewModel

    let step: RegistrationStep
    @Binding var phoneNumberValidationState: ValidationState

    @State private var showingCountryCodes = false
    @State private var dialCode = CountryPhoneCode._1.rawValue
    @State private var countryFlag = "🇺🇸"
    @State private var countryPattern = "### ### ####"
    @State private var localNumber = ""
    @State private var code = CountryCode.us.rawValue

    private let codes = CountryPhoneInfo.allCountry

    private var initialPart: String {
        "|    \(dialCode)   "
    }
    
    private var countryPhoneInfoByDialCode: CountryPhoneInfo? {
        codes.first(where: {$0.code == code})
    }

    private var countryName: CountryName? {
        if let name = countryPhoneInfoByDialCode?.name {
            return CountryName(rawValue: name)
        }
        return nil
    }
    
    private var countryPhoneCode: CountryPhoneCode? {
        if let dial_code = countryPhoneInfoByDialCode?.dial_code {
            return CountryPhoneCode(rawValue: dial_code)
        }
        return nil
    }
    
    private var phoneNumberObject: PhoneNumber? {
        guard !localNumber.isClean,
              let countryName = countryName,
              let countryPhoneCode = countryPhoneCode,
              let code = countryPhoneInfoByDialCode?.code else { return nil }
        return .init(countryName: countryName,
                     countryCode: .init(rawValue: code),
                     countryPhoneCode: countryPhoneCode,
                     localNumber: localNumber)
    }

    @FocusState private var keyIsFocused: Bool
        
    var body: some View {
        VStack {
            HStack {
                Button(action: showCountryCodes,
                       label: {
                    Text("\(countryFlag)")
                        .shadow(radius: 8)
                    Image("t.arrow.down.small")
                })
                .padding(.leading, 20.relative(to: .width))
                TextField("", text: $localNumber,
                          prompt: Text("\(initialPart)\(countryPattern)")
                    .foregroundColor(.rgba(167, 175, 184, 1)))
                .frame(height: 56)
                .frame(maxWidth: .infinity)
                .opacity(localNumber.count == 0 ? 1 : 0.01)
                    .foregroundStyle(Color.textFieldForeground)
                    .focused($keyIsFocused)
                    .keyboardType(.numberPad)
                    .onChange(of: localNumber, { oldValue, newValue in
                        guard oldValue != newValue else { return }
                        applyPatternOnNumbers(newValue, pattern: countryPattern, replacementCharacter: "#")
                        /**
                         Update phone number in registerViewModel
                         */
                        registerViewModel.updatePhoneNumber(phoneNumberObject)
                    }).background(alignment: .leading) {
                        if localNumber.count > 0 {
                            Text("\(initialPart)\(localNumber)")
                                .foregroundStyle(Color.textFieldForeground)
                                .fontWithLineHeight(font: .poppins400(size: 14), lineHeight: 14)
                        }
                    }
            }
            .fontWithLineHeight(font: .poppins400(size: 14), lineHeight: 14)
            .background(Color.primaryLightGray, in: Capsule())
            .overlay {
                if step == .codeReceived {
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.rgba(33, 238, 0, 1), lineWidth: 1)
                }
            }
        }.onTapGesture {
            if localNumber.count > 0 {
                keyIsFocused = true
            }
        }
        .onAppear(perform: {
            keyIsFocused = true
            checkFocusedState()
            if let phoneNumber = registerViewModel.user.phoneNumber,
               let countryPhoneCode = phoneNumber.countryPhoneCode?.rawValue,
               let localNumber = phoneNumber.localNumber,
               let patternCode = codes.first(where: {$0.dial_code == countryPhoneCode}),
               let countryCode = phoneNumber.countryCode {
                self.dialCode = countryPhoneCode
                self.localNumber = localNumber
                self.countryPattern = patternCode.pattern
                self.code = countryCode.rawValue
                if let flag = countryPhoneInfoByDialCode?.flag {
                    self.countryFlag = flag
                }
            }
        })
        .sheet(isPresented: $showingCountryCodes) {
            CountryCodesView(dialCode: $dialCode,
                             countryFlag: $countryFlag,
                             countryPattern: $countryPattern,
                             countryCode: $code,
                             codes: codes)
        }
    }

    private func applyPatternOnNumbers(_ stringvar: String, pattern: String, replacementCharacter: Character) {
        guard stringvar.count <= countryPattern.count else {
            cleanPhoneNumber()
            return
        }
        
        var pureNumber = stringvar.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        let count = pattern.replacingOccurrences( of: " ", with: "", options: .regularExpression).count
        for index in 0 ..< count {
            let pureNumberCount = pureNumber.replacingOccurrences( of: " ", with: "", options: .regularExpression).count
            if pureNumberCount <= count {
                guard index < pureNumber.count else {
                    if localNumber != pureNumber {
                        localNumber = pureNumber
                    }
                    checkFocusedState()
                    return
                }
                
                let stringIndex = String.Index(utf16Offset: index, in: pattern)
                let patternCharacter = pattern[stringIndex]
                guard patternCharacter != replacementCharacter else { continue }
                pureNumber.insert(patternCharacter, at: stringIndex)
            } else {
                pureNumber = String(pureNumber.prefix(count))
            }
        }
        
        if localNumber != pureNumber {
            localNumber = pureNumber
        }
        checkFocusedState()
    }

    private func cleanPhoneNumber() {
        let number = localNumber
        if number.count > countryPattern.count {
            localNumber = String(number.prefix(countryPattern.count))
        }
    }

    private func checkFocusedState() {
        if localNumber.count >= countryPattern.count {
            keyIsFocused = false
            phoneNumberValidationState = .valid
        } else {
            phoneNumberValidationState = .invalid
        }
    }

    private func showCountryCodes() {
        showingCountryCodes = true
        localNumber = ""
    }

    private func dismissKeyboard() {
        keyIsFocused = false
    }
}

struct PhoneNumberInputViewPreview: PreviewProvider {
    static var previews: some View {
        PhoneNumberInputView(step: .codeSent,
                             phoneNumberValidationState: .constant(.valid))
    }
}
