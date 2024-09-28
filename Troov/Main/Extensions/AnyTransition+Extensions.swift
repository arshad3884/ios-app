//
//  AnyTransition+Extensions.swift
//  mango
//
//  Created by Leo on 08.12.21.
//  Copyright © 2021 Levon Arakelyan. All rights reserved.
//

import SwiftUI

 extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))}
}
