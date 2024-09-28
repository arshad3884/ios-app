//
//  FilterTagsView.swift
//  Troov
//
//  Created by Levon Arakelyan on 26.09.23.
//

import SwiftUI

struct FilterTagsView: View {
    @Binding var filters: [DiscoverFilterSettings.Filter]

    private let leadingSpacing: CGFloat = 10
    private let vSpacing: CGFloat = 10
    private let hSpacing: CGFloat = 10

    var body: some View {
        FlexibleStack(alignment: .leading) {
            ForEach(filters) { filter in
                TTagTextField.Label(image: filter.type.image,
                               text: filter.text,
                               isSelected: true,
                               height: 40,
                               fontSize: 12) {
                    remove(filter)
                }
            }
        }.animation(.smooth, value: filters.count)
         .padding(5)
    }

    private func remove(_ filter: DiscoverFilterSettings.Filter) {
        if let index = filters.firstIndex(where: {$0.id == filter.id}) {
            filters.remove(at: index)
        }
    }
}

#Preview {
    FilterTagsView(filters: .constant([.init(type: .cost, text: "Cost")]))
}
