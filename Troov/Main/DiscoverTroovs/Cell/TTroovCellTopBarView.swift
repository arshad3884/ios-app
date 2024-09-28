//
//  TTroovCellTopBarView.swift
//  Troov
//
//  Created by Levon Arakelyan on 01.09.23.
//

import SwiftUI

struct TTroovCellTopBarView: View {
    let etroovTitle: String
    var body: some View {
        HStack(alignment: .center,
               spacing: 10) {
            Image("t.light.bulb.flash")
            Text(etroovTitle)
                .fontWithLineHeight(font: .poppins500(size: 16),
                                    lineHeight: 16)
                .padding(.trailing, 10)
            Spacer()
        }.frame(maxWidth: .infinity)
         .padding(.top, 3)
    }
}

struct TTroovCellTopBarView_Previews: PreviewProvider {
    static var previews: some View {
        TTroovCellTopBarView(etroovTitle: "Troov")
    }
}
