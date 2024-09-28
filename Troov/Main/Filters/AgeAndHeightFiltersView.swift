//
//  AgeAndHeightFiltersView.swift
//  Troov
//
//  Created by Levon Arakelyan on 15.01.24.
//

import SwiftUI

struct AgeAndHeightFiltersView: View {
    @Binding var minAge: Int?
    @Binding var maxAge: Int?

    @Binding var minHeight: Int?
    @Binding var maxHeight: Int?

    @State private var showAgeRange = false
    @State private var showHeightRange = false

    private var ageValue: String {
        if let minAge = minAge, let maxAge = maxAge {
            return "\(minAge) - \(maxAge)"
        }
        return ""
    }

    private var ageInactive: Bool {
        minAge == nil || maxAge == nil
    }
    
    private var heightValue: String {
        if let minHeight = minHeight, let maxHeight = maxHeight {
            return "\(ProfileFilterAttributesMinHeight.heightString(of: Double(minHeight)))ft - \(ProfileFilterAttributesMinHeight.heightString(of: Double(maxHeight)))ft"
        }
        return ""
    }

    private var heightInactive: Bool {
        minHeight == nil || maxHeight == nil
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: 16) {
            Button {
                showAgeRange = true
            } label: {
                TInformativeLabel(title: "Age range",
                                  bodyText: ageValue,
                                  inactive: ageInactive,
                                  erase: eraseAge,
                                  isCleanEnum: false)
            }
            Button {
                showHeightRange = true
            } label: {
                TInformativeLabel(title: "Height range",
                                  bodyText: heightValue,
                                  inactive: heightInactive,
                                  erase: eraseHeight,
                                  isCleanEnum: false)
            }
        }.sheet(isPresented: $showAgeRange) {
            AgeSliderView(minAge: $minAge,
                             maxAge: $maxAge)
                .presentationDetents([.height(144)])
                .presentationCornerRadius(24)
                .presentationDragIndicator(.visible)
        }.sheet(isPresented: $showHeightRange) {
            HeightSliderView(minHeight: $minHeight,
                             maxHeight: $maxHeight)
                .presentationDetents([.height(144)])
                .presentationCornerRadius(24)
                .presentationDragIndicator(.visible)
        }
    }

    private func eraseAge() {
        minAge = nil
        maxAge = nil
    }

    private func eraseHeight() {
        minHeight = nil
        maxHeight = nil
    }
}

#Preview {
    AgeAndHeightFiltersView(minAge: .constant(0), maxAge: .constant(0), minHeight: .constant(0), maxHeight: .constant(0))
}
