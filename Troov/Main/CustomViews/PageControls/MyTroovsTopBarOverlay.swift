//
//  MyTroovsTopBarOverlay.swift
//  mango
//
//  Created by Leo on 17.02.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct MyTroovsTopBarOverlay: View {
    @Binding var currentType: MyTroovsView.Taper?
    
    private var currentIndex: Int {
        currentType?.rawValue ?? 0
    }
    
    var hasUpdatesAtIndices: [MyTroovsView.Taper]? = nil
    private let buttonTitle = ["Confirmed", "My Troovs", "My Requests"]
    private let images = ["t.two.person", "t.lightbulb.blue", "t.theirpick.person"]
    
    // MARK: - Drawing Constants
    
    private let indicatorHeight: CGFloat = 2
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    private var indicatorWidth: CGFloat {
        screenWidth/3
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: 5) {
            Spacer()
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(MyTroovsView.Taper.allCases, id: \.rawValue) { type in
                    let pageIndex = type.rawValue
                    if shouldShowPageIndex(pageIndex) {
                        Button(action: { select(type) },
                               label: {
                            VStack(alignment: .center,
                                   spacing: 3){
                                Spacer()
                                Image(images[pageIndex])
                                Text(buttonTitle[pageIndex])
                                    .fontWithLineHeight(font: currentIndex == pageIndex ?
                                                        UIFont.poppins600(size: 14) :
                                                            UIFont.poppins500(size: 14),
                                                        lineHeight: 21)
                                    .foregroundColor(currentIndex == pageIndex ?
                                                     Color.primaryTroovColor :
                                                        Color.primaryBlack.opacity(0.8))
                                    .overlay(alignment: .leading) {
                                        if let types = hasUpdatesAtIndices,
                                           types.contains(where: {$0.rawValue == pageIndex}) {
                                            Circle()
                                                .fill(Color.primaryTroovRed)
                                                .frame(width: 6,
                                                       height: 6)
                                                .padding(.leading, -9)
                                        }
                                    }
                            }
                        }).frame(width: screenWidth/3)
                    }
                }
            }
            Color.primaryTroovColor
                .frame(width: indicatorWidth,
                       height: indicatorHeight)
                .position(x: CGFloat(currentIndex)*screenWidth/3 +
                          screenWidth/6)
                .animation(.easeInOut, value: currentIndex)
                .transition(.slide)
        }
    }
    
    private func shouldShowPageIndex(_ index: Int) -> Bool {
        ((currentIndex - 2)...(currentIndex + 2)).contains(index)
    }
    
    private func select(_ type: MyTroovsView.Taper) {
        withAnimation {
            currentType = type
        }
    }
}

struct MyTroovsTopBarOverlay_Previews: PreviewProvider {
    static var previews: some View {
        MyTroovsTopBarOverlay(currentType: .constant(.confirmed),
                              hasUpdatesAtIndices: [.confirmed])
    }
}
