//
//  TroovPriceTierView.swift
//  Troov
//
//  Created by Levon Arakelyan on 09.10.23.
//

import SwiftUI

struct TroovPriceTierView: View {
    @State private var tiers: [ExpenseRating] = []
    var tier: ExpenseRating?

    var currentTierIndex: Int? {
        guard let tier = tier else { return nil }
        return tiers.firstIndex(of: tier)
    }
    
    var body: some View {
        HStack(spacing: tier == .free ? 0 : 6) {
            if let currentTierIndex = currentTierIndex {
                ForEach(tiers, id: \.self) { tier in
                    let index = tiers.firstIndex(of: tier)!
                    Image("t.dollar")
                        .renderingMode(.template)
                        .foregroundStyle(index <= currentTierIndex ? Color.primaryTroovColor : Color.rgba(189, 189, 189, 1))
                }
            } else {
                Text("Free")
                    .fontWithLineHeight(font: .poppins500(size: 16), lineHeight: 18)
                    .foregroundStyle(Color.primaryTroovColor)
            }
        }.onAppear(perform: appear)
    }

    private func appear() {
        var tiers: [ExpenseRating] = ExpenseRating.allCases
        
        if let index = tiers.firstIndex(where: {$0 == .free}) {
            tiers.remove(at: index)
        }
       
        self.tiers = tiers
    }
}

#Preview {
    TroovPriceTierView(tier: .dollar)
}
