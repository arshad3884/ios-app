//
//  TSecondaryLabelProtocol.swift
//  Troov
//
//  Created by Levon Arakelyan on 09.05.23.
//

import SwiftUI

protocol TSecondaryLabelProtocol {}

extension TSecondaryLabelProtocol {
    func labelWithImage(systemName: String,
                        foregroundColor: Color = .primaryLighterGray) -> some View {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 10,
                   height: 10)
            .fontWeight(.bold)
            .foregroundColor(foregroundColor)
            .padding(10)
            .background(Material.ultraThinMaterial)
            .clipShape(Circle())
    }
}
