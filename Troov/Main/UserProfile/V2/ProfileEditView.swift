//
//  ProfileEditView.swift
//  Troov
//
//  Created by  Levon Arakelyan on 20.09.2023.
//

import SwiftUI

struct ProfileEditView: View, KeyboardReadable, AppProtocol {
    let menuItem: ProfileEditMenuItem

    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var occupation: String = ""
    @State private var selectedInfo: [String] = []
    @State private var heightValue = ProfileFilterAttributesMinHeight.medium
    @State private var ageValue = ProfileFilterAttributesMinHeight.medium
    @State private var validationState: ValidationState = .missing
    @State private var triggerAttention: Bool = false

    private let profileViewModel = ProfileViewModel.shared

    private var initialName: String? {
        profileViewModel.user?.userProfile?.firstName
    }

    private var initialOccupation: String? {
        profileViewModel.user?.userProfile?.occupation
    }
    
    private var initialHeight: Int? {
        profileViewModel.user?.userProfile?.height?.length
    }

    private var initialAge: Int? {
        if let age =  profileViewModel.user?.userProfile?.age {
            return Int(age)
        }
        return nil
    }

    private var initialInfo: [String]? {
        guard let userProfile = profileViewModel.user?.userProfile else { return nil }
        switch menuItem {
        case .gender:
            if let gender = userProfile.gender {
                return [gender.rawValue.cleanEnums]
            }
            return nil
        case .education:
            if let education = userProfile.education {
                return [education.rawValue.cleanEnums]
            }
            return nil
        case .religion:
            if let religion = userProfile.religion {
                return [religion.rawValue.cleanEnums]
            }
            return nil
        case .politics:
            if let politics = userProfile.politics {
                return [politics.rawValue.cleanEnums]
            }
            return nil
        case .ethnicity:
            return userProfile.ethnicity?.map({$0.rawValue.cleanEnums})
        default:
            return nil
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                switch menuItem {
                case .name:
                    RegistrationTextFieldView(text: $name,
                                              prompt: "Enter your name",
                                              triggerAttention: triggerAttention && validationState != .valid)
                    .overlay(alignment: .trailing) {
                        ValidatorView<Int, Float>(input: .string(input: name,
                                                                 rule: UserProfile.firstNameRule),
                                                  output: validate(_:))
                            .padding(.trailing, 5)
                    }.padding(.vertical, 2)
                     .padding(.horizontal, 20.relative(to: .width))
                case .height:
                    ProfileFilterAttributesHeightView(initialHeight: initialHeight,
                                                      heightChange: heightChange(_:))
                case .age:
                    ProfileAgeEditView(initialAge: initialAge,
                                       ageChange: ageChange(_:))
                case .gender, .education, .religion, .ethnicity, .politics:
                    ProfileGeneralProfileInfoEditView(menuItem: menuItem,
                                                      selectedInfo: $selectedInfo)
                case .occupation:
                    RegistrationTextFieldView(text: $occupation,
                                              prompt: "Enter your occupation (optional)",
                                              triggerAttention: triggerAttention && validationState != .valid)
                    .overlay(alignment: .trailing) {
                        ValidatorView<Int, Float>(input: .string(input: occupation,
                                                                 rule: UserProfile.occupationRule),
                                                  output: validate(_:))
                            .padding(.trailing, 5)
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal, 20.relative(to: .width))
                }
            }
            Spacer()
            BottomBarButtonView(isPrimary: allowUpdates,
                                text: "Update",
                                action: update)
        }.ignoresSafeArea([.keyboard, .all], edges: .bottom)
         .onAppear(perform: appear)
         .navigationTitle(menuItem.editTitle)
         .toolbar {
             keyboardToolbar
             ToolbarItem(placement: .navigationBarLeading) {
                 Button(action: { dismissView() }) {
                     Image("t.arrow.narrow.left")
                         .enlargeTapAreaForTopLeadingButton
                 }
             }
         }
    }

    private func appear() {
        switch menuItem {
        case .name:
            setupName()
        case .occupation:
            setupOccupation()
        default:
            if let initialInfo = initialInfo {
                selectedInfo = initialInfo
            }
            validationState = .valid
            return
        }
    }

    private func setupName() {
        name = initialName ?? ""
    }

    private func setupOccupation() {
        occupation = initialOccupation ?? ""
    }

    private func heightChange(_ newValue: Double) {
        heightValue = newValue
    }

    private func ageChange(_ newValue: Double) {
        ageValue = newValue
    }

   @MainActor private func dismissView() {
        dismiss()
    }
}

