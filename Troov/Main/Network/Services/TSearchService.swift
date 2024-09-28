//
//  TSearchService.swift
//  Troov
//
//  Created by Levon Arakelyan on 22.01.24.
//

import Foundation

protocol TSearchServiceable {
    func mostPopularTags(count: Int) async -> Result<[SearchTag], TRequestError>
    func activeTags() async -> Result<[String], TRequestError>
    func searchByTerm(term: String, latitude: Double, longitude: Double, radius: Double) async -> Result<[FailableDecodable<Troov>], TRequestError>
}

struct TSearchService: THTTPClient, THTTPLocalClient, TSearchServiceable {
    func mostPopularTags(count: Int) async -> Result<[SearchTag], TRequestError> {
        return await sendRequest(endpoint: TSearchEndpoint.mostPopularTags(count: count), responseModel: [SearchTag].self)
    }

    func activeTags() async -> Result<[String], TRequestError> {
        return await sendRequest(endpoint: TSearchEndpoint.activeTags, responseModel: [String].self)
    }
    
    func searchByTerm(term: String, latitude: Double, longitude: Double, radius: Double) async -> Result<[FailableDecodable<Troov>], TRequestError> {
        return await sendRequest(endpoint: TSearchEndpoint.searchByTerm(term: term, latitude: latitude, longitude: longitude, radius: radius), responseModel: [FailableDecodable<Troov>].self)
    }
}
