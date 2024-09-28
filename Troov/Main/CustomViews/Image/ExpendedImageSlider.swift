//
//  ExpendedImageSlider.swift
//  Troov
//
//  Created by Leo on 01.05.23.
//

import SwiftUI

struct ExpendedImageSlider: View, TPlaceholderable {
    let serverImages: [TServerImage]
    var hideIndicator = false
    
    @State private var imageModel = TImageViewModel()
    @State private var positionId: String? = nil
    @State private var currentPageIndicator = 0
    
    private var tfImages: [TFImage] {
        imageModel.tfImages
    }
    
    var body: some View {
        PageView(pages: tfImages,
                 positionId: $positionId,
                 configuration: sliderConfiguration) { imageItem in
            imageItem.image
                .resizable()
                .scaledToFill()
        }.overlay(alignment: .topLeading, content: {
            TPageControlOverlay(currentIndex: $currentPageIndicator,
                                pageCount: tfImages.count)
        })
        
        .onChange(of: tfImages) { _, newValue in
            if positionId == nil {
                positionId = newValue.first?.id
            }
        }
        .onChange(of: positionId, { _, newValue in
            if let index = tfImages.firstIndex(where: {$0.id == newValue}) {
                currentPageIndicator = index
            }
        })
        .task(priority: .background, {
            imageModel.installServer(images: serverImages)
        })
    }
}

struct ExpendedImageSlider_Previews: PreviewProvider {
    static var previews: some View {
        ExpendedImageSlider(serverImages: [])
    }
}

fileprivate extension ExpendedImageSlider {
    private var sliderConfiguration: PageViewConfiguration {
        PageViewConfiguration(sliderInteritemSpacing: 0,
                              vAlignment: .center,
                              allowScalling: false)
    }
}
