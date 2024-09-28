//
//  Bundle+Extensions.swift
//  Troov
//
//  Created by Levon Arakelyan on 15.09.23.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        return decoder(data)
    }

    func decodePropertyList<T: Decodable>(_ resource: String) -> T {
        guard let path = Bundle.main.path(forResource: resource, ofType: "plist"),
              let xmlData = FileManager.default.contents(atPath: path) else {
            fatalError("Failed to locate plsit resource:\(resource) in bundle.")
        }
        
        guard let jsonDict = try? PropertyListSerialization.propertyList(from: xmlData, options: .mutableContainers, format: nil) else {
            fatalError("Failed to propertyList plsit resource:\(resource) in bundle.")
        }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: []) else {
            fatalError("Failed to JSONSerialization plsit resource:\(resource) in bundle.")
        }
        
        if let jsonString = String(data: jsonData, encoding: .utf8),
           let data = jsonString.data(using: .utf8) {
            return decoder(data)
        }

        return decoder(xmlData)
    }

    private func decoder<T: Decodable>(_ data: Data) -> T {
        let decoder = JSONDecoder()
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode")
        }

        return loaded
    }
}
