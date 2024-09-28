//
//  CreateTroovTopBarView.swift
//  Troov
//
//  Created by Levon Arakelyan on 15.09.23.
//

import SwiftUI

struct CreateTroovTopBarView: View {
    var step: CreateTroovView.Step

    var body: some View {
        ProgressView(value: step.progress, total: 100)
                .tint(.primaryTroovColor)
                .foregroundColor(.rgba(243, 243, 243, 1))
                .padding(.horizontal, 14.relative(to: .width))
    }
}

struct CreateTroovTopBarView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTroovTopBarView(step: .title)
    }
}
