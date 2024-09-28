//
//  ProfileFilterAttributesHeightView.swift
//  Troov
//
//  Created by  Levon Arakelyan on 19.09.2023.
//

import SwiftUI

struct ProfileFilterAttributesHeightView: View {
    let initialHeight: Int?
    let heightChange: (Double) -> ()
    @State private var height = ProfileFilterAttributesMinHeight.medium
    private let minHeight = ProfileFilterAttributesMinHeight.min
    private let maxHeight = ProfileFilterAttributesMinHeight.max

    var body: some View {
        VStack {
            Slider(value: $height, in: minHeight...maxHeight,
                   step: 0.1)
                .tint(.sliderBlue)
                .padding(.top, 26.relative(to: .height))
                .overlay(GeometryReader { gp in
                    Text("\(ProfileFilterAttributesMinHeight.heightString(of: height)) ft")
                        .foregroundColor(.sliderBlue)
                        .fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 14)
                        .foregroundColor(.sliderBlue)
                        .alignmentGuide(HorizontalAlignment.leading) {
                            $0[HorizontalAlignment.leading] - (gp.size.width - $0.width) * (height - minHeight) / ( maxHeight - minHeight)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                })
                .padding(.horizontal, 30)
        }
        .padding(.top, 20)
        .onAppear(perform: setupHeight)
        .onChange(of: height) { _, newValue in
            heightChange(newValue)
        }
    }

    private func setupHeight() {
        if let height = initialHeight {
            self.height = Double(height)
        }
    }
}


#Preview {
    ProfileFilterAttributesHeightView(initialHeight: nil,
                                      heightChange: { _ in})
}
