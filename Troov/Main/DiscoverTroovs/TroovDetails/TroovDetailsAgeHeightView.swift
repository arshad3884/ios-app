//
//  TroovDetailsAgeHeightView.swift
//  Troov
//
//  Created by Levon Arakelyan on 09.10.23.
//

import SwiftUI

struct TroovDetailsAgeHeightView: View {
    
    var troov: Troov
    
    private var gender: Gender? {
        troov.createdBy?.gender
    }
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(alignment: .center,
                   spacing: 0) {
                if let gender = gender {
                    HStack(alignment: .center,
                           spacing: 0) {
                        if let image = gender.image {
                            Image(image)
                                .renderingMode(.template)
                                .foregroundStyle(Color.primaryTroovColor)
                                .padding(.trailing, 7)
                        }
                        Text(gender.rawValue.cleanEnums)
                            .fontWithLineHeight(font: .poppins600(size: 14), lineHeight: 21)
                            .foregroundStyle(Color.primaryTroovColor)
                    }.padding(.trailing, 22)
                }
                HStack(alignment: .center,
                       spacing: 5) {
                    Text("Age:")
                        .fontWithLineHeight(font: .poppins600(size: 16), lineHeight: 21)
                        .foregroundStyle(Color.primaryTroovColor)
                    Text(troov.age)
                        .fontWithLineHeight(font: .poppins600(size: 18), lineHeight: 27)
                        .foregroundStyle(Color.primaryTroovColor)
                }
                Spacer()
                HStack(alignment: .center,
                       spacing: 5) {
                    Text("Height:")
                        .fontWithLineHeight(font: .poppins600(size: 16), lineHeight: 24)
                        .foregroundStyle(Color.primaryTroovColor)
                    Text(troov.height + "ft")
                        .fontWithLineHeight(font: .poppins600(size: 18), lineHeight: 27)
                        .foregroundStyle(Color.primaryTroovColor)
                }
            }.padding(20)
        }.background(RoundedRectangle(cornerRadius: 20)
            .fill(Color(red: 0.24, green: 0.29, blue: 0.85)
                .opacity(0.04)))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .inset(by: 2)
                    .stroke(.white, lineWidth: 4)
            )
            .shadow(color: .black.opacity(0.08),
                    radius: 17, x: 0, y: 4)
    }
}

#Preview {
    TroovDetailsAgeHeightView(troov: .init())
}
