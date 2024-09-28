//
//  BottomBarButtonView.swift
//  Troov
//
//  Created by Leo on 31.08.2023.
//

import SwiftUI

struct BottomBarButtonView: View {
    var isPrimary: Bool = true
    let text: String
    let action: (() -> Void)
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: action,
                   label: {
                if isPrimary {
                    TPrimaryLabel(text: text)
                        .animation(.none, value: text)
                } else {
                    TSecondaryLabel(text: text)
                        .animation(.none, value: text)
                }
            })
            .buttonStyle(.scalable)
            .padding(.top, 16.relative(to: .height))
            .padding(.horizontal, 20.relative(to: .width))
            .frame(maxWidth: .infinity)
            .padding(.bottom, 57)
        }
         .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
         .shadow(color: .black.opacity(0.08),
                 radius: 4, x: 0, y: -4)
    }
}

struct BottomBarButtonView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarButtonView(text: "Send Me One-Time Passcode",
                            action: {})
    }
}
