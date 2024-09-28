//
//  TImageViewModel.swift
//  mango
//
//  Created by Leo on 09.07.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

@Observable class TImageViewModel {
    private let cachedImage = CachedImage.shared()
    private let mediaService = TMediaService()

    private let lruCacheImages: LRUCache<String, TFImage> = .init(countLimit: 100)

    var tfImages: [TFImage] = []
    
    private var enironment: TEnvironment {
        get {
            TEnvironment.shared
        }
    }

    private var useLocalImages: Bool {
        get {
            return enironment.scheme == .local || enironment.scheme == .demo
        }
    }

    func installServer(images: [TServerImage]) {
        for simage in images {
            if let cach = imageFromCache(sImage: simage) {
                append(cach, simage: simage)
            } else {
                remoteImage(sImage: simage)
            }
        }
    }
    
    private func imageFromCache(sImage: TServerImage) -> UIImage? {
        if useLocalImages {
            return UIImage(named: sImage.url ?? "")
        }
        
        guard let cacheImage = get(cache: sImage) else {
            return nil
        }
        
        return cacheImage
    }
    
    private func set(cache: UIImage,
                     sImage: TServerImage) {
            cachedImage.set(simage: sImage,
                            image: cache)
    }
    
    private func get(cache: TServerImage) -> UIImage? {
        cachedImage.get(simage: cache)
    }
    
    /// Combine download
    private func remoteImage(sImage: TServerImage) {
        Task {
            guard let image = await mediaService.image(by: sImage.id,
                                                       userId: sImage.userId) else { return }
            append(image, simage: sImage)
        }
    }
    
    private func append(_ image: UIImage,
                                   simage: TServerImage) {
        let tfImage = TFImage(id: simage.id,
                              url: simage.id,
                              image: Image(uiImage: image),
                              uiImage: image,
                              rank: simage.rank)
        set(cache: image, sImage: simage)
        lruCacheImages.setValue(tfImage, forKey: tfImage.id)
        if Thread.isMainThread {
            tfImages = lruCacheImages.allValues
        } else {
            DispatchQueue.main.async {
                self.tfImages = self.lruCacheImages.allValues
            }
        }
    }

    func reloadImages() {
        lruCacheImages.cleanUp()
        if Thread.isMainThread {
            tfImages = []
        } else {
            DispatchQueue.main.async {
                self.tfImages = []
            }
        }
    }
}

/**
 Reference for future possible improvements
 https://www.donnywals.com/using-swifts-async-await-to-build-an-image-loader/
 https://medium.com/@mshcheglov/reusable-image-cache-in-swift-9b90eb338e8d
 https://rinradaswift.medium.com/a-simple-lru-cache-implementation-in-swift-5-d3df244a8d02
 */
