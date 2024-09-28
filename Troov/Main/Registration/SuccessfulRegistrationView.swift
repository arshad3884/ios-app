//
//  SuccessfulRegistrationView.swift
//  Troov
//
//  Created by Leo on 01.09.2023.
//

import SwiftUI

struct SuccessfulRegistrationView: View {
    var body: some View {
        VStack(alignment: .center,
               spacing: 32.relative(to: .height)) {
            Image("checkmark.item")
            Text("You Are All Set!")
                .fontWithLineHeight(font: .poppins600(size: 16), lineHeight: 16)
                .foregroundColor(.rgba(51, 51, 51, 1))
        }
    }
}

struct SuccessfulRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessfulRegistrationView()
    }
}
