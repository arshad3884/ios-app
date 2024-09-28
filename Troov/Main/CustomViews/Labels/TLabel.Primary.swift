//
//  TLabel.Primary.swift
//  Troov
//
//  Created by Levon Arakelyan on 08.08.24.
//

import SwiftUI

extension TLabel {
    struct Primary: View {
        var image: Image?
        let text: String
        var height: CGFloat = 56.0
        var style: Style = .affirmative
        var isLoading: Bool = false
        
        private var foregroundColor: Color {
            style == .affirmative ? .white : .primaryTroovRed
        }
        
        private var backgroundColor: Color {
            style == .affirmative ? .primaryTroovColor : .primaryTroovRed.opacity(0.1)
        }
        
        var body: some View {
            HStack(spacing: 0) {
                if let image = image {
                    image
                        .padding(.trailing, 10)
                }
                Text(text)
                    .fontWithLineHeight(font: .poppins700(size: 18), lineHeight: 18)
                
                if isLoading {
                    ProgressView().progressViewStyle(.circular)
                        .padding(.leading, 5)
                }
            }
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .foregroundStyle(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(height/2)
        }
    }
}

extension TLabel.Primary {
    enum Style {
        case destructive
        case affirmative
    }
}

#Preview {
    TLabel.Primary(text: "Primary Label")
}
