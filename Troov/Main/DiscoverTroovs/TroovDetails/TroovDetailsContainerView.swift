//
//  TroovDetailsContainerView.swift
//  Troov
//
//  Created by Levon Arakelyan on 19.12.23.
//

import SwiftUI

struct TroovDetailsContainerView: View {
    @Environment(\.dismiss) var dismiss

    let troov: Troov

    var body: some View {
        TroovDetailsView(troov: troov)
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.visible, for: .navigationBar)
            .ignoresSafeArea(edges: .bottom)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: { dismiss() }) {
                            Image("t.arrow.narrow.left")
                                .enlargeTapAreaForTopLeadingButton
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        HStack(alignment: .center,
                               spacing: 10,
                               content: {
                            Image("t.light.bulb.flash")
                            Text(troov.title)
                                .lineLimit(2)
                                .fontWithLineHeight(font: .poppins500(size: 16), lineHeight: 19)
                                .foregroundColor(.primaryTroovColor)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        })
                    }
                }
    }
}

#Preview {
    TroovDetailsContainerView(troov: .preview)
}
