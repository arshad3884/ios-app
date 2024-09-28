//
//  TroovDetailsDatePlaceView.swift
//  Troov
//
//  Created by Levon Arakelyan on 09.10.23.
//

import SwiftUI

struct TroovDetailsDatePlaceView: View {
    let troov: Troov

    var body: some View {
        HStack(alignment: .center,
               spacing: 0) {
            DateView(troov: troov)
            Spacer()
            TroovPriceTierView(tier: troov.troovCoreDetails?.expenseRating)
                .frame(maxWidth: .infinity)
            Spacer()
            LocationView(troov: troov)
        }
    }
}

#Preview {
    TroovDetailsDatePlaceView(troov: .init())
}

extension TroovDetailsDatePlaceView {
    struct DateView: View {
        let troov: Troov

        private var date: String {
            "\(troov.weekString), \(troov.monthString) \(troov.getDayFromDateWithSuffixString)"
        }
        
        var body: some View {
            VStack(alignment: .center,
                   spacing: 3) {
                Image("t.calendar.colored")
                Text("\(troov.timeString)\n\(date)")
                    .lineLimit(nil)
                    .fontWithLineHeight(font: .poppins500(size: 10), lineHeight: 10)
                    .foregroundStyle(Color.primaryTroovColor)
                    .multilineTextAlignment(.center)
            }.frame(minWidth: 10, maxWidth: 110, alignment: .leading)
        }
    }

    struct LocationView: View {
        let troov: Troov

        var body: some View {
            if let indicator = troov.locationDetails {
                VStack(alignment: .center,
                       spacing: 3) {
                    indicator.pinView
                    Text(indicator.placeName)
                        .lineLimit(nil)
                        .fontWithLineHeight(font: .poppins500(size: 10), lineHeight: 12)
                        .foregroundStyle(Color.primaryTroovColor)
                        .multilineTextAlignment(.center)
                }.frame(minWidth: 10, maxWidth: 110, alignment: .trailing)
            }
        }
    }
}
