//
//  ExpendingRating+Extensions.swift
//  Troov
//
//  Created by Levon Arakelyan on 22.11.23.
//

import Foundation

/** Cost of the date:  * FREE  | no cost  * $     | < $20  * $$    | $20 - $40  * $$$   | $40 - $100  * $$$$  | > $100  */
extension ExpenseRating: Identifiable {
    public var id: ExpenseRating {
        return self
    }

    var priceRangeText: String {
        switch self {
        case .free:
            return "FREE"
        case .dollar:
            return "LESS THAN $20"
        case .dollarDollar:
            return "$20 TO $40"
        case .dollarDollarDollar:
            return "$40 TO $100"
        case .dollarDollarDollarDollar:
            return "MORE THAN $100"
        }
    }
    
    var priceRangeBareText: String {
        switch self {
        case .free:
            return "FREE"
        case .dollar:
            return "LESS THAN 20"
        case .dollarDollar:
            return "20 TO 40"
        case .dollarDollarDollar:
            return "40 TO 100"
        case .dollarDollarDollarDollar:
            return "MORE THAN 100"
        }
    }
}
