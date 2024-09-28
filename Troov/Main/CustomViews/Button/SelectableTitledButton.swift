//
//  SelectableTitledButton.swift
//  mango
//
//  Created by Leo on 12.01.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct SelectableTitledButton: View {

    let title: String
    var text: String
    var image: Image
    var selectedImage: Image

    @Binding var choose: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 21)
                .foregroundColor(Color.primaryBlack)
                .padding(.bottom, 8)
            Button(action: {
                choose.toggle()
            }, label: {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.primaryTextFieldGray)
                        .frame(height: 48)
                    HStack {
                        Text(text)
                            .fontWithLineHeight(font: .poppins400(size: 14), lineHeight: 21)
                            .foregroundColor(Color.primaryBlack.opacity(0.8))
                        Spacer()
                        Group {
                            self.choose ? selectedImage : image
                        }.foregroundColor(Color.primaryDarkGray)
                    }.padding(.horizontal, 16)
                }
            })
        }
    }
}

struct SelectableTitledButton_Previews: PreviewProvider {
    static var previews: some View {
        SelectableTitledButton(title: "Gender",
                         text: "Select",
                         image: Image("t.arrow.down"),
                         selectedImage: Image("chevron.up"),
                         choose: .constant(false))
    }
}
