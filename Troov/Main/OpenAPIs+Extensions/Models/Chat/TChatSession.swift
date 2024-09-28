//
//  TChatSession.swift
//  Troov
//
//  Created by Levon Arakelyan on 24.08.23.
//

import SwiftUI

struct TChatSession {
    var state: ChatSession.State
    var troov: Troov
    var images: [TServerImage]?
    var title: String?
}
