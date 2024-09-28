//
//  StepView.swift
//  mango
//
//  Created by Leo on 11.01.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct StepView: View {
    var step: Int = 0
    var titles: [String] = ["Personal", "Professional", "Add Images"]

    var body: some View {
            HStack {
                ZStack {
                Circle()
                        .strokeBorder(Color.primaryTroovColor.opacity(step == 0 ? 1.0 : 0.0),
                                      lineWidth: 2.0,
                                      antialiased: true)
                        .frame(width: 12.0,
                               height: 12.0)
                        .background(Color.primaryTroovColor.opacity(step == 0 ? 0.0 : 1.0))
                        .cornerRadius(6)
                    Text(titles[0])
                        .fontWithLineHeight(font: .poppins500(size: 12),
                                            lineHeight: 18)
                        .foregroundColor(Color.primaryTroovColor)
                        .frame(width: 80,
                               alignment: .center)
                        .padding(.top, 50)
                        .multilineTextAlignment(.center)
                        .fixedSize()
                }.frame(width: 12.0)
                Spacer()
                Rectangle()
                    .fill(Color.primaryTroovColor.opacity(step == 0 ? 0.08 : 1.0))
                    .cornerRadius(0.5)
                    .frame(height: 1)
                Spacer()
                ZStack {
                Circle()
                    .strokeBorder(Color.primaryTroovColor.opacity(step >= 1 ? 1.0 : 0.0),
                                  lineWidth: 2.0,
                                  antialiased: true)
                    .background(Color.primaryTroovColor.opacity(step == 1 ? 0.0 : step > 1 ? 1.0 : 0.16))
                    .frame(width: 12.0,
                           height: 12.0)
                    .cornerRadius(6)
                    Text(titles[1])
                        .fontWithLineHeight(font: step < 1 ? .poppins400(size: 12) :.poppins500(size: 12) ,
                                            lineHeight: 18)
                        .foregroundColor(Color.primaryTroovColor.opacity(step >= 1 ? 1.0 : 0.5))
                        .frame(width: 80,
                               alignment: .center)
                        .padding(.top, 50)
                        .multilineTextAlignment(.center)
                        .fixedSize()
                }.frame(width: 12.0)
                Spacer()
                Rectangle()
                    .fill(Color.primaryTroovColor.opacity(step > 1 ? 1.0 : 0.08))
                    .cornerRadius(0.5)
                    .frame(height: 1)
                Spacer()
                ZStack {
                    Circle()
                        .strokeBorder(Color.primaryTroovColor.opacity(step == 2 ? 1.0 : 0.0),
                                      lineWidth: 2.0,
                                      antialiased: true)
                        .background(Color.primaryTroovColor.opacity(step == 2 ? 0.0 : step == 3 ? 1.0 : 0.08))
                        .frame(width: 12.0,
                               height: 12.0)
                        .cornerRadius(6)
                    Text(titles[2])
                        .fontWithLineHeight(font: step < 2 ? .poppins400(size: 12) : .poppins500(size: 12),
                                            lineHeight: 18)
                        .foregroundColor(Color.primaryTroovColor.opacity(step >= 2 ? 1.0 : 0.5))
                        .frame(width: 80,
                               alignment: .center)
                        .padding(.top, 50)
                        .multilineTextAlignment(.center)
                        .fixedSize()
                }.frame(width: 12.0)

            }.padding(.horizontal, 46)
    }
}

struct StepView_Previews: PreviewProvider {
    static var previews: some View {
        StepView(step: 0)
    }
}
