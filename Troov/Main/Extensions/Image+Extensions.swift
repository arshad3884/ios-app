//
//  Image+Extensions.swift
//  Troov
//
//  Created by Levon Arakelyan on 29.07.23.
//

import UIKit

extension UIImage {
    func croppedImage(inRect rect: CGRect) -> UIImage? {
        let rad: (Double) -> CGFloat = { deg in
            return CGFloat(deg / 180.0 * .pi)
        }
        
        var rectTransform: CGAffineTransform
        switch imageOrientation {
        case .left:
            let rotation = CGAffineTransform(rotationAngle: rad(90))
            rectTransform = rotation.translatedBy(x: 0, y: -size.height)
        case .right:
            let rotation = CGAffineTransform(rotationAngle: rad(-90))
            rectTransform = rotation.translatedBy(x: -size.width, y: 0)
        case .down:
            let rotation = CGAffineTransform(rotationAngle: rad(-180))
            rectTransform = rotation.translatedBy(x: -size.width, y: -size.height)
        default:
            rectTransform = .identity
        }
        let transformedRect = rect.applying(rectTransform)
        
        guard let imageRef = cgImage?.cropping(to: transformedRect) else { return nil }
        let result = UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
        return result
    }
 
    func checkAndCrop() -> UIImage? {
        let fixedImage = fixImageOrientation
        let size = fixedImage.size
        let aspectRatio = TFImage.reverseScale
        
        let roundedOriginalAspect = Double(round((size.width/size.height) * 100) / 100)
        let roundedAspect = Double(round(aspectRatio * 100) / 100)

        if roundedOriginalAspect == roundedAspect {
            return fixedImage
        }

        ///aspectRatio
        let imageOriginalRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        let height: CGFloat!
        let width: CGFloat!

        if imageOriginalRect.width >= imageOriginalRect.height {
            height = imageOriginalRect.height
            width = height*aspectRatio
        } else {
            if imageOriginalRect.width/aspectRatio >= imageOriginalRect.height {
                height = imageOriginalRect.height
                width = height*aspectRatio
            } else {
                width = imageOriginalRect.width
                height = width/aspectRatio
            }
        }
        
        let cropRect =  CGRect(x: abs(imageOriginalRect.width - width)/2,
                               y: abs(imageOriginalRect.height - height)/2,
                               width: width, height: height)
        let croppedImage = fixedImage.croppedImage(inRect: cropRect)
        return croppedImage
    }

    func resizeByByte(maxByte: Int) -> Data {
        var compressQuality: CGFloat = 1
        var imageData = Data()
        var imageByte = self.jpegData(compressionQuality: 1)?.count
        while imageByte! > maxByte {
            imageData = self.jpegData(compressionQuality: compressQuality)!
            imageByte = self.jpegData(compressionQuality: compressQuality)?.count
            compressQuality -= 0.1
        }
        
        let fullQuality = self.jpegData(compressionQuality: 1)!

        if maxByte > imageByte! {
            if imageData.count == 0 {
               return fullQuality
            }
            return imageData
        } else {
            return fullQuality
        }
    }

    var fixImageOrientation: UIImage {
        if self.imageOrientation == .up {
            // The image is already correctly oriented, no need to fix it
            return self
        }

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: self.size))
        let fixedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let resultImage = fixedImage {
            return resultImage
        } else {
            // Return the original image if there's an issue
            return self
        }
    }

}
