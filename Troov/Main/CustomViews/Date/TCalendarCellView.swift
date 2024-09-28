//
//  TCalendarCellView.swift
//  Troov
//
//  Created by Leo on 14.02.23.
//

import SwiftUI

struct TCalendarCellView: View {
    let troov: Troov
    var hideLocation = false
    var onlyTimeAndLocation = false
    let showLocation: () -> ()
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            HStack(alignment: .center,
                   spacing: 4) {
                Image("t.clock")
                    .renderingMode(.template)
                Text(troov.timeString)
                    .lineLimit(1)
            }.softBackground
            if !onlyTimeAndLocation {
                HStack(alignment: .center,
                       spacing: 4) {
                    Image("t.calendar")
                        .renderingMode(.template)
                    /*
                     https://troov-app.slack.com/archives/C046P1S9JLX/p1726021593556489?thread_ts=1724787885.738229&cid=C046P1S9JLX
                     Wed. Aug 27th
                     */
                    Text("\(troov.getShortWeek) \(troov.monthString) \(troov.getDayFromDateWithSuffixString)")
                        .lineLimit(1)
                }.softBackground
            }
            if !hideLocation, let indicator = troov.locationDetails {
                Button(action: showLocation) {
                    LocationView(indicator: indicator)
                }.buttonStyle(.scalable)
            }
        }.fontWithLineHeight(font: .poppins400(size: 10),
                             lineHeight: 15)
        .foregroundColor(.primaryTroovColor)
    }
}

struct TCalendarCellView_Previews: PreviewProvider {
    static var previews: some View {
        TCalendarCellView(troov:  .preview) {}
    }
}


extension TCalendarCellView {
    struct LocationView: View {
        let indicator: LocationIndicator
    
        var body: some View {
            HStack(alignment: .center,
                   spacing: 4) {
                indicator.pinView
                Text(indicator.placeName)
                    .lineLimit(1)
            }.frame(maxWidth: .infinity)
             .softBackground
             .fontWithLineHeight(font: .poppins400(size: 10),
                                     lineHeight: 15)
            .foregroundStyle(Color.primaryTroovColor)
        }
    }
}
