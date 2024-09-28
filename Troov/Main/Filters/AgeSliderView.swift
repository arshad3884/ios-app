//
//  AgeSliderView.swift
//  Troov
//
//  Created by Levon Arakelyan on 15.01.24.
//

import SwiftUI

struct AgeSliderView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var values = BinarySliderValues(low: 0, high: 0)
    @Binding var minAge: Int?
    @Binding var maxAge: Int?

    private var currentValues: [Int] {
        if let minAge = minAge,
           let maxAge = maxAge {
            return [minAge, maxAge]
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
            BinarySlider(suffix: "",
                         type: .age,
                         freeze: [.none],
                         hide: [.none],
                         values: $values,
                         currentValues: currentValues)
            .onChange(of: values, { _, newValue in
                    minAge = newValue.low
                    maxAge = newValue.high
            })
        }.padding(.bottom)
            .padding(.top, 10)
            .onAppear {
                if let minAge = minAge, let maxAge = maxAge {
                    values.low = minAge
                    values.high = maxAge
                }
            }
    }

    init(minAge: Binding<Int?>, maxAge: Binding<Int?>) {
        BinarySlider.sliderExternalWidth = UIScreen.main.bounds.width - 30
        _minAge = minAge
        _maxAge = maxAge
    }
}

#Preview {
    AgeSliderView(minAge: .constant(nil), maxAge: .constant(nil))
}
