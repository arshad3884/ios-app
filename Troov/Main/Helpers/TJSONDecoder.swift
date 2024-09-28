//
//  TJSONDecoder.swift
//  mango
//
//  Created by Leo on 13.10.21.
//  Copyright © 2021 Levon Arakelyan. All rights reserved.
//

import Foundation

class TJSONDecoder {
    class func user(from data: Data) -> User? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(User.self, from: data)
        } catch {
            debugPrint(String(describing: error))
        }

        return nil
    }

    class func troovs(from jsonData: Data) -> [Troov]? {
        let decoder = self.decoder
        do {
            return try decoder.decode([Troov].self,
                                      from: jsonData)
        } catch {
            debugPrint(String(describing: error))
        }

        return nil
    }

    class func activityIdeas(from jsonData: Data) throws -> [TActivityIdea] {
        let ideas = try decoder.decode(TActivityIdeas.self,
                                  from: jsonData)
        return ideas.map({ TActivityIdea(text: $0) })
    }

    static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            var date: Date? = nil
            for formatter in dateFormatters {
                if let formattedDate = formatter.date(from: dateStr) {
                    date = formattedDate
                    break
                }
            }
            guard let date_ = date else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
            }
            return date_
        })
        return decoder
    }()
}


