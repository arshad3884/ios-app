//
//  TPageControlOverlay.swift
//  Troov
//
//  Created by Leo on 01.05.23.
//

import SwiftUI

struct TPageControlOverlay: View {
    
    // MARK: - Public Properties
    
    @Binding var currentIndex: Int
    var pageCount: Int
    
    // MARK: - Drawing Constants
    
    private let indicatorHeight: CGFloat = 4
    private let indicatorWidth: CGFloat = 12
    private let indicatorHorizontalPadding: CGFloat = 2
    private let contentBottomAndLeadingPadding: CGFloat = 24
    private let indicatorCornerRadius: CGFloat = 14
    
    private var actualBody: some View {
        VStack(alignment: .leading, spacing: 15) {
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white)
                    .frame(width: indicatorWidth,
                           height: indicatorHeight)
                    .zIndex(1)
                    .padding(.leading, CGFloat(currentIndex)*indicatorWidth + padding)
                    .transition(.slide)
                HStack(spacing: indicatorHorizontalPadding) {
                    ForEach(0..<pageCount, id: \.self) {_ in
                        Capsule()
                            .fill(Color.white.opacity(0.5))
                            .frame(width: indicatorWidth,
                                   height: indicatorHeight)
                    }
                }
            }.padding(.leading, indicatorHorizontalPadding)
        }.padding(.leading, 15)
         .padding(.top, 10)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            HStack {
                actualBody
                Spacer()
            }
            Spacer()
        }.opacity(pageCount > 1 ? 1 : 0)
    }
    
    // MARK: - Private Methods
    
    private var padding: CGFloat {
        return CGFloat(currentIndex)*indicatorHorizontalPadding
    }
}

struct TPageControlOverlay_Previews: PreviewProvider {
    static var previews: some View {
        TPageControlOverlay(currentIndex: .constant(0),
                            pageCount: 2)
    }
}
