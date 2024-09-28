//
//  HighlightButtonStyle.swift
//  mango
//
//  Created by Leo on 04.02.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct HighlightButtonStyle: ButtonStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .padding()
      .background(configuration.isPressed ? Color.primaryTroovColor : Color.white)
  }
}
