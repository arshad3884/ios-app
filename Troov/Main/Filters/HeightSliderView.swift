//
//  HeightSliderView.swift
//  Troov
//
//  Created by Levon Arakelyan on 22.01.24.
//

import SwiftUI

struct HeightSliderView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var values = BinarySliderValues(low: 0, high: 0)
    @Binding var minHeight: Int?
    @Binding var maxHeight: Int?

    private var currentValues: [Int] {
        if let minHeight = minHeight,
           let maxHeight = maxHeight {
            return [minHeight, maxHeight]
        }
        return []
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: 42) {
            Button(action: { dismiss() }) {
                Text("Done")
                    .fontWithLineHeight(font: .poppins400(size: 12), lineHeight: 12)
                    .foregroundStyle(Color.primaryTroovColor)
            }.padding(.trailing, 0)
            BinarySlider(suffix: " ft",
                         type: .height,
                         freeze: [.none],
                         hide: [.none],
                         values: $values,
                         currentValues: currentValues)
            .onChange(of: values, { _, newValue in
                minHeight = newValue.low
                maxHeight = newValue.high
            })
        }.padding(.bottom)
            .padding(.top, 10)
            .onAppear {
                if let minHeight = minHeight, let maxHeight = maxHeight {
                    values.low = minHeight
                    values.high = maxHeight
                }
            }
    }

    init(minHeight: Binding<Int?>, maxHeight: Binding<Int?>) {
        BinarySlider.sliderExternalWidth = UIScreen.main.bounds.width - 30
        _minHeight = minHeight
        _maxHeight = maxHeight
    }
}

#Preview {
    HeightSliderView(minHeight: .constant(nil), maxHeight: .constant(nil))
}
