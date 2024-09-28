//
//  TMediaService.swift
//  Troov
//
//  Created by Levon Arakelyan on 11.07.23.
//

import UIKit

protocol TMediaServiceable {
    func cleanUploadProfilePhotos(_ photos: [TProfileMedia]) async -> Result<MediaUploadResponse, TRequestError>
    func profileMedia(by imageKey: String, userId: String) async -> Result<ProfileMedia, TRequestError>
    func image(by imageKey: String, userId: String) async -> UIImage?
}

struct TMediaService: THTTPClient, THTTPLocalClient, TMediaServiceable {
    
    func cleanUploadProfilePhotos(_ photos: [TProfileMedia]) async -> Result<MediaUploadResponse, TRequestError> {
        return await sendRequest(endpoint: TMediaEndpoint.cleanUploadProfilePhotos(photos), responseModel: MediaUploadResponse.self)
    }

    func profileMedia(by imageKey: String, userId: String) async -> Result<ProfileMedia, TRequestError> {
        return await sendRequest(endpoint: TMediaEndpoint.imageWith(keyId: imageKey,
                                                                    userId: userId),
                                 responseModel: ProfileMedia.self)
    }
    
    func image(by imageKey: String, userId: String) async -> UIImage? {
        
        let profileMediaResult = await self.profileMedia(by: imageKey,
                                                         userId: userId)
        switch profileMediaResult {
        case .success(let profileMedia):
            if let url = profileMedia.mediaUrl {
                let sendImageDataRequestEndpoint = TMediaEndpoint.image(url: url)
                let result = await sendImageDataRequest(endpoint: sendImageDataRequestEndpoint)
                switch result {
                case .success(let data):
                    return UIImage(data: data)
                case .failure(let failure):
                    let errorMessage = "Error retrieving imageId: \(imageKey) from server with user id: \(userId) with message: \(failure.message)"
                    DataDog.log(message: errorMessage,
                                endpoint: sendImageDataRequestEndpoint)
                    return nil
                }
            } else {
                let errorMessage = "Error retrieving imageId: \(imageKey) from server with user id: \(userId) with message: Status code is 200; ProfileMedia mediaUrl is missing"
                DataDog.log(message: errorMessage)
                return nil
            }
        case .failure(let failure):
            let errorMessage = "Error retrieving imageId: \(imageKey) from server with user id: \(userId) with message: \(failure.message)"
            DataDog.log(message: errorMessage)
            return nil
        }
    }
}
