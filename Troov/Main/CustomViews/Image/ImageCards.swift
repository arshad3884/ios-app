//
//  ImageCards.swift
//  mango
//
//  Created by Leo on 15.03.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct ImageCards: View, TPlaceholderable {
    var cards: [TServerImage]
    var padding: CGFloat = -14
    var height: CGFloat
    private let maxLimit = 3

    @State private var imageViewModel = TImageViewModel()
    @State private var loaded = false
    
    private var images: [TFImage] {
        imageViewModel.tfImages
    }

    private var filteredImages: ArraySlice<TFImage> {
        images.prefix(maxLimit)
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center,
                   spacing: padding) {
                if images.count > 0 {
                    ForEach(filteredImages.indices, id: \.self) { index in
                            images[index]
                                .image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: height,
                                       height: height)
                                .clipShape(RoundedRectangle(cornerRadius: height/2))
                                .overlay {
                                    RoundedRectangle(cornerRadius: height/2)
                                        .stroke(Color.white, lineWidth: 2)
                                }
                                .overlay(content: {
                                    if images.count > maxLimit && index == maxLimit - 1 {
                                        ZStack {
                                            Color.primaryTroovColor.opacity(0.7)
                                                .cornerRadius(height/2)
                                            Text("+\(images.count - maxLimit)")
                                                .fontWithLineHeight(font: .poppins500(size: 16),
                                                                    lineHeight: 24)
                                                .foregroundColor(.white)
                                        }
                                    }
                                })
                                .zIndex(Double(images.count - index))
                    }
                } else {
                    placeholder
                        .frame(width: height,
                               height: height)
                        .cornerRadius(height)
                        .clipped()
                }
                Spacer()
            }
        }.frame(height: height)
         .task {
            guard !loaded else { return }
            loaded = true
            imageViewModel.installServer(images: cards)
        }
    }
}

struct ImageCards_Previews: PreviewProvider {
    static var previews: some View {
        ImageCards(cards: [.preview,
                           .preview,
                           .preview],
                   height: 64)
    }
}
