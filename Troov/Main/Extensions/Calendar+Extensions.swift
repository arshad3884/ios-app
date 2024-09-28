//
//  Calendar+Extensions.swift
//  mango
//
//  Created by Leo on 14.04.22.
//  Copyright © 2022 Levon Arakelyan. All rights reserved.
//

import Foundation
import UIKit

extension Calendar {
    func age(birthDate: Date) -> Int? {
        return self.dateComponents([.year],
                                   from: birthDate,
                                   to: Date()).year
    }
}
