//
//  TToggleView.swift
//  Troov
//
//  Created by Leo on 19.02.23.
//

import SwiftUI

struct TToggleView: View {
    @Binding var isOn: Bool
    var firstImage = Image("t.rect")
    var secondImage = Image("t.3.lines")

    private var leftPartColor: Color {
        isOn ? Color.white : Color(hex: "828282")
    }
    
    private var rightPartColor: Color {
        isOn ? Color(hex: "828282") : Color.white
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "F5F5F5"))
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(hex: "EEEEEE"),
                            lineWidth: 1))
            HStack {
                if isOn {
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.primaryTroovColor)
                    .aspectRatio(1.0, contentMode: .fit)
                if !isOn {
                    Spacer()
                }
            }.padding(4)
            HStack {
                firstImage
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(rightPartColor)
                    .aspectRatio(contentMode: .fit)
                    .onTapGesture(perform: toggle)
                    .padding(5)
                Spacer()
                secondImage
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(leftPartColor)
                    .aspectRatio(contentMode: .fit)
                    .onTapGesture(perform: toggle)
                    .padding(5)
            }
            .padding(.horizontal, 6)
        }
    }
    
    private func toggle() {
        withAnimation {
            isOn.toggle()
        }
    }
}

struct TToggleView_Previews: PreviewProvider {
    static var previews: some View {
        TToggleView(isOn: .constant(false))
    }
}
