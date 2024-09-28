//
//  TMediaEndpoint.swift
//  Troov
//
//  Created by Levon Arakelyan on 11.07.23.
//

import UIKit

enum TMediaEndpoint {
    case cleanUploadProfilePhotos([TProfileMedia])
    case imageWith(keyId: String, userId: String)
    case image(url: String)
}

extension TMediaEndpoint: TEndpoint {
    var name: String? {
        return "image"
    }
    
    var description: String? {
        return "Operations for managing images"
    }
    
    var path: String {
        switch self {
        case .cleanUploadProfilePhotos:
            return "/v1/image/cleanUpload/profilePhotos/\(userId)"
        case .imageWith(let keyId, let userId):
            return "/v1/image/downloadUrl/\(userId)/\(keyId)"
        case .image(let url):
            return url
        }
    }
    
    var method: THTTPMethod? {
        switch self {
        case .cleanUploadProfilePhotos:
            return .post
        case .imageWith:
            return .get
        case .image:
            return nil
        }
    }
    
    var header: [String: String]? {
        get async {
            switch self {
            case .cleanUploadProfilePhotos:
                let boundry = self.boundary
                return [
                    "Authorization": "Bearer \(await token)",
                    "Content-Type": "multipart/form-data; boundary=\(boundry)"
                ]
            case .imageWith:
                return [
                    "Authorization": "Bearer \(await token)",
                    "Content-Type": "application/json;charset=utf-8",
                ]
            case .image:
                return nil
            }
        }
    }
    
    var boundary: String {
        switch self {
        case .cleanUploadProfilePhotos(let photos):
            return "Boundary-\(photos.first!.id)"
        case .imageWith, .image:
            return ""
        }
    }
    
    var body: TEndpointBody? {
        switch self {
        case .cleanUploadProfilePhotos(let photos):
            return .form(createDataBodyMultiple(media: photos))
        case .imageWith, .image:
            return nil
        }
    }
        
    private func createDataBody(media: TProfileMedia) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        if let mediaData = media.data {
            body.appendString("--\(boundary + lineBreak)")
            body.appendString("Content-Disposition:form-data; name=\"profilePhoto\"")
            body.appendString("; filename=\"\(media.id)\"\r\n" + "Content-Type: \"content-type header\"\(lineBreak + lineBreak)")
            body.append(mediaData)
            body.appendString(lineBreak)
            body.appendString("--\(boundary + lineBreak)")
            body.appendString("Content-Disposition:form-data; name=\"profilePhotoRank\"")
            body.appendString("\(lineBreak + lineBreak)\("\(media.rank ?? 0)")\(lineBreak)")
            body.appendString("--\(boundary)--\(lineBreak)")
        }
        return body
    }
    
    private func createDataBodyMultiple(media: [TProfileMedia]) -> Data? {
        let lineBreak = "\r\n"
        var body = Data()
        let boundary = self.boundary
        for mediaItem in media {
            if let mediaData = mediaItem.data {
                body.appendString("--\(boundary + lineBreak)")
                body.appendString("Content-Disposition:form-data; name=\"profilePhotos\"")
                body.appendString("; filename=\"\(mediaItem.id)\"\r\n" + "Content-Type: \"content-type header\"\(lineBreak + lineBreak)")
                body.append(mediaData)
                body.appendString(lineBreak)
            }
        }

        for mediaItem in media {
            if let rank = mediaItem.rank {
                body.appendString("--\(boundary + lineBreak)")
                body.appendString("Content-Disposition:form-data; name=\"profilePhotosRanks\"")
                body.appendString("\(lineBreak + lineBreak)\("\(rank)")\(lineBreak)")
            }
        }

        body.appendString("--\(boundary)--\(lineBreak)")
        return body
    }

}
