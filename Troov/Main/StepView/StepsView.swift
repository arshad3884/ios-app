//
//  StepsView.swift
//  mango
//
//  Created by Leo on 08.01.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct StepsView: View {
    @Environment(TRouter.self) var router: TRouter

    var title: String
    var subtitle: String
    var subtitleButton: String
    var step: Int
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .fill(Color.primaryGray6)
                        .frame(height: 209)
                        .padding(.top, 0)
                    VStack(alignment: .leading,
                           spacing: 0,
                           content: {
                        Text(title)
                            .fontWithLineHeight(font: .poppins600(size: 26), lineHeight: 28)
                            .foregroundColor(.primaryBlack)
                            .padding(.top, 60)
                        HStack(spacing: 0,
                               content: {
                            Text(subtitle)
                                .fontWithLineHeight(font: .poppins400(size: 14), lineHeight: 15)
                                .foregroundColor(.primaryBlack)
                            Button {
                                Task { await router.auth0(type: .signIn) }
                            } label: {
                                Text(subtitleButton)
                                    .fontWithLineHeight(font: .poppins400(size: 14), lineHeight: 15)
                                    .foregroundColor(.primaryTroovColor)
                                    .padding(.leading, 2)
                            }
                            Spacer()
                        }).padding(.top, 16)
                    }).padding(.leading, 24)
                }
                StepView(step: self.step,
                         titles: ["Personal", "Professional", "Add Images"])
                .padding(.bottom, 24)
            }
        }
    }
}

struct StepsView_Previews: PreviewProvider {
    static var previews: some View {
        StepsView(title: "Register",
                  subtitle: "Already have an account?",
                  subtitleButton: "Login",
                  step: 0)
    }
}
