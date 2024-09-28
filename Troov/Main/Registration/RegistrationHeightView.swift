//
//  RegistrationHeightView.swift
//  Troov
//
//  Created by Leo on 01.09.2023.
//

import SwiftUI

struct RegistrationHeightView: View, KeyboardReadable {
    @Environment(RegisterViewModel.self) var registerViewModel: RegisterViewModel

    @State private var notDisclose = false
    @State private var height = ProfileFilterAttributesMinHeight.medium
    @State private var heightIsSet = false
    @State private var showSkipRegisterPrompt = false
    private let minHeight = ProfileFilterAttributesMinHeight.min
    private let maxHeight = ProfileFilterAttributesMinHeight.max

    private var userProfile: UserProfile? {
        registerViewModel.user.userProfile
    }

    var body: some View {
        VStack(alignment: .leading,
               spacing: 0) {
            VStack(alignment: .leading) {
                Text("Select Your Height")
                    .fontWithLineHeight(font: .poppins400(size: 14), lineHeight: 14)
                    .foregroundColor(.rgba(33, 33, 33, 1))
                    .padding(.top, 15.relative(to: .height))
                Button {
                    notDisclose.toggle()
                } label: {
                    HStack(spacing: 9) {
                        Rectangle()
                            .stroke(Color.rgba(34, 34, 34, 0.4), lineWidth: 2)
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 18)
                            .overlay {
                                if notDisclose {
                                    Image("t.checkmark")
                                        .resizable()
                                        .renderingMode(.template)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 15, height: 13)
                                        .foregroundStyle(Color.white)
                                }
                            }.background {
                                if notDisclose {
                                    Rectangle()
                                        .fill(Color.primaryTroovColor)
                                }
                            }
                        
                        Text("Would rather not disclose")
                            .fontWithLineHeight(font: .poppins400(size: 12), lineHeight: 18)
                            .foregroundStyle(Color.rgba(33, 33, 33, 1))
                    }
                }.buttonStyle(.scalable(value: 0.99))
                    .padding(.top, 13)

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
                            .opacity(notDisclose ? 0.01 : 1)
                    }.padding(.top, 10), alignment: .top)
                     .disabled(notDisclose)
                     .padding(.top, 10)
                     .onChange(of: height) { _, _ in heightIsSet = true }
            }
            Spacer()
        }.padding(.top, 36.relative(to: .height))
         .onTapGesture(perform: endEditing)
         .onDisappear(perform: disappear)
         .onAppear(perform: appear)
         .sheet(isPresented: $showSkipRegisterPrompt) {
             RegistrationExitQuestionnaireView(skip: skip)
                 .onDisappear {
                     registerViewModel.showSkipRegisterPrompt = false
                 }
         }
    }

    private func disappear() {
        if !notDisclose {
            let roundedValue = Int(round(height))
            registerViewModel.save(height: roundedValue)
        }
    }

    private func appear() {
        if let length = userProfile?.height?.length {
            height = Double(length)
            heightIsSet = true
        }

        registerViewModel.validate(.valid)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            showSkipRegisterPrompt = registerViewModel.showSkipRegisterPrompt
        })
    }

    private func skip() {
        Task {
            if let step = RegistrationStep.imageUpload.previous() {
                if !notDisclose && heightIsSet {
                    let roundedValue = Int(round(height))
                    registerViewModel.save(height: roundedValue)
                }
                await registerViewModel.updateUserAccount(registrationStatus: step)
                registerViewModel.skip.toggle()
            }
        }
    }
}


struct RegistrationHeightViewView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationHeightView()
    }
}
