//
//  CreateTroovBodyView.swift
//  Troov
//
//  Created by Levon Arakelyan on 15.09.23.
//

import SwiftUI

struct CreateTroovBodyView: View {
    let step: CreateTroovView.Step

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            switch step {
            case .title:
                CreateTroovStepTitleView()
                    .padding(.horizontal, 14)
            case .price:
                CreateTroovStepPriceView()
                    .padding(.horizontal, 14)
            case .dateLocationTag:
                CreateTroovStepGeneralView()
                    .padding(.horizontal, 14)
            case .preview, .end:
                CreateTroovStepPreview()
            }
        }
    }
}

struct CreateTroovBodyView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTroovBodyView(step: .title)
    }
}
