//
//  AttentionModifier.swift
//  Troov
//
//  Created by Levon Arakelyan on 09.08.24.
//

import SwiftUI

extension View {
    func softAttentionAnimation(triggerAttention: Bool,
                                ceaseAnimation: Bool,
                                background: AttentionModifier.Background) -> some View {
        self.modifier(AttentionModifier.softAttentionAnimation(triggerAttention: triggerAttention,
                                                               ceaseAnimation: ceaseAnimation,
                                                               background: background))
    }
}

extension ViewModifier where Self == AttentionModifier {
    static func softAttentionAnimation(triggerAttention: Bool,
                                       ceaseAnimation: Bool,
                                       background: AttentionModifier.Background) -> AttentionModifier { .init(triggerAttention: triggerAttention,
                                                                                                              ceaseAnimation: ceaseAnimation,
                                                                                                              background: background) }
}


struct AttentionModifier: ViewModifier {
    let triggerAttention: Bool
    let ceaseAnimation: Bool
    let background: Background
    
    @State private var animateAttentionTriggrer = false

    @State private var gradientsOfAnimation: [Color] = []
    @State private var borderColor: Color = .clear
    
    private var attentionAnimationGradientColors: [Color] {
        if !animateAttentionTriggrer {
           return [.clear]
        } else {
           return gradientsOfAnimation
        }
    }

    private var animation: Animation? {
        if !animateAttentionTriggrer {
            return .default
        } else {
            return .easeInOut(duration: 0.2)
                   .repeatCount(1, autoreverses: true)
        }
    }

    func body(content: Content) -> some View {
        content
        /**
         Animate attention
         */
        .onChange(of: triggerAttention, { _, _ in
            gradientsOfAnimation = [Color.primaryTroovColor.opacity(0.01),
                                    Color.primaryTroovColor.opacity(0.11)]
            borderColor = .primaryTroovColor
            animateAttentionTriggrer = true
            withAnimation(.easeOut(duration: 0.5).delay(0.6)) {
                gradientsOfAnimation = []
                borderColor = .clear
            }
        }).onChange(of: ceaseAnimation, { _, newValue in
            animateAttentionTriggrer = false
        })
        .background(alignment: .center,
                    content: {
            ZStack {
                background
                    .viewFill(color: .primaryLightGray)
                    .opacity(animateAttentionTriggrer ? 0.0 : 1.0)
                background.viewFill(linerGradient: LinearGradient(colors: attentionAnimationGradientColors,
                                                                  startPoint: .trailing,
                                                                  endPoint: .leading))
                    .opacity(ceaseAnimation || !animateAttentionTriggrer ? 0.0 : 1.0)
            }
        })
        .overlay {
            if animateAttentionTriggrer && !ceaseAnimation {
                background.viewStroke(color: borderColor, lineWith: 1)
            }
        }
         .scaleEffect(animateAttentionTriggrer ? 1.01 : 1.0)
         .animation(animation, value: animateAttentionTriggrer)
    }
}

extension AttentionModifier {
    enum Background {
        case capsule
        case roundedRectangle(radius: Double)

        func viewFill(linerGradient: LinearGradient) -> some View {
            Group {
                switch self {
                case .capsule:
                    Capsule().fill(linerGradient)
                case .roundedRectangle(let radius):
                    RoundedRectangle(cornerRadius: radius).fill(linerGradient)
                }
            }
        }
        
        func viewFill(color: Color) -> some View {
            Group {
                switch self {
                case .capsule:
                    Capsule().fill(color)
                case .roundedRectangle(let radius):
                    RoundedRectangle(cornerRadius: radius).fill(color)
                }
            }
        }
        
        func viewStroke(color: Color, lineWith: Double) -> some View {
            Group {
                switch self {
                case .capsule:
                    Capsule().stroke(color, lineWidth: lineWith)
                case .roundedRectangle(let radius):
                    RoundedRectangle(cornerRadius: radius).stroke(color, lineWidth: lineWith)
                }
            }
        }
    }
}
