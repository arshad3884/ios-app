//
//  SelectableButton.swift
//  mango
//
//  Created by Leo on 26.02.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct SelectableButton: View {
    var text: String
    var image: Image
    var selectedImage: Image
    @Binding var choose: Bool
    var passive = true

    var body: some View {
            Button(action: {
                withAnimation {
                    self.choose.toggle()
                }
            }, label: {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.primaryTroovLightGray)
                        .frame(height: 40)
                    HStack {
                        Text(text)
                            .lineLimit(1)
                            .fontWithLineHeight(font: .poppins400(size: 14),
                                                lineHeight: 20)
                            .foregroundColor(self.passive ? Color.primaryBlack.opacity(0.4) : .primaryBlack)
                        Spacer()
                        Group {
                            self.choose ? selectedImage : image
                        }.foregroundColor(self.passive ? Color.primaryBlack.opacity(0.4) : Color.primaryBlack)
                    }.padding(.horizontal, 8)
                }
            })
    }
}

struct SelectableButton_Previews: PreviewProvider {
    static var previews: some View {
        SelectableButton(text: "Select",
                         image: Image("t.arrow.down"),
                         selectedImage: Image("chevron.up"),
                         choose: .constant(false))
    }
}
