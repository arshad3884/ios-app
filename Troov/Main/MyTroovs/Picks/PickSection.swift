//
//  PickSection.swift
//  mango
//
//  Created by Leo on 14.10.21.
//  Copyright © 2021 Levon Arakelyan. All rights reserved.
//

import Foundation

struct PickSection: Identifiable, Equatable {
    static func == (lhs: PickSection,
                    rhs: PickSection) -> Bool {
        return lhs.id == rhs.id
    }

    let id: String = UUID().uuidString
    let type: MyTroovsView.Taper
    var troovs: [Troov]

    static var preview: PickSection {
        PickSection(type: .my,
                     troovs: [.preview])
    }
}

extension PickSection {
    var day: String {
        troovs.first?.weekDayMonth ?? ""
    }
}
