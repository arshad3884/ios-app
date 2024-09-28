//
//  RegistrationTopBarView.swift
//  Troov
//
//  Created by Leo on 30.08.2023.
//

import SwiftUI

struct RegistrationTopBarView: View {
    let step: RegistrationStep

    private var indicatorCount: Int {
        step.progressIndicatorsCount
    }
    
    private var showProgressInicator: Bool {
        indicatorCount > 0
    }
    
    var body: some View {
        VStack(alignment: .center,
               spacing: 0) {
            if step != .activityInterests {
                Image(step.image)
                    .animation(.none, value: step)
                Text(step.title)
                    .foregroundColor(.primaryBlack)
                    .fontWithLineHeight(font: .poppins600(size: 20), lineHeight: 20)
                    .padding(.top, 18.relative(to: .height))
            }
            if showProgressInicator {
                TProgress.LinerDotted(configuration: .init(count: indicatorCount),
                                      current: step.index)
                .padding(.top, 18.relative(to: .height))
            }
        }.padding(.horizontal, 30.relative(to: .width))
    }
}
struct RegistrationTopBarView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationTopBarView(step: .phoneNumber)
    }
}
