//
//  CreateTroovStepPreview.swift
//  Troov
//
//  Created by Levon Arakelyan on 22.09.23.
//

import SwiftUI

struct CreateTroovStepPreview: View {
    @Environment(CreateTroovViewModel.self) var viewModel

    private var troov: Troov {
        viewModel.troov!
    }
 
    private let horizontalPadding = 10.0

    private var isBig: Bool {
        viewModel.previewCellIsBig
    }
    
    var body: some View {
        VStack {
            TTroovCell(troov: troov,
                       isExpanded: !isBig,
                       isOwn: false) {
                withAnimation {
                    viewModel.previewCellIsBig.toggle()
                }
            } seeDetails: {} showLocation: { _ in } request: {}
        }
    }
}

#Preview {
    CreateTroovStepPreview()
}
