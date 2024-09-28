//
//  TimeOfDay+Extension.swift
//  Troov
//
//  Created by Levon Arakelyan on 25.12.23.
//

import Foundation

extension TimeOfDay: Identifiable {
    public var id: TimeOfDay {
        return self
    }
    
    var title: String {
        switch self {
        case .earlyMorning:
            return "Early Morning"
        case .morning:
            return "Morning"
        case .afternoon:
            return "Afternoon"
        case .evening:
            return "Evening"
        case .night:
            return "Night"
        }
    }

    var components: (String, String) {
        switch self {
        case .earlyMorning:
            return ("1:00 am", "8:00 am")
        case .morning:
            return ("8:00 am", "12:00 pm")
        case .afternoon:
            return ("12:00 am", "5:00 pm")
        case .evening:
            return ("5:00 pm", "8:00 pm")
        case .night:
            return ("8:00 pm", "1:00 am")
        }
    }

    var info: [String] {
        switch self {
        case .earlyMorning:
            return ["1", "8"]
        case .morning:
            return ["8", "12"]
        case .afternoon:
            return ["12", "17"]
        case .evening:
            return ["17", "20"]
        case .night:
            return ["20", "1"]
        }
    }
}
