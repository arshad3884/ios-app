//
//  OnboardingPageControl.swift
//  Troov
//
//  Created by Levon Arakelyan on 13.11.23.
//

import SwiftUI

struct OnboardingPageControl: View {
    var bodyText: LocalizedStringKey
    var pagesCount: Int
    var currentPage: Int
    var onPageChange: (Int) -> ()

    var body: some View {
        VStack(alignment: .center,
               spacing: 10) {
            Image("t.double.comma.symbol")
            Text(bodyText)
                .fontWithLineHeight(font: .poppins600(size: 14), lineHeight: 21)
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
                .lineLimit(2...3)
                .frame(maxWidth: .infinity)
                .animation(.easeIn, value: currentPage)
            PageControl(pagesCount: pagesCount,
                        currentPage: currentPage,
                        onPageChange: onPageChange)
        }.padding(.vertical, 15)
         .background(RoundedRectangle(cornerRadius: 20)
            .stroke(Color.white, lineWidth: 3)
            .background(Material.ultraThinMaterial))
         .clipShape(RoundedRectangle(cornerRadius: 20))
         .padding(.horizontal, 20)
    }
}

#Preview {
    OnboardingPageControl(bodyText: "Pool night at my preferred dive,\nyou in?",
                          pagesCount: 3,
                          currentPage: 0,
                          onPageChange: { _ in })
}
