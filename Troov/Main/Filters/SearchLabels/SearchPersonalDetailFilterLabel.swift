//
//  SearchPersonalDetailFilterLabel.swift
//  Troov
//
//  Created by  Levon Arakelyan on 20.09.2023.
//

import SwiftUI

struct SearchPersonalDetailFilterLabel: View {
    let item: PersonalFilterItem
    let erase: (PersonalFilterItem) -> ()

    private var isSelected: Bool {
        filter != nil
    }

    private var filter: String? {
        item.filtered
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Text(item.name)
                .fontWithLineHeight(font: .poppins700(size: 12), lineHeight: 12)
                .foregroundColor(.black)
                .background(Color.white)
            Spacer()
            if let text = filter {
                Text(text.cleanEnums)
                .foregroundColor(.primaryTroovColor)
                .fontWithLineHeight(font: .poppins500(size: 12), lineHeight: 12)
            } else {
                Text("Not selected")
                    .fontWithLineHeight(font: .poppins400(size: 12), lineHeight: 12)
                    .foregroundColor(Color(red: 0.65, green: 0.68, blue: 0.73))
            }
        
            if isSelected {
                Button(action: { erase(PersonalFilterItem(emptyItem: item)) }) {
                    EraseLabel()
                }.padding(.horizontal, 5)
            }
        }
        .background(Color.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.black.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    SearchPersonalDetailFilterLabel(item: .education()) {_ in}
}
