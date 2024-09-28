//
//  MessageNavigationView.swift
//  mango
//
//  Created by Leo on 25.03.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct MessageNavigationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showCurrentTroov = false
    @Environment(DiscoverViewModel.self) var discoverViewModel

    var troov: Troov?
    var image: TServerImage?
    var title: String?
    
    private var images: [TServerImage] {
        if let image = image {
            return [image]
        }
        return []
    }

    var body: some View {
        HStack(alignment: .center,
               spacing: 0) {
            Button(action: {
                dismiss()
            },
                   label: {
                Image("t.arrow.narrow.left")
                    .foregroundColor(.primaryBlack)
                    .enlargeTapAreaForTopLeadingButton
            })
            .padding(.leading, 16.relative(to: .height))
            TImageView(images: images,
                       size: .init(width: 50,
                                   height: 50))
            .clipShape(Circle())
            .padding(.leading, 8)
            VStack(alignment: .leading, spacing: 0) {
                Text(title ?? "")
                    .fontWithLineHeight(font: .poppins700(size: 14),
                                        lineHeight: 26)
                    .foregroundColor(.rgba(34, 34, 34, 1))
                if let troov = troov {
                    Button(action: selectTroov) {
                        TinyBorderedLabel(text: troov.title)
                    }.buttonStyle(.scalable)
                }
            }.padding(.leading, 16.relative(to: .height))
            Spacer()
            Menu {
                Button {
                } label: {
                    Text("Block User")
                }
                Button {
                } label: {
                    Text("Report User")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(Color.rgba(34, 34, 34, 1))
                    .rotationEffect(.degrees(-90))
            }.padding(.trailing, 16.relative(to: .height))
        }
            .frame(height: .navigationBarHeight,
                   alignment: .bottomLeading)
            .frame(maxWidth: .infinity)
            .zIndex(1)
            .padding(.bottom, 16)
            .overlay(alignment: .bottom) {
                Color.rgba(247, 247, 247, 1)
                    .frame(height: 2)
            }
            .navigationDestination(isPresented: $showCurrentTroov) {
                if let currentTroov = troov {
                    TroovDetailsContainerView(troov: currentTroov)
                    .environment(discoverViewModel)
                }
            }
    }

    private func selectTroov() {
        showCurrentTroov = true
    }
}

struct MessageNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        MessageNavigationView(troov: .preview)
    }
}
