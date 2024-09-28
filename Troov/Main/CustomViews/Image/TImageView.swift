//
//  TImageView.swift
//  Troov
//
//  Created by Leo on 10.02.23.
//

import SwiftUI

struct TImageView: View, TPlaceholderable {
    var images: [TServerImage]?
    let size: CGSize
    var update: Bool = false

    @State private var imageViewModel = TImageViewModel()
    @State private var fetched = false

    private var image: Image? {
        imageViewModel.tfImages.first?.image
    }

    var body: some View {
        VStack {
            if let image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width,
                           height: size.height)
                    .clipped()
            } else {
                /**
                 We should probably add some placeholder here
                 */
               placeholder
                .frame(width: size.width,
                        height: size.height)
            }
        }.onAppear(perform: appear)
            .onChange(of: update) { _, _ in
                Task {
                    imageViewModel.reloadImages()
                    fetchImages()
                }
            }
    }

    private func appear() {
        Task {
            fetchImages()
        }
    }

    private func fetchImages() {
        guard let images = images else { return }
        imageViewModel.installServer(images: images)
    }
}

struct TImageView_Previews: PreviewProvider {
    static var previews: some View {
        TImageView(images: [.preview],
                   size: .init(width: 300,
                               height: 300*TFImage.scale),
                   update: false)
    }
}
