//
//  MyPickCell.swift
//  mango
//
//  Created by Leo on 15.03.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct MyPickCell: View {
    var troov: Troov
    let cancelMyTroov: (Troov) -> ()
    let editMyTroov: (Troov) -> ()
    let interested: (Troov) -> ()

    private var hasInterested: Bool {
        troov.interestedInImages.count > 0
    }

    var body: some View {
        HStack(alignment: .center,
               spacing: 18) {
            VStack() {
                HStack(alignment: .center, spacing: 10) {
                    Image("t.light.bulb.flash")
                    Text(troov.title)
                        .fontWithLineHeight(font: .poppins500(size: 12), lineHeight: 18)
                        .foregroundStyle(Color.rgba(51, 51, 51, 1))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    Menu {
                        Button {
                            editMyTroov(troov)
                        } label: {
                            Label("Edit Troov", systemImage: "pencil")
                                .imageScale(.small)
                        }
                        Button(role: .destructive) {
                            cancelMyTroov(troov)
                        } label: {
                            Label("Cancel Troov", systemImage: "x.circle")
                                .imageScale(.small)
                        }
                    } label: {
                        Image("t.photo.edit")
                            .renderingMode(.template)
                            .foregroundStyle(Color.white)
                            .padding(6)
                            .background(Circle().fill(Color.primaryTroovColor))
                    }
                }
                HStack {
                    Text(troov.interestedText)
                        .fontWithLineHeight(font: .poppins400(size: 10),
                                            lineHeight: 14)
                        .foregroundStyle(Color.black)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    if hasInterested {
                        ImageCards(cards: troov.interestedInImages,
                                   height: 39)
                        .onTapGesture(perform: { interested(troov) })
                    }
                    Spacer()
                    Button(action: { interested(troov) },
                           label: {
                        YourPickLabel(isActive: hasInterested)
                    }).disabled(!hasInterested)
                }.padding(.leading, 5)
            }
            TimeLocationView(troov: troov)
                .padding(.vertical, 10)
        }
               .padding(.horizontal, 10)
               .background(RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(color: .primaryTroovColor, radius: 0, x: 2, y: 0))
               .frame(maxHeight: 112)
            
    }
}

struct MyPickCell_Previews: PreviewProvider {
    static var previews: some View {
        MyPickCell(troov: .preview) { _ in} editMyTroov: { _ in} interested: {_ in }
    }
}

extension MyPickCell {
    struct YourPickLabel: View {
        var isActive: Bool
    
        private var shape: any Shape {
            isActive ? RoundedRectangle(cornerRadius: 7) : Capsule()
        }
    
        var body: some View {
            HStack(alignment: .center, spacing: 5) {
                Text("Your pick")
                    .fontWithLineHeight(font: .poppins400(size: 12), lineHeight: 18)
                    .fixedSize(horizontal: true, vertical: true)
                Image("t.chat.sign")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 21,
                           height: 12)
            }.foregroundStyle(Color.white)
             .padding(.horizontal, 8)
             .padding(.vertical, 5)
             .background(content: {
                 if isActive {
                     Capsule().fill(Color.primaryTroovColor)
                 } else {
                     RoundedRectangle(cornerRadius: 7).fill(Color.rgba(205, 205, 205, 1))
                 }
             })
        }
    }
}
