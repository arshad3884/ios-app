//
//  String+Extensions.swift
//  mango
//
//  Created by Leo on 14.10.21.
//  Copyright © 2021 Levon Arakelyan. All rights reserved.
//

import SwiftUI
//2023-07-19T13:39:20+04:00
//2023-08-10T12:23:59.222Z
public let dateFormatters = [
    "yyyy-MM-dd",
    "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
    "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
    "yyyy-MM-dd'T'HH:mm:ss'Z'",
    "yyyy-MM-dd'T'HH:mm:sss'Z'",
    "yyyy-MM-dd'T'HH:mm:ss.SSS",
    "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
    "yyyy-MM-dd HH:mm:ss"
    ].map { (format: String) -> DateFormatter in
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        return formatter
}

extension String {
    var getLongDayFromDate: String {
        var date: Date?
        for formatter in dateFormatters {
            if let currentDate = formatter.date(from: self) {
                date = currentDate
                break
            }
        }

        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, d MMMM"
            return dateFormatter.string(from: date)
        }

        return ""
    }

    var getDayFromDate: String {
        var date: Date?
        for formatter in dateFormatters {
            if let currentDate = formatter.date(from: self) {
                date = currentDate
                break
            }
        }

        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d"
            return dateFormatter.string(from: date)
        }

        return ""
    }

    var getHourFromDate: String {
        var date: Date?
        for formatter in dateFormatters {
            if let currentDate = formatter.date(from: self) {
                date = currentDate
                break
            }
        }

        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh a"
            return dateFormatter.string(from: date)
        }
        return ""
    }

    var getWeek: String {
        var date: Date?
        for formatter in dateFormatters {
            if let currentDate = formatter.date(from: self) {
                date = currentDate
                break
            }
        }

        if let date = date {
            let weekdays = [
                "Sunday",
                "Monday",
                "Tuesday",
                "Wednesday",
                "Thursday",
                "Friday",
                "Saturday"
            ]
            let comp = Calendar.current.component(.weekday, from: date)
            return weekdays[comp - 1]
        }
        return ""
    }

    var convertToDate: Date {
        var date: Date?
        for formatter in dateFormatters {
            if let currentDate = formatter.date(from: self) {
                date = currentDate
                break
            }
        }
        return date ?? Date()
    }

    func highlighted(inRanges ranges: [NSValue],
                     fontSize: CGFloat) -> AttributedString {
        let attributedText = NSMutableAttributedString(string: self)
        let regular = UIFont.systemFont(ofSize: fontSize)
        attributedText.addAttribute(NSAttributedString.Key.font,
                                    value: regular,
                                    range: NSMakeRange(0, count))

        let bold = UIFont.boldSystemFont(ofSize: fontSize)
        for value in ranges {
            attributedText.addAttribute(NSAttributedString.Key.font,
                                        value:bold,
                                        range:value.rangeValue)
        }
        return AttributedString(attributedText)
    }

    var isClean: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var clean: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var cleanEnums: String {
        if self == Education.notDisclosed.rawValue {
            return "Rather not disclose"
        } else {
            return self.replacingOccurrences(of: "-", with: " ")
                .replacingOccurrences(of: "_", with: " ")
                .capitalized
        }
    }

    var withEnums: String {
        if self == "Rather not disclose" {
            return "NOT_DISCLOSED"
        } else {
            return self.replacingOccurrences(of: " ", with: "_")
                .uppercased()
        }
    }
    
    var cleanLeadingTrailing: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}

extension String {
    func width(by font: UIFont) -> CGFloat {
        self.size(withAttributes: [.font: font]).width.rounded(.up)
    }
}

extension String {
     func highlighted(text: String) -> AttributedString {
         var result = AttributedString(self)
         let ranges = self.ranges(of: text, options: [.caseInsensitive])
            ranges.forEach { range in
                result[range].foregroundColor = UIColor.primaryTroov
                result[range].inlinePresentationIntent = .stronglyEmphasized
                result[range].font = UIFont.poppins700(size: 16)
            }
        return result
    }
}

extension StringProtocol {
    func ranges<T: StringProtocol>(
        of stringToFind: T,
        options: String.CompareOptions = [],
        locale: Locale? = nil
    ) -> [Range<AttributedString.Index>] {

        var ranges: [Range<String.Index>] = []
        var attributedRanges: [Range<AttributedString.Index>] = []
        let attributedString = AttributedString(self)

        while let result = range(
            of: stringToFind,
            options: options,
            range: (ranges.last?.upperBound ?? startIndex)..<endIndex,
            locale: locale
        ) {
            ranges.append(result)
            let start = AttributedString.Index(result.lowerBound, within: attributedString)!
            let end = AttributedString.Index(result.upperBound, within: attributedString)!
            attributedRanges.append(start..<end)
        }
        return attributedRanges
    }
}

/*
extension String {
    var baseUrl: String {
        return replacingOccurrences(of: "\\{[^}]*\\}",
                                    with: "",
                                    options: .regularExpression)
        .replacingOccurrences(of: "/+",
                              with: "/",
                              options: .regularExpression)
    }
}
*/
