//
//  TTabBarShape.swift
//  Troov
//
//  Created by Levon Arakelyan on 30.08.23.
//

import SwiftUI

struct TTabBarShape: Shape {
    var Xa: CGFloat = 120
    var deep: CGFloat = 70

    private let Yc: CGFloat = 12

    private let XaAngle: CGFloat = 10

    private var Xb: CGFloat {
        Xa + 25
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: Xa, y: rect.minY))
            path.addQuadCurve(to: CGPoint(x: Xb,
                                          y: Yc),
                              control: CGPoint(x: Xb - XaAngle,
                                               y: 0))
            path.addQuadCurve(to: CGPoint(x: rect.maxX - Xb,
                                          y: rect.minY + Yc),
                              control: CGPoint(x: rect.maxX/2, y: deep))

            path.addQuadCurve(to: CGPoint(x: rect.maxX - Xa,
                                          y: rect.minY),
                              control: CGPoint(x: rect.maxX - Xb + XaAngle,
                                               y: 0))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))

            path.closeSubpath()
        }
    }
}



struct TTabBarShape_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            ZStack {
                Color.white
                VStack {
                    Spacer()
                    TTabBarShape()
                        .foregroundStyle(Color.black)
                        .frame(height: proxy.size.height/8)
                }
            }.edgesIgnoringSafeArea(.all)
        }
    }
}
