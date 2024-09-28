//
//  ConfirmChatView.swift
//  Troov
//
//  Created by Levon Arakelyan on 02.11.23.
//

import SwiftUI

struct ConfirmChatView: View {
    let confirm: (() -> ())
    let cancel: (() -> ())
    var isPending: Bool = false

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center) {
                Button(action: cancel) {
                    TPrimaryLabel(text: "Cancel",
                                  style: .destructive)
                }.buttonStyle(.scalable)
                if !isPending {
                    Spacer()
                    Button(action: confirm) {
                        TPrimaryLabel(text: "Confirm")
                    }.buttonStyle(.scalable)
                }
            }.padding(.horizontal, 20)
             .padding(.vertical, 14)
             .frame(maxWidth: .infinity)
        }.background(Color.white)
         .ignoresSafeArea()
    }
}

#Preview {
    ConfirmChatView(confirm: {},
                    cancel: {})
}
