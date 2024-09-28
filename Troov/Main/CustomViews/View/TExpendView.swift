//
//  TExpendView.swift
//  Troov
//
//  Created by Levon Arakelyan on 01.09.23.
//

import SwiftUI

struct TExpendView: View {
    var isSelected: Bool
    
    var body: some View {
        Circle()
        .stroke(isSelected ?  Color.white : Color.primaryTroovColor, lineWidth: 1)
        .frame(width: 33, height: 33)
        .overlay {
            Image(isSelected ? "t.reduce" : "t.expend")
                .renderingMode(.template)
                .foregroundStyle(isSelected ?  Color.white : Color.primaryTroovColor)
        }
    }
}

struct TExpendView_Previews: PreviewProvider {
    static var previews: some View {
        TExpendView(isSelected: false)
    }
}
