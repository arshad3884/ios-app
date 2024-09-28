//
//  TLocationSerchPreliminaryCell.swift
//  Troov
//
//  Created by Leo on 10.02.23.
//

import SwiftUI
import MapKit

struct TLocationSerchPreliminaryCell: View {
    var searchCompletion: MKLocalSearchCompletion

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "mappin")
                .foregroundColor(Color.black.opacity(0.7))
            VStack(alignment: .leading, spacing: 4) {
                Text(searchCompletion.highlightedTitle)
                    .fontWithLineHeight(font: .poppins500(size: 11), lineHeight: 11)
                Text(searchCompletion.highlightedSubtitle)
                    .fontWithLineHeight(font: .poppins600(size: 9), lineHeight: 11)
                    .foregroundColor(Color.black.opacity(0.7))
            }
            Spacer()
        }.frame(maxWidth: .infinity, minHeight: 60)
    }
}

struct TLocationSerchPreliminaryCell_Previews: PreviewProvider {
    static var previews: some View {
        TLocationSerchPreliminaryCell(searchCompletion: MKLocalSearchCompletion())
    }
}

