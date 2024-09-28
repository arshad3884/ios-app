//
//  CreateTroovView+Extensions.swift
//  Troov
//
//  Created by Levon Arakelyan on 15.09.23.
//

import SwiftUI

extension CreateTroovView {
    enum Step {
        case title
        case price
        case dateLocationTag
        case preview
        case end
    }
}

extension CreateTroovView.Step {

    var progress: Double {
        switch self {
        case .title:
            return 30
        case .price:
            return 60
        case .dateLocationTag:
            return 100
        default:
            return 0
        }
    }

    func title(isUpdate: Bool) -> String {
        switch self {
        case .title, .price, .dateLocationTag: return "\(isUpdate ? "Update" : "Create") Troov"
        case .preview: return "Preview"
        case .end: return ""
        }
    }

    func keyboardOffset(padding: CGFloat) -> CGFloat {
        switch self {
        case .title:
            return 140
        case .dateLocationTag:
            return 160 + padding
        default:
            return 0
        }
    }

    func buttonTitle(isUpdate: Bool) -> String {
        switch self {
        case .title, .price: return "Next"
        case .dateLocationTag: return "Preview"
        case .preview: return "\(isUpdate ? "Update" : "Create") Troov"
        case .end: return "Okay"
        }
    }

    func next() -> CreateTroovView.Step? {
        switch self {
        case .title: return .price
        case .price: return .dateLocationTag
        case .dateLocationTag: return .preview
        case .preview: return .end
        case .end: return nil
        }
    }
    
    func previous() -> CreateTroovView.Step? {
        switch self {
        case .title: return nil
        case .price: return .title
        case .dateLocationTag: return .price
        case .preview: return .dateLocationTag
        case .end: return .preview
        }
    }
}
