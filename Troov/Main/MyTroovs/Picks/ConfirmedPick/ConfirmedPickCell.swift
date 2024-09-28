//
//  ConfirmedPickCell.swift
//  mango
//
//  Created by Leo on 17.03.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct ConfirmedPickCell: View {
    let troov: Troov
    let removeConfirmed: (Troov) -> ()
    let showEventCalled: (Troov) -> ()
    let selectTroov: (Troov) -> ()
    let chat: (Troov) -> ()

    private var images: [TServerImage] {
        troov.confirmedTroovServerImages ?? []
    }

    var body: some View {
        HStack(alignment: .bottom,
               spacing: 18) {
            VStack(alignment: .center,
                   spacing: 8) {
                TImageView(images: images,
                           size: .init(width: 50,
                                       height: 50))
                .clipShape(Circle())
                .onTapGesture(perform: { selectTroov(troov) })
                Spacer()
                Button(action: { chat(troov) }) {
                    Image("t.toolbar.chat")
                        .renderingMode(.template)
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 5.5)
                        .background(Capsule().fill(Color.primaryTroovColor))
                }.buttonStyle(.scalable)
            }.padding(.vertical, 10)
            VStack(alignment: .leading,
                   spacing: 4) {
                HStack {
                    Text(troov.confirmedTroovFirstName)
                        .fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 21)
                        .foregroundStyle(Color.rgba(51, 51, 51, 1))
                        .onTapGesture(perform: { selectTroov(troov) })
                    Spacer()
                    Menu {
                        Button(role: .destructive) {
                            remove()
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
                Text(troov.title)
                    .fontWithLineHeight(font: .poppins400(size: 12), lineHeight: 18)
                    .foregroundStyle(Color.rgba(51, 51, 51, 1))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .onTapGesture(perform: { selectTroov(troov) })
                Spacer()
                HStack(alignment: .center, spacing: 6) {
                    HStack(spacing: 7) {
                        Text("Confirmed")
                            .fontWithLineHeight(font: .poppins400(size: 12), lineHeight: 18)
                            .frame(maxWidth: .infinity)
                            .minimumScaleFactor(0.6)
                            .lineLimit(1)
                            .fixedSize(horizontal: false, vertical: true)
                        Image("t.checkmark")
                            .renderingMode(.template)
                    }
                    .foregroundStyle(Color.primaryTroovColor)
                    .padding(.vertical, 4.5)
                    .softBackground
                    Button(action: calendar, label: {
                        Image("t.calendar")
                            .renderingMode(.template)
                            .foregroundStyle(Color.white)
                            .minimumScaleFactor(0.6)
                            .padding(.horizontal, 15.5)
                            .padding(.vertical, 4.5)
                            .background(Color.primaryTroovColor)
                            .clipShape(Capsule())
                    })
                }
            }.padding(.vertical, 10)
            TimeLocationView(troov: troov)
                .padding(.bottom, 10)
        }.padding(.horizontal, 10)
         .background(RoundedRectangle(cornerRadius: 8)
                .fill(Color.white))
         .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.primaryTroovColor, lineWidth: 1.0)
         }.frame(maxHeight: 122)
    }

    private func calendar() {
        showEventCalled(troov)
    }
    
    private func remove() {
        removeConfirmed(troov)
    }
}

#Preview {
    ZStack {
        Color.orange.opacity(0.5)
            .ignoresSafeArea()
        ConfirmedPickCell(troov: .preview, removeConfirmed: {_ in}, showEventCalled: {_ in}, selectTroov: { _ in}, chat: {_ in})
    }
}
