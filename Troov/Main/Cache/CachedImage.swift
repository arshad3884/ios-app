//
//  CachedImage.swift
//  mango
//
//  Created by Leo on 06.01.22.
//  Copyright © 2022 Levon Arakelyan. All rights reserved.
//

import UIKit

class CachedImage {
    private let cache = LRUCache<String, UIImage>(countLimit: 500)

    func get(simage: TServerImage) -> UIImage? {
        if let cach = cache.value(forKey: simage.id) {
            return cach
        } else {
            if let image = try? imageFromFileSystem(for: simage.id) {
                set(simage: simage, image: image)
                return image
            } else {
                return nil
            }
        }
    }

    func set(simage: TServerImage,
             image: UIImage) {
        cache.setValue(image, forKey: simage.id)
        try? persistImage(image, for: simage.id)
    }

    private func imageFromFileSystem(for path: String) throws -> UIImage? {
        guard let url = fileUrl(for: path) else {
            return nil
        }
        
        let data = try Data(contentsOf: url)
        return UIImage(data: data)
    }

    private func fileUrl(for path: String) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask)
            .first else { return nil }
        return documentsDirectory.appendingPathComponent(path)
    }
    
    private func persistImage(_ image: UIImage, for path: String) throws {
        guard let url = fileUrl(for: path),
              let data = image.jpegData(compressionQuality: 1) else {
            return
        }
        
        try removeDuplicates(url: url)
        try data.write(to: url)
    }

    private func removeDuplicates(url: URL) throws {
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(atPath: url.path)
        }
    }

    func cleanUp() {
        cache.cleanUp()
    }
}

extension CachedImage {
    private static var cachedImage = CachedImage()

    static func shared() -> CachedImage {
        return cachedImage
    }
}
