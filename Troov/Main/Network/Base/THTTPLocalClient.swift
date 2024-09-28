//
//  THTTPLocalClient.swift
//  Troov
//
//  Created by Leo on 23.01.23.
//

import Foundation

protocol THTTPLocalClient {
    var bundle: Bundle { get }
    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> T
}

extension THTTPLocalClient {
    var bundle: Bundle {
        return Bundle.main
    }

    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> T {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to load JSON")
        }

        do {
            let data = try Data(contentsOf: path)
            let decoder = TJSONDecoder.decoder
            return try decoder.decode(type, from: data)
        } catch {
            fatalError(String(describing: error))
        }
    }
}
