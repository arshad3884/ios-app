//
//  TDoubleDividerView.swift
//  Troov
//
//  Created by Levon Arakelyan on 16.11.23.
//

import SwiftUI

struct TDoubleDividerView: View {
    var title: String
    
    var body: some View {
        HStack(alignment: .center,
               spacing: 10) {
            Rectangle().fill(Color.rgba(0, 0, 0, 0.1))
                .frame(height: 1)
                .frame(maxWidth: .infinity)
            Text(title)
            Rectangle().fill(Color.rgba(0, 0, 0, 0.1))
                .frame(height: 1)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    TDoubleDividerView(title: "or")
}