#Preview {
    ProfileEditView(menuItem: .education)
}

/**
 Validations
 **/
fileprivate extension ProfileEditView {
    private var hasChanges: Bool {
        switch menuItem {
        case .name:
            if let initialName = initialName {
                return initialName.clean != name.clean
            }
            return false
        case .height:
            if let initialHeight = initialHeight {
                let roundedValue = Int(round(heightValue))
                return initialHeight != roundedValue
            }
            return true
        case .age:
            if let initialAge = initialAge {
                let roundedValue = Int(round(ageValue))
                return initialAge != roundedValue
            }
            return false
        case .occupation:
            if let initialOccupation = initialOccupation {
                return initialOccupation.clean != occupation.clean
            }
            return false
        default:
            if let initialInfo = initialInfo {
                return initialInfo != selectedInfo
            }
            return !selectedInfo.isEmpty
        }
    }

    private var allowUpdates: Bool {
        return hasChanges && validationState == .valid
    }

    private func validate(_ state: ValidationState) {
        if Thread.isMainThread {
            self.validationState = state
        } else {
            DispatchQueue.main.async {
                self.validationState = state
            }
        }
    }
}

/**
 Server updates
 */
fileprivate extension ProfileEditView {
    private func update() {
        guard allowUpdates else {
            triggerAttention.toggle()
            hapticFeedback()
            return
        }
        if triggerAttention {
            triggerAttention = false
        }
        switch menuItem {
        case .name:
            updateName()
        case .gender:
            updateGender()
        case .height:
            updateHeight()
        case .age:
            updateAge()
        case .education:
            updateEducation()
        case .occupation:
            updateOccupation()
        case .religion:
            updateReligion()
        case .ethnicity:
            updateEthnicity()
        case .politics:
            updatePolitics()            
        }
    }

    private func updateGender() {
        Task {
            if let gender = selectedInfo.first {
                do {
                   try await profileViewModel.update(gender: gender)
                } catch {
                    debugPrint(String(describing: error))
                    //TODO: - complete
                }
            }
           await dismissView()
        }
    }

    private func updateName() {
        Task {
            do {
               try await profileViewModel.update(firstName: name)
            } catch {
                debugPrint(String(describing: error))
                //TODO: - complete
            }
           await dismissView()
        }
    }

    private func updateHeight() {
        Task {
            let roundedValue = Int(round(heightValue))
            do {
               try await profileViewModel.updateHeight(height: roundedValue)
            } catch {
                debugPrint(String(describing: error))
                //TODO: - complete
            }
            await dismissView()
        }
    }
    
    private func updateAge() {
        Task {
            let ageValue = Int64(ageValue)
            do {
               try await profileViewModel.updateAge(age: ageValue)
            } catch {
                debugPrint(String(describing: error))
                //TODO: - complete
            }
            await dismissView()
        }
    }
    
    private func updateEducation() {
        Task {
            if let education = selectedInfo.first {
                do {
                   try await profileViewModel.update(education: education)
                } catch {
                    debugPrint(String(describing: error))
                    //TODO: - complete
                }
            }

            await dismissView()
        }
    }

    private func updateOccupation() {
        Task {
            do {
               try await profileViewModel.update(occupation: occupation)
            } catch {
                debugPrint(String(describing: error))
                //TODO: - complete
            }

            await dismissView()
        }
    }
    
    private func updateReligion() {
        Task {
            if let religion = selectedInfo.first {
                do {
                    try await profileViewModel.update(religion: religion)
                } catch {
                    debugPrint(String(describing: error))
                    //TODO: - complete
                }
            }

            await dismissView()
        }
    }
    
    private func updateEthnicity() {
        Task {
            do {
                try await profileViewModel.update(ethnicity: selectedInfo)
            } catch {
                debugPrint(String(describing: error))
                //TODO: - complete
            }
            await dismissView()
        }
    }

    private func updatePolitics() {
        Task {
            if let politics = selectedInfo.first {
                do {
                    try await profileViewModel.update(politics: politics)
                } catch {
                    debugPrint(String(describing: error))
                    //TODO: - complete
                }
            }

            await dismissView()
        }
    }
}
