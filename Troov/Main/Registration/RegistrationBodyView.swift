//
//  RegistrationBodyView.swift
//  Troov
//
//  Created by Leo on 01.09.2023.
//

import SwiftUI
import DatadogRUM

struct RegistrationBodyView: View {
    let step: RegistrationStep
    
    @Environment(TRouter.self) var router
    
    var body: some View {
        LazyVStack(alignment: .center,
                   spacing: 0) {
            switch step {
            case .phoneNumber, .codeSent, .codeReceived:
                PhoneInfoView(step: step)
                /**
                 TODO: - Adjust
                 This type of cases, when onAppear is being called once for all cases (.phoneNumber, .codeSent, .codeReceived)
                 we need to think a workaround
                 */
                    .trackRUMView(name: router.dataDogScreenName())
            case .nameAndBirthday:
                RegistrationNameAndAgeView()
                    .trackRUMView(name: router.dataDogScreenName())
            case .height:
                RegistrationHeightView()
                    .trackRUMView(name: router.dataDogScreenName())
            case .almaMaterOccupationCompany:
                RegistrationEducationInfoView()
                    .animation(.none, value: step)
                    .trackRUMView(name: router.dataDogScreenName())
            case .imageUpload:
                RegistrationAddImageView(parent: .registration)
                    .animation(.none, value: step)
                    .trackRUMView(name: router.dataDogScreenName())
            case .activityInterests:
                RegistrationInterestsView()
                    .animation(.none, value: step)
                    .trackRUMView(name: router.dataDogScreenName())
            default:
                RegistrationGeneralInformationView(step: step)
                    .trackRUMView(name: router.dataDogScreenName())
            }
        }
    }
}

struct RegistrationBodyView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationBodyView(step: .codeSent)
    }
}
