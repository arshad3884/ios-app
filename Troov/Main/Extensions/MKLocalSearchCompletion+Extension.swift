//
//  MKLocalSearchCompletion+Extension.swift
//  Troov
//
//  Created by Leo on 10.02.23.
//

import Foundation
import MapKit

extension MKLocalSearchCompletion {
    var highlightedTitle: AttributedString {
        title.highlighted(inRanges: titleHighlightRanges,
                          fontSize: 16)
    }

    var highlightedSubtitle: AttributedString {
        subtitle.highlighted(inRanges: subtitleHighlightRanges,
                             fontSize: 13)
    }
}
