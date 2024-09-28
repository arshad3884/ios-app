//
//  SearchTextFieldLabel.swift
//  Troov
//
//  Created by  Levon Arakelyan on 20.09.2023.
//

import SwiftUI

struct SearchTextFieldLabel: View {
    let text: String
    let action: (() -> Void)
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text(text)
                .fontWithLineHeight(font: .poppins400(size: 12), lineHeight: 12)
                .foregroundColor(.primaryTroovColor)
            Button(action: action,
                   label: {
                Image("filters.remove")
            })
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(Color(red: 0.07, green: 0.18, blue: 0.42).opacity(0.05))
        .cornerRadius(15)
    }
}

#Preview {
    SearchTextFieldLabel(text: "Undergraduate", action: {})
}
