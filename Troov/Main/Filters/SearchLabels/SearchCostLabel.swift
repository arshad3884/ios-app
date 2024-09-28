//
//  SearchCostLabel.swift
//  Troov
//
//  Created by  Levon Arakelyan on 20.09.2023.
//

import SwiftUI

struct SearchCostLabel: View {
    private let items: [String] = ["1", "2", "3", "4"]
    @Binding var selectedTags: [String]
    
    var body: some View {
        HStack(alignment: .center, spacing: 2) {
            ForEach(items, id: \.self) { item in
                Button(action: { select(item) },
                       label: {
                    Image(selectedTags.contains(item) ? "cost.item.select" : "cost.item.nonselect")
                })
            }
        }
        
    }
    
    private func select(_ item: String) {
            guard let index = items.firstIndex(of: item) else {
                selectedTags = []
                return
            }
            if selectedTags.last == item {
                selectedTags = []
                return
            }
            selectedTags = Array(items.prefix(index + 1))
        }
}

#Preview {
    SearchCostLabel(selectedTags: .constant(["1"]))
}
