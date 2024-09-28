//
//  CountryCodesView.swift
//  Troov
//
//  Created by Levon Arakelyan on 14.09.23.
//

import SwiftUI

struct CountryCodesView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var searchCountry = ""
    
    @Binding var dialCode: String
    @Binding var countryFlag: String
    @Binding var countryPattern: String
    @Binding var countryCode: String

    let codes: [CountryPhoneInfo]
    
    private var filteredCodes: [CountryPhoneInfo] {
        if searchCountry.isEmpty {
            return codes
        } else {
            return codes.filter { $0.name.contains(searchCountry) }
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredCodes, id: \.id) { country in
                Button(action: { onTap(code: country) },
                       label: {
                    HStack {
                        Text(country.flag)
                            .fontWithLineHeight(font: .poppins400(size: 14), lineHeight: 14)
                        Text(country.name)
                            .fontWithLineHeight(font: .poppins600(size: 14), lineHeight: 14)
                        Spacer()
                        Text(country.dial_code)
                            .foregroundColor(.secondary)
                            .fontWithLineHeight(font: .poppins400(size: 14), lineHeight: 14)
                    }.background(Color.white.opacity(0.01))
                }).buttonStyle(.scalable)
            }
            .listStyle(.plain)
            .searchable(text: $searchCountry, prompt: "Your country code")
        }
        .presentationDetents([.medium, .large])
        .presentationCornerRadius(24)
        .ignoresSafeArea(.keyboard)
    }

    
    private func onTap(code: CountryPhoneInfo) {
        countryFlag = code.flag
        dialCode = code.dial_code
        countryPattern = code.pattern
        countryCode = code.code
        dismiss()
    }
}

struct CountryCodesView_Previews: PreviewProvider {
    static var previews: some View {
        CountryCodesView(dialCode: .constant(""),
                         countryFlag: .constant(""),
                         countryPattern: .constant(""),
                         countryCode: .constant(""),
                         codes: [])
    }
}
