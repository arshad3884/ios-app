//
//  TLocationSearchCell.swift
//  Troov
//
//  Created by Leo on 10.02.23.
//

import SwiftUI

struct TLocationSearchCell: View {
    var location: SelectableLocation
    var isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center) {
                Image("t.map")
                    .renderingMode(.template)
                    .foregroundColor(Color.primaryTroovColor)
                Text(location.location.name ?? "")
                    .font(.headline)
                Spacer()
            }.frame(maxWidth: .infinity)
            HStack {
                VStack(alignment: .leading,
                       spacing: 4) {
                    if let reversedGeoLocation = location.reversedGeoLocation {
                        Text("Address")
                        Text(reversedGeoLocation.formattedAddress)
                            .font(.subheadline)
                            .foregroundColor(Color.black.opacity(0.7))
                        if let areasOfInterest = reversedGeoLocation.areasOfInterest {
                            VStack(alignment: .leading) {
                                Text("Interest areas")
                                HStack(alignment: .center,
                                       spacing: 7) {
                                    ForEach(areasOfInterest, id: \.self) { area in
                                        Text(area)
                                            .bold()
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(Capsule().fill(Color.primaryTroovColor.opacity(0.4)))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
        }
         .frame(maxWidth: .infinity, minHeight: 60)
         .padding()
         .background(RoundedRectangle(cornerRadius: 20).fill(isSelected ? Color.primaryTroovColor.opacity(0.1) : Color.white))
    }
}

struct TLocationSearchCell_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
        TLocationSearchCell(location: .init(location: Location()), isSelected: false)
    }
}
