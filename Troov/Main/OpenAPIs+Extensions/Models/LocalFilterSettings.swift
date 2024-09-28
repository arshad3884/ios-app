//
//  LocalFilterSettings.swift
//  Troov
//
//  Created by Levon Arakelyan on 27.12.23.
//

import Foundation

typealias LocalFilterSettings = Compose<FilterSettingsExtension, DiscoverFilterSettings>

struct FilterSettingsExtension {
    var locationName: String?
}
