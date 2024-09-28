//
//  TJsonHelper.swift
//  mango
//
//  Created by Leo on 21.05.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import Foundation

class TJsonHelper {
   class func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            } else {
                print("error: local json file for name \(name) doesn't exist.")
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
}
