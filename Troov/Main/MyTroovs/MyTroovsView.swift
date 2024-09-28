//
//  MyTroovsView.swift
//  mango
//
//  Created by Leo on 16.02.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct MyTroovsView: View {
    @Environment(MyTroovsViewModel.self) var myTroovsViewModel

    @State private var currentTaper: Taper? = .confirmed
    
    private let tapers = Taper.allCases
    
    var body: some View {
        VStack(spacing: 0) {
            MyTroovsTopBarOverlay(currentType: $currentTaper,
                                  hasUpdatesAtIndices: myTroovsViewModel.hasUpdatesAtIndices)
            .frame(height: CGFloat.navigationBarHeight)
            PageView(pages: tapers,
                     positionId: $currentTaper,
                     configuration: sliderConfiguration) { taper in
                VStack {
                    switch taper {
                    case .confirmed:
                        ConfirmedPickView()
                    case .my:
                        MyPickView()
                    case .their:
                        TheirPickView()
                    }
                }
            }.animation(.bouncy, value: currentTaper)
             .safeAreaPadding(.horizontal, sliderConfiguration.sliderHorizontalEdgesVisibleSize)
        }
        .onChange(of: currentTaper ?? .confirmed) { _ , newValue in typeChange(newValue) }
    }

    @MainActor private func typeChange(_ newType: Taper) {
        myTroovsViewModel.resetNotify(newType)
    }
}

struct MyTroovsView_Previews: PreviewProvider {
    static var previews: some View {
        MyTroovsView()
    }
}

fileprivate extension MyTroovsView {
    private var sliderConfiguration: PageViewConfiguration {
        PageViewConfiguration(sliderInteritemSpacing: 0,
                              vAlignment: .top,
                              allowScalling: false)
    }
}

extension MyTroovsView {
    enum Taper: Int, Identifiable, CaseIterable {
        case confirmed = 0
        case my = 1
        case their = 2

        var id: Taper{
            return self
        }
    }
}
