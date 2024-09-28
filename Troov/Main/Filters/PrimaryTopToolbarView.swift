//
//  PrimaryTopToolbarView.swift
//  Troov
//
//  Created by  Levon Arakelyan on 20.09.2023.
//

import SwiftUI

struct PrimaryTopToolbarView: View {
    let title: String
    let action: (() -> Void)
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
              Button(action: action,
                  label: {
                Image("t.arrow.narrow.left")
                  .renderingMode(.template)
                  .foregroundStyle(Color.white)
                  .padding(.leading, 13)
                  .padding(.top, 17)
                  .padding(.bottom, 19)
              })
              Text(title)
                .foregroundColor(.white)
                .fontWithLineHeight(font: .poppins700(size: 16), lineHeight: 16)
                .padding(.leading, 11)
                .padding(.top, 18)
                .padding(.bottom, 21)
              Spacer()
            }.background(Color.primaryTroovColor)
    }
}

#Preview {
    PrimaryTopToolbarView(title: "Search filters",
                          action: {})
}
