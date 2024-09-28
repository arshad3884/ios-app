//
//  Data+Extension.swift
//  Troov
//
//  Created by Levon Arakelyan on 29.07.23.
//

import Foundation

extension Data {
    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to Data, and then add that data to the Data, this wraps it in a nice convenient little extension to Data. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.

    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
