//
//  DistanceView.swift
//  Troov
//
//  Created by Levon Arakelyan on 26.09.23.
//

import SwiftUI

struct DistanceView: View {
    @Environment(\.dismiss) var dismiss
    var initialDistance: TroovCoreDetailFilterAttributesMaximumDistance?
    var complation: (TroovCoreDetailFilterAttributesMaximumDistance) -> ()
    
    @State private var distance: Double = Double(TroovCoreDetailFilterAttributesMaximumDistance.allowedSliderMax)
    private let minSliderDistance: Double = 1.0
    private let maxDistance: Double = Double(TroovCoreDetailFilterAttributesMaximumDistance.allowedSliderMax)
    
    private var filteredDistance: String {
        if Int(distance) >= TroovCoreDetailFilterAttributesMaximumDistance.allowedSliderMax - 1 {
            return "\(TroovCoreDetailFilterAttributesMaximumDistance.allowedSliderMax - 1)+"
        }
        return String(format: "%.f", distance)
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            Button(action: { dismiss() }) {
                Text("Done")
                    .fontWithLineHeight(font: .poppins400(size: 12), lineHeight: 12)
                    .foregroundStyle(Color.primaryTroovColor)
            }.padding(.trailing, 10)
            Slider(value: $distance, in: minSliderDistance...maxDistance,
                   step: 1)
                .tint(.sliderBlue)
                .padding(.top, 26.relative(to: .height))
                .overlay(GeometryReader { gp in
                    Text(filteredDistance)
                        .fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 14)
                        .foregroundColor(.sliderBlue)
                        .alignmentGuide(HorizontalAlignment.leading) {
                            $0[HorizontalAlignment.leading] - (gp.size.width - $0.width) * (distance - minSliderDistance) / ( maxDistance - minSliderDistance)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.padding(.top, 10), alignment: .top)
        }
            .padding(16)
            .onAppear {
                if var length = initialDistance?.length {
                    if length > Double(TroovCoreDetailFilterAttributesMaximumDistance.allowedSliderMax) {
                        length = Double(TroovCoreDetailFilterAttributesMaximumDistance.allowedSliderMax)
                    }
                    distance = length
                }
            }.onDisappear {
                change(distance)
            }
    }

    private func change(_ distance: Double) {
        var distance: Int = Int(distance)
        let allowedSliderMax = TroovCoreDetailFilterAttributesMaximumDistance.allowedSliderMax - 1
    
        if distance >= allowedSliderMax {
            distance = TroovCoreDetailFilterAttributesMaximumDistance.allowedLocalMax
        }
    
        let filterDistance = TroovCoreDetailFilterAttributesMaximumDistance(length: Double(distance),
                                                                      unit: .mile)
        complation(filterDistance)
    }
}

#Preview {
    DistanceView(initialDistance: .init()) { _ in }
}
