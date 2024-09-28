//
//  SearchPersonalFiltresView.swift
//  Troov
//
//  Created by  Levon Arakelyan on 20.09.2023.
//

import SwiftUI

struct SearchPersonalFiltresView: View {
    @Binding var items: [PersonalFilterItem]
    @State private var item: PersonalFilterItem?
    
    var body: some View {
        ForEach(items, id: \.id) { item in
            Button(action: { self.item = item }) {
                SearchPersonalDetailFilterLabel(item: item,
                                                erase: erase(_:))
                .id(item.id)
            }
        }
        .sheet(item: $item) { item in
            PersonalFiltersSheetView(item: item,
                                     selection: select(_:),
                                     erase: erase(_:))
            .presentationDetents(item.detents)
            .presentationCornerRadius(24)
        }
    }
    
    private func select(_ item: PersonalFilterItem) {
        if let index = items.firstIndex(where: {$0.name == item.name}) {
            self.items[index] = item
        }
    }
    
    private func erase(_ item: PersonalFilterItem) {
        if let index = items.firstIndex(where: {$0.name == item.name}) {
            items[index] = item
        }
    }
}

#Preview {
    SearchPersonalFiltresView(items: .constant([]))
}
