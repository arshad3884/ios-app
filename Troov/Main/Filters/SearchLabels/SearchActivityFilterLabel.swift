//
//  SearchActivityFilterLabel.swift
//  Troov
//
//  Created by  Levon Arakelyan on 20.09.2023.
//

import SwiftUI


struct SearchActivityFilterLabel: View {
    let item: ActivityFilterItem
    @State private var selectedItems: [String] = []
    
    var body: some View {
        HStack(alignment: .center) {
            Text(item.filterMenuName)
                .fontWithLineHeight(font: .poppins700(size: 12), lineHeight: 12)
                .foregroundColor(.primaryTroovColor)
                .background(Color.white)
                .padding(.vertical, 12)
            if item.rawValue == "cost" {
                Button(action: showCostInfoAction,
                       label: {
                    Image("info.icon")
                })
            }
            Spacer()
            switch item {
            case .location, .distance, .availability:
                if let text = item.info {
                Text(text)
                    .foregroundColor(.primaryTroovColor)
                    .fontWithLineHeight(font: .poppins500(size: 12), lineHeight: 12)
                } else {
                    Text("Not selected")
                        .fontWithLineHeight(font: .poppins400(size: 12), lineHeight: 12)
                        .foregroundColor(Color(red: 0.65, green: 0.68, blue: 0.73))
                }
            case .cost:
                SearchCostLabel(selectedTags: $selectedItems)
            }
        }
        .background(Color.white)
        .padding(.horizontal, 10)
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.black.opacity(0.1), lineWidth: 1)
        )
    }
    
    private func showCostInfoAction() {
        
    }
}


#Preview {
    SearchActivityFilterLabel(item: .cost)
}
