//
//  MainView+CompleteRegistrationView.swift
//  Troov
//
//  Created by Levon Arakelyan on 20.09.24.
//

import SwiftUI

extension MainView {
    struct CompleteRegistrationView: View {
        let step: Step

        @Environment(\.dismiss) var dismiss
        @Environment(TRouter.self) var router

        var body: some View {
            VStack(alignment: .center, spacing: 24) {
                Text(step.title)
                    .fontWithLineHeight(font: .poppins500(size: 18), lineHeight: 18)
                    .foregroundStyle(Color.primaryBlack)
                Image("t.rocket.2d")
                Text(step.highlightedBodyText)
                    .multilineTextAlignment(.center)
                    .fontWithLineHeight(font: .poppins400(size: 16), lineHeight: 16)
                    .foregroundStyle(Color(hex: "111827").opacity(0.6))
                Button {
                    completeNow()
                } label: {
                    TPrimaryLabel(text: "Complete Now",
                                  trailingImage: Image("t.arrow.narrow.right"))
                }.buttonStyle(.scalable)
            }.padding(.horizontal, 33)
        }

        private func completeNow() {
            dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: {
                router.completeUncompleteRegistraionNow()
            })
        }
    }
}

#Preview {
    MainView.CompleteRegistrationView(step: .joinRequest)
}

extension MainView.CompleteRegistrationView {
    enum Step: String, Hashable, Identifiable {
        var id: String {
            return rawValue
        }
        
        case joinRequest
        case createTroov

        var title: String {
            return "You are almost there!"
        }
        
        var highlightedBodyText: AttributedString {
            return bodyText.highlighted(text: hightlightedText)
        }
    
        private var bodyText: String {
            switch self {
            case .joinRequest:
                return "You need to complete your profile\nbefore requesting to join a Troov"
            case .createTroov:
                return "You need to complete your profile in\norder to create a Troov"
            }
        }
    
        private var hightlightedText: String {
            switch self {
            case .joinRequest:
                return "requesting to join a Troov"
            case .createTroov:
                return "create a Troov"
            }
        }
    }
}
