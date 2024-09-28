//
//  CostInfoRow.swift
//  Troov
//
//  Created by Levon Arakelyan on 03.10.23.
//

import SwiftUI

struct CostInfoRow: View {
    var info: CostInfoSheetView.Info
    var disabled = true
    var select: ((CostInfoSheetView.Info) -> ())? = nil
    private let lastItem = CostInfoSheetView.Info.info.last!

    private var selectedTags: [String] {
        lastItem.selectedTags
    }
    
    private func isSelected(_ item: String) -> Bool {
       return info.selectedTags.contains(item)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if disabled {
                Text(info.price)
                    .fontWithLineHeight(font: .poppins400(size: 16), lineHeight: 16)
                Spacer()
            }
            HStack(spacing: 5) {
                ForEach(lastItem.selectedTags, id: \.self) { item in
                    Button(action: { select(item) }) {
                        Image("cost.item.select")
                            .renderingMode(.template)
                            .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13)
                                .opacity(isSelected(item) ? 1 : 0.2))
                            .background(Color.white)
                    }.disabled(disabled)
                }
            }
        }
    }

    private func select(_ item: String) {
        var selectedTags: [String] = []

        let selectedPrices = info.selectedTags

        if let index = Int(item), selectedPrices.count - 1 == index {
            selectedTags = []
        } else {
            var capacity: Int = 0
            if let index = selectedPrices.firstIndex(of: item) {
                capacity = index
            } else {
                if let index = lastItem.selectedTags.firstIndex(of: item) {
                    capacity = index
                }
            }
            /*
             Filter
             */
            var initial: Int = 0
            while initial <= capacity {
                selectedTags.append("\(initial)")
                initial += 1
            }
        }
        
        var info = self.info

        info.selectedTags = selectedTags
        select?(info)
    }
}

#Preview {
    CostInfoRow(info: .info[0])
}
