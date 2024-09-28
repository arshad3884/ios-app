//
//  OnboardingBottomToolbar.swift
//  Troov
//
//  Created by Levon Arakelyan on 13.11.23.
//

import SwiftUI

struct OnboardingBottomToolbar: View {
    let signIn: () -> ()
    let createAccount: () -> ()
    var body: some View {
        VStack(alignment: .center,
               spacing: 0, content: {
            Image("troov")
                .padding(2.4)
            Text("“Meet someone special\ndoing what you love!“")
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fontWithLineHeight(font: .poppins400(size: 18), lineHeight: 27)
                .foregroundStyle(Color.primaryTroovColor)
                .padding(.vertical, 15)
            Button(action: createAccount,
                   label: {
                TPrimaryLabel(text: "Create an account")
            }).buttonStyle(.scalable)
              .padding(.horizontal, 40)
              .padding(.bottom, 20)
            alreadyHaveAnAccount
        })
        .padding(.vertical, 40)
        .background(Color.white)
        .clipShape(RoundedShape(radius: 20, corners: [.topLeft, .topRight]))
    }
}

#Preview {
    OnboardingBottomToolbar {} createAccount: {}
}

extension OnboardingBottomToolbar {
    fileprivate var alreadyHaveAnAccount: some View {
        HStack(spacing: 3) {
            Text("Already have an account?")
                .fontWithLineHeight(font: .poppins400(size: 14),
                                    lineHeight: 21)
                .foregroundColor(.black.opacity(0.7))
            Button(action: signIn,
                   label: {
                Text("Sign In")
                    .fontWithLineHeight(font: .poppins600(size: 14),
                                        lineHeight: 21)
                    .foregroundColor(.primaryTroovColor)
            }).buttonStyle(.scalable)
        }
    }
}
