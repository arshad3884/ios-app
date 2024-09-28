//
//  SearchFiltersTextFieldView.swift
//  Troov
//
//  Created by  Levon Arakelyan on 20.09.2023.
//

import SwiftUI

struct SearchFiltersTextFieldView: View {
    @Binding var filters: [DiscoverFilterSettings.Filter]
    
    let cleanAction: () -> ()
    
    private var count: Int {
        filters.count
    }
    
    var body: some View {
        HStack(alignment: .top) {
            FilterTagsView(filters: $filters)
            .cornerRadius(6)
            .overlay(content: {
                if count > 0 {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.primaryTroovColor, lineWidth: 1)
                }
            })
            .frame(minHeight: 46)
            .padding(.trailing, 7)
            if filters.count > 0 {
                Button(action: cleanAction,
                       label: {
                    VStack(alignment: .center, spacing: 0) {
                        Text("Clean")
                            .fontWithLineHeight(font: .poppins400(size: 10), lineHeight: 10)
                            .foregroundColor(.primaryTroovColor)
                            .multilineTextAlignment(.center)
                        Image("filters.cancel")
                    }
                    .frame(width: 52,
                           height: 46)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.primaryTroovColor, lineWidth: 1)
                    )
                })
            }
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    SearchFiltersTextFieldView(filters: .constant([.init(type: .cost, text: "")])) {}
}
