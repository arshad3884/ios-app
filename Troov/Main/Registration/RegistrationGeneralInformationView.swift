//
//  RegistrationGeneralInformationView.swift
//  Troov
//
//  Created by Leo on 01.09.2023.
//

import SwiftUI

struct RegistrationGeneralInformationView: View {
    let step: RegistrationStep
    @Environment(RegisterViewModel.self) var registerViewModel: RegisterViewModel

    @State private var selectedInfo: [String] = []
    
    private var generalInfo: [String] { step.generalInfo }

    private let vSpacing = 10.relative(to: .height)

    private var commercialQuestions: Bool {
        step == .marketingChannels ||
        step == .relationshipInterests ||
        step == .readOnlyBrowsing
    }
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: vSpacing) {
            Text(step
                .bodyTitle
                .highlighted(text: step.highlightedTextInTitle))
                .fontWithLineHeight(font: .poppins400(size: 16),
                                    lineHeight: 24)
                .lineLimit(4)
                .foregroundStyle(commercialQuestions ? Color.rgba(51, 51, 51, 1) : Color.rgba(33, 33, 33, 1))
                .padding(.bottom, commercialQuestions ? 36 : 0)
            VStack(spacing: vSpacing, content: {
                ForEach(generalInfo, id: \.self) { info in
                    if info == Education.notDisclosed.rawValue || info == "OPEN_TO_ANYTHING".cleanEnums  {
                        TDoubleDividerView(title: "or")
                            .padding(.bottom, 13)
                    }
                    Button { select(info) } label: {
                        if selectedInfo.contains(info) {
                            TSecondaryLabel(text: info.cleanEnums,
                                            isFilled: true)
                        } else {
                            TTertiaryLabel(text: info.cleanEnums)
                        }
                    }.buttonStyle(.scalable)
                        .padding(1)
                }
                .onChange(of: step, { oldValue, newValue in
                    onChange(oldValue, newValue)
                })
            })
        }.padding(.top, 36.relative(to: .height))
         .onAppear {
             get(step: step)
         }.onDisappear {
            save(step: step)
         }
    }
    
    private func onChange(_ oldStep: RegistrationStep,
                          _ newStep: RegistrationStep) {
        if newStep != oldStep { save(step: oldStep) }
        get(step: newStep)
    }
    
    private func save(step: RegistrationStep) {
        guard step != .readOnlyBrowsing else { return }
        registerViewModel.save(generalInfo: selectedInfo,
                               step: step)
    }
    
    private func get(step: RegistrationStep) {
        if step == .marketingChannels {
            selectedInfo = step.getGeneralInfo(user: registerViewModel.user)
        } else if let userProfile = registerViewModel.user.userProfile {
            selectedInfo = step.getGeneralInfo(userProfile: userProfile)
        }
        updateNextButtonState(step: step)
    }
    
    private func select(_ info: String) {
        if info == Education.notDisclosed.rawValue {
            if let index = selectedInfo.firstIndex(of: info) {
                selectedInfo.remove(at: index)
            } else {
                cleanAll()
                selectedInfo.append(info)
            }
        } else {
            cleanRatherNotDisclosed()
            if step == .ethnicity || step == .relationshipInterests {
                if step == .relationshipInterests {
                    if let index = selectedInfo.firstIndex(of: "OPEN_TO_ANYTHING".cleanEnums) {
                        if info != "OPEN_TO_ANYTHING".cleanEnums {
                            selectedInfo.remove(at: index)
                        } else if selectedInfo.count >= RelationshipInterest.relationshipInterestCasesToDisplay.count {
                            selectedInfo.removeAll(where: {$0 != "OPEN_TO_ANYTHING".cleanEnums})
                        }
                    } else if info == "OPEN_TO_ANYTHING".cleanEnums {
                        selectedInfo.removeAll(where: {$0 != "OPEN_TO_ANYTHING".cleanEnums})
                    }
                }
                
                if let index = selectedInfo.firstIndex(of: info) {
                    selectedInfo.remove(at: index)
                } else {
                    selectedInfo.append(info)
                }
            } else {
                if selectedInfo.count > 0 {
                    if let index = selectedInfo.firstIndex(of: info) {
                        selectedInfo.remove(at: index)
                    } else {
                        selectedInfo[0] = info
                    }
                } else {
                    selectedInfo.insert(info, at: 0)
                }
            }
        }
        
        updateNextButtonState(step: step)
        
        if step == .readOnlyBrowsing {
            let createProfile = selectedInfo.contains("CREATE_PROFILE")
            registerViewModel.createProfile = createProfile
        }
    }
    
    private func cleanRatherNotDisclosed() {
        selectedInfo.removeAll(where: {$0 == Education.notDisclosed.rawValue})
    }
    
    private func cleanAll() {
        selectedInfo = []
    }
    
    private func updateNextButtonState(step: RegistrationStep) {
        if step.generalInfo.contains(where: { selectedInfo.contains($0)}) {
            registerViewModel.validate(.valid)
        } else {
            registerViewModel.validate(.missing)
        }
    }
}

struct RegistrationGeneralInformationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationGeneralInformationView(step: .education)
    }
}
