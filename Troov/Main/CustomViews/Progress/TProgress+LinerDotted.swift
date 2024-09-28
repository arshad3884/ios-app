//
//  TProgress+LinerDotted.swift
//  Troov
//
//  Created by Levon Arakelyan on 18.09.24.
//

import SwiftUI

extension TProgress {
    struct LinerDotted: View {
        let configuration: Configuration
        let current: Int

        var body: some View {
            HStack(alignment: .center, spacing: configuration.spacing) {
                ForEach(0..<configuration.count, id: \.self) { index in
                    Capsule()
                        .fill(fillColor(index: index))
                        .frame(height: configuration.height)
                }
            }
        }

        private func fillColor(index: Int) -> Color {
            return index > current ? Color(hex: configuration.fill) : .primaryTroovColor
        }
    }
}

#Preview {
    TProgress.LinerDotted(configuration: .init(count: 10),
                          current: 0)
}

extension TProgress.LinerDotted {
    struct Configuration {
        let count: Int
        var height: CGFloat = 6
        var spacing: CGFloat = 4
        var fill: String = "E8EBED"
    }
}
