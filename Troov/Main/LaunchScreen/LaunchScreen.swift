//
//  LaunchScreen.swift
//  Troov
//
//  Created by Levon Arakelyan on 19.02.24.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        Color.white
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                Image("troov")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 124)
            }
    }
}

#Preview {
    LaunchScreen()
}
