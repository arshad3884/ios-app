//
//  ProfileAgeEditView.swift
//  Troov
//
//  Created by Levon Arakelyan on 15.01.24.
//

import SwiftUI

struct ProfileAgeEditView: View {
    let initialAge: Int?
    let ageChange: (Double) -> ()
    
    @State private var age = Double(UserProfile.ageRule.minimum!)
    private let minAge: Double = Double(UserProfile.ageRule.minimum!)
    private let maxAge: Double = Double(UserProfile.ageRule.maximum!)
    

    var body: some View {
        VStack {
            Slider(value: $age, in: minAge...maxAge,
                   step: 0.1)
                .tint(.sliderBlue)
                .padding(.top, 26.relative(to: .height))
                .overlay(GeometryReader { gp in
                    Text("\(age, specifier: "%.f")")
                        .fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 14)
                        .foregroundColor(.sliderBlue)
                        .alignmentGuide(HorizontalAlignment.leading) {
                            $0[HorizontalAlignment.leading] - (gp.size.width - $0.width) * (age - minAge) / ( maxAge - minAge)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.padding(.top, 10), alignment: .top)
                .padding(.horizontal, 30)
        }
        .padding(.top, 20)
        .onAppear(perform: setupAge)
        .onChange(of: age) { _, newValue in
            ageChange(newValue)
        }
    }

    private func setupAge() {
        if let age = initialAge {
            self.age = Double(age)
        }
    }
}

#Preview {
    ProfileAgeEditView(initialAge: 0, ageChange: { _ in})
}
