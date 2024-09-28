//
//  GradientToggleStyle.swift
//  Troov
//
//  Created by Levon Arakelyan on 18.09.23.
//

import SwiftUI

struct GradientToggleStyle: ToggleStyle {

    private var gradient: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 0.04, green: 0.01, blue: 0.5), location: 0.00),
                Gradient.Stop(color: Color(red: 0.24, green: 0.29, blue: 0.85), location: 0.36),
                Gradient.Stop(color: Color(red: 0, green: 0.64, blue: 1), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.2, y: 0.08),
            endPoint: UnitPoint(x: 0.78, y: 0.91)
        )
    }

    private var whiteGradient: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: .white, location: 0.00),
                Gradient.Stop(color: .white, location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.2, y: 0.08),
            endPoint: UnitPoint(x: 0.78, y: 0.91)
        )
    }

    private func primaryFillGradient(isOn: Bool) -> LinearGradient {
        if isOn {
           return gradient
        } else {
            return whiteGradient
        }
    }

    private let height: Double = 19.relative(to: .height)
    
    func makeBody(configuration: ToggleStyle.Configuration) -> some View {
        primaryFillGradient(isOn: configuration.isOn)
            .cornerRadius(height/2)
            .frame(width: 34.relative(to: .width),
                   height: height, alignment: .center)
            .overlay(content: {
                if !configuration.isOn {
                    RoundedRectangle(cornerRadius: height/2)
                        .stroke(gradient)
                        .padding(1)
                }
            })
            .overlay(alignment: configuration.isOn ? .trailing : .leading,
                     content: {
                Circle()
                    .fill(configuration.isOn ? whiteGradient : gradient)
                    .padding(.all, 3)
            })
            .animation(.spring(), value: configuration.isOn)
            .onTapGesture { configuration.isOn.toggle() }
    }
}

struct GradientToggleStyle_Previews: PreviewProvider {

    static var previews: some View {
        @State var toggle = true

        Toggle("", isOn: $toggle)
            .toggleStyle(.gradient)
    }
}

extension ToggleStyle where Self == GradientToggleStyle {
    static var gradient: GradientToggleStyle { .init() }
}
