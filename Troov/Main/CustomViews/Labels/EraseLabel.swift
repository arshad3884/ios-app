//
//  EraseLabel.swift
//  Troov
//
//  Created by Levon Arakelyan on 21.12.23.
//

import SwiftUI

struct EraseLabel: View {
    var body: some View {
        Image(systemName: "xmark")
            .font(.footnote)
            .foregroundStyle(Color.white)
            .padding(5)
            .background(Circle().fill(Color.rgba(255, 26, 26, 1)))
    }
}

#Preview {
    EraseLabel()
}
