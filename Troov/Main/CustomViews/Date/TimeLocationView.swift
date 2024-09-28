//
//  TimeLocationView.swift
//  Troov
//
//  Created by Levon Arakelyan on 01.02.24.
//

import SwiftUI

struct TimeLocationView: View {
    let troov: Troov

    var body: some View {
        VStack(spacing: 6, content: {
            HStack(alignment: .center,
                   spacing: 4) {
                Text(troov.timeString)
                    .lineLimit(1)
                    .foregroundStyle(Color.primaryTroovColor)
                    .fontWithLineHeight(font: .poppins500(size: 10), lineHeight: 15)
            }.frame(width: 52)
             .softBackground
            VStack(alignment: .center,
                   spacing: 2) {
                Image("t.location")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.white)
                    .frame(width: 6, height: 8)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 4)
                    .background(Circle().fill(Color.primaryTroovColor))

                    .padding(.top, 6)
                Text(troov.locationName)
                    .lineLimit(2)
                    .foregroundStyle(Color.primaryTroovColor)
                    .fontWithLineHeight(font: .poppins400(size: 8), lineHeight: 12)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 6)
                    .frame(maxHeight: .infinity)
            }.frame(width: 52)
             .softBackground
        })
    }
}

#Preview {
    TimeLocationView(troov: .preview)
}
