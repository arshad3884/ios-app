//
//  RegistrationExitQuestionnaireView.swift
//  Troov
//
//  Created by Levon Arakelyan on 08.02.24.
//

import SwiftUI

struct RegistrationExitQuestionnaireView: View {
    @Environment(\.dismiss) private var dismiss

    let skip: () -> ()
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                Color(red: 0.91, green: 0.92, blue: 0.93)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                Image("t.info")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.primaryTroovColor)
                    .frame(width: 60, height: 60)
            }
            Text("The next few questions are dating filters. Feel free to skip if you are not interested in dating.")
                .fontWithLineHeight(font: .poppins500(size: 18),
                                    lineHeight: 21)
                .foregroundStyle( Color.rgba(17, 24, 39, 1))
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .padding(.top, 24)
            Text("Note: You can always enter this information later in your profile settings.")
                .fontWithLineHeight(font: .poppins400(size: 16),
                                    lineHeight: 19)
                .foregroundStyle( Color.rgba(17, 24, 39, 1))
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .padding(.top, 24)
            
            HStack(spacing: 16) {
                Button(action: skipAction) {
                    TPrimaryLabel(text: "Skip")
                }.buttonStyle(.scalable)
                Button(action: `continue`) {
                    TPrimaryLabel(text: "Continue")
                }.buttonStyle(.scalable)
            }.padding(.top, 24)
        }.padding(.horizontal, 20)
         .presentationDetents([.fraction(0.6)])
         .presentationDragIndicator(.visible)
         .presentationCornerRadius(24)
    }

    private func skipAction() {
        dismiss()
        skip()
    }

    private func `continue`() {
        dismiss()
    }
}

#Preview {
    RegistrationExitQuestionnaireView {}
}
