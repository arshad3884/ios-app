//
//  ImagePresenterView.swift
//  Troov
//
//  Created by Levon Arakelyan on 10.02.24.
//

import SwiftUI

struct ImagePresenterView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var imageViewModel = TImageViewModel()
    @State private var currentImage: TFImage?

    let images: [TServerImage]

    private var fetchedImages: [TFImage] {
        imageViewModel.tfImages
    }
    
    private var selectedImage: TFImage? {
        if let currentImage = currentImage {
            return currentImage
        }

        return imageViewModel.tfImages.first
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                Spacer()
                Button(action: { dismiss() }, label: {
                    Image("t.xmark")
                        .renderingMode(.template)
                        .foregroundStyle(Color.white)
                }).buttonStyle(.scalable)
            }
            .padding(.top, 40)
            .padding(.trailing, 20)
            VStack(alignment: .center, spacing: 26) {
                if let selectedImage = selectedImage {
                    Rectangle()
                        .fill(Color.black.opacity(0.7))
                        .frame(maxWidth: .infinity,
                               maxHeight: .infinity)
                        .overlay {
                            selectedImage
                                .image
                                .resizable()
                                .frame(maxWidth: .infinity,
                                       maxHeight: .infinity)
                                .aspectRatio(TFImage.reverseScale, contentMode: .fill)
                                .pinchToZoom()
                        }
                }
                if fetchedImages.count > 1 {
                    HStack(alignment: .center,
                           spacing: 8) {
                        Spacer()
                        ForEach(fetchedImages, id: \.id) { image in
                            image
                                .image
                                .resizable()
                                .aspectRatio(TFImage.reverseScale, contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .frame(height: 65)
                                .overlay {
                                    if currentImage?.id == image.id {
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.white, lineWidth: 2)
                                    }
                                }.onTapGesture {
                                    currentImage = image
                                }
                        }
                        Spacer()
                    }
                }
            }
            .padding(.vertical, 27)
        }.onAppear(perform: appear)
    }

    private func appear() {
        imageViewModel.installServer(images: images)
        currentImage = imageViewModel.tfImages.first
    }
}

#Preview {
    ImagePresenterView(images: [.preview, .preview])
}
