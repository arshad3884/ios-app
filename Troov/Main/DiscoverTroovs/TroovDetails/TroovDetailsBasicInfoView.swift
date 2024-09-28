//
//  TroovDetailsBasicInfoView.swift
//  Troov
//
//  Created by Levon Arakelyan on 10.10.23.
//

import SwiftUI

struct TroovDetailsBasicInfoView: View {
    
    let requester: UserProfileWithUserId
    
    private var hasProfessionalPublicInfo: Bool {
        return requester.company != nil ||
        requester.occupation != nil ||
        requester.almaMater?.first != nil ||
        requester.education?.rawValue != nil
    }
    
    var body: some View {
        VStack(alignment: .center,
               spacing: 12) {
            VStack(alignment: .center,
                   spacing: 12) {
                HStack(alignment: .center,
                       spacing: 6) {
                    Image("t.person")
                    Text("Basic")
                        .foregroundStyle(Color.black)
                        .fontWithLineHeight(font: .poppins700(size: 14), lineHeight: 21)
                    Spacer()
                }
                if let gender = requester.gender {
                    HStack(alignment: .center) {
                        Text("Gender")
                            .foregroundStyle(Color.black)
                        Spacer()
                        Text(gender.rawValue.cleanEnums)
                            .foregroundStyle(Color.primaryTroovColor)
                    }.fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 21)
                }
                if let length = requester.height?.length {
                    HStack(alignment: .center) {
                        Text("Height")
                            .foregroundStyle(Color.black)
                        Spacer()
                        Text("\(ProfileFilterAttributesMinHeight.heightString(of: Double(length))) ft")
                            .foregroundStyle(Color.primaryTroovColor)
                    }.fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 21)
                }
                if let ethnicity = requester.ethnicity?.first?.rawValue {
                    HStack(alignment: .center) {
                        Text("Ethnicity")
                            .foregroundStyle(Color.black)
                        Spacer()
                        Text(ethnicity.cleanEnums)
                            .foregroundStyle(Color.primaryTroovColor)
                    }.fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 21)
                }
                if let politics = requester.politics?.rawValue {
                    HStack(alignment: .center) {
                        Text("Politics")
                            .foregroundStyle(Color.black)
                        Spacer()
                        Text(politics.cleanEnums)
                            .foregroundStyle(Color.primaryTroovColor)
                    }.fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 21)
                }
                if let religion = requester.religion?.rawValue {
                    HStack(alignment: .center) {
                        Text("Religion")
                            .foregroundStyle(Color.black)
                        Spacer()
                        Text(religion.cleanEnums)
                            .foregroundStyle(Color.primaryTroovColor)
                    }.fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 21)
                }
            }
            if hasProfessionalPublicInfo {
                Divider()
                VStack(alignment: .center,
                       spacing: 12) {
                    HStack(alignment: .center,
                           spacing: 6) {
                        Image("t.professional")
                        Text("Professional")
                            .foregroundStyle(Color.black)
                            .fontWithLineHeight(font: .poppins700(size: 14), lineHeight: 21)
                        Spacer()
                    }
                    
                    if let education = requester.education?.rawValue {
                        HStack(alignment: .center) {
                            Text("Education")
                                .foregroundStyle(Color.black)
                            Spacer()
                            Text(education.cleanEnums)
                                .foregroundStyle(Color.primaryTroovColor)
                        }.fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 21)
                    }
                    
                    if let almaMater = requester.almaMater?.first {
                        HStack(alignment: .center) {
                            Text("School")
                                .foregroundStyle(Color.black)
                            Spacer()
                            Text(almaMater)
                                .foregroundStyle(Color.primaryTroovColor)
                        }.fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 21)
                    }
                    if let occupation = requester.occupation {
                        HStack(alignment: .center) {
                            Text("Occupation")
                                .foregroundStyle(Color.black)
                            Spacer()
                            Text(occupation)
                                .foregroundStyle(Color.primaryTroovColor)
                        }.fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 21)
                    }
                    if let company = requester.company {
                        HStack(alignment: .center) {
                            Text("Company")
                                .foregroundStyle(Color.black)
                            Spacer()
                            Text(company)
                                .foregroundStyle(Color.primaryTroovColor)
                        }.fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 21)
                    }
                }
            }
        }.padding(.vertical, 13)
         .padding(.horizontal, 15)
         .background(RoundedRectangle(cornerRadius: 10)
            .fill(Color.primaryTroovColor.opacity(0.03)))
    }
}

#Preview {
    TroovDetailsBasicInfoView(requester: .init(userProfile: .init())!)
}
