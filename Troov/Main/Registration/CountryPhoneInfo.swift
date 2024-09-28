//
//  CountryPhoneInfo.swift
//  Troov
//
//  Created by Leo on 31.08.2023.
//

import Foundation

struct CountryPhoneInfo: Codable, Identifiable {
    let id: String
    let name: String
    let flag: String
    let code: String
    let dial_code: String
    let pattern: String
    
    static let allCountry: [CountryPhoneInfo] = Bundle.main.decode("CountryNumbers.json")
    static let example = allCountry[0]
}

