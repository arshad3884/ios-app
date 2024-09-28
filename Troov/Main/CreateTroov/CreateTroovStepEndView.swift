//
//  CreateTroovStepEndView.swift
//  Troov
//
//  Created by Levon Arakelyan on 22.09.23.
//

import SwiftUI

struct CreateTroovStepEndView: View {
    var body: some View {
        VStack(alignment: .center,
               spacing: 32.relative(to: .height)) {
            Image("checkmark.item")
            Text("Your Troov has been\nsuccessfully posted!")
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fontWithLineHeight(font: .poppins600(size: 16), lineHeight: 16)
                .foregroundStyle(Color.rgba(51, 51, 51, 1))
        }
    }
}

#Preview {
    CreateTroovStepEndView()
}
