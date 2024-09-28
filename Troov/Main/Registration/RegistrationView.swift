//
//  RegistrationView.swift
//  Troov
//
//  Created by Leo on 04.09.2023.
//

import SwiftUI

struct RegistrationView: View, KeyboardReadable {
    @Environment(TRouter.self) var router: TRouter

    @State private var registerViewModel: RegisterViewModel
    @State private var askToContinue: Bool
    
    private var step: RegistrationStep {
        router.registrationStep
    }

    private let initialStep: RegistrationStep
    
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 0) {
                if step != .complete {
                    RegistrationTopBarView(step: step)
                    ScrollView(showsIndicators: false) {
                        RegistrationBodyView(step: step)
                            .padding(.horizontal, step == .activityInterests ? 20 : 30)
                    }
                } else {
                    Spacer()
                    SuccessfulRegistrationView()
                        .trackRUMView(name: router.dataDogScreenName(customSuffix: "Successful Registration"))
                }
                Spacer()
                PrimaryButton(isPrimary: registerViewModel.isNextAllowed,
                                    text: step.buttonName,
                                    action: { self.nextAction() })
            }
             .onChange(of: registerViewModel.skip, { oldValue, newValue in
                if oldValue != newValue {
                    skip()
                }
            })
            .environment(registerViewModel)
            .background(Color.white)
            .ignoresSafeArea([.keyboard, .all], edges: .bottom)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    if !backDisabled {
                        Button(action: { previousAction() }) {
                            Image("t.arrow.narrow.left")
                                .enlargeTapAreaForTopLeadingButton
                        }
                        .disabled(backDisabled)
                        .opacity(backDisabled ? 0 : 1)
                    }
        
                    if step == .activityInterests {
                        Text("Interests")
                            .foregroundStyle(Color.primaryTroovColor)
                            .fontWithLineHeight(font: .poppins600(size: 18), lineHeight: 27)
                    }
                }
                if step.canSkip {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: skip) {
                            Text("Skip")
                                .foregroundStyle(Color.primaryTroovColor)
                                .fontWithLineHeight(font: .poppins600(size: 16), lineHeight: 24)
                        }
                    }
                }
                
                if step == .imageUpload {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: editPhotos) {
                            Text("Edit Photos")
                                .foregroundStyle(Color.primaryTroovColor)
                                .fontWithLineHeight(font: .poppins600(size: 16), lineHeight: 24)
                        }
                    }
                }
                
                keyboardToolbar
            }
            .overlay(alignment: .center) {
                if askToContinue {
                    ClassicPopover(title: "Do you want to continue\nthe previous registration?",
                                   approveTitle: "Yes",
                                   resignTitle: "No",
                                   height: 150,
                                   acceptancePriority: .high,
                                   showPicker: $askToContinue,
                                   approve: {},
                                   reject: logout).frame(maxWidth: .infinity,
                                                         maxHeight: .infinity)
                                   .ignoresSafeArea(.all)
                }
            }
            .overlay {
                if isLoading {
                    TProgress.Lottie() {
                        isLoading = false
                    }
                }
            }
        }.disabled(registerViewModel.blockScreen)
            .alert("Warning",
                   isPresented: $registerViewModel.showImageUploadWarning) {
                if registerViewModel.allowToProceedImageUpload {
                    Button(role: .destructive) {
                        nextAction()
                    } label: {
                        Text("Continue")
                    }
                }
                Button(role: .cancel) {
                    editPhotos()
                } label: {
                    Text("Edit Photos")
                }
            } message: {
                Text("One or more of your image uploads failed due to a violation of our policies. Note that all images should include your face without explicit nudity or violence.")
                    .lineLimit(5)
                    .fontWithLineHeight(font: .poppins400(size: 12),
                                        lineHeight: 18)
                    .foregroundColor(.primaryTroovColor)
            }
    }

    private var backDisabled: Bool {
        if initialStep == .codeSent {
            return [RegistrationStep.phoneNumber,
                    .codeReceived,
                    .complete,
                    .phoneNumber].contains(step)
        } else {
            return [RegistrationStep.phoneNumber,
                    .codeSent,
                    .codeReceived,
                    .complete,
                    .phoneNumber,
                     initialStep].contains(step)
        }
    }

    @MainActor private func nextAction() {
        guard registerViewModel.allowNext() else { return }
    
        Task {
            switch step {
            case .phoneNumber:
                isLoading = true
                await registerViewModel.sendSmsCodeForUser(isResendCode: false)
                await MainActor.run {
                    isLoading = false
                }
                await self.continueTheNextStep()
            case .codeSent:
                isLoading = true
                await registerViewModel.verifySmsCodeForUser()
                await MainActor.run {
                    isLoading = false
                }
                await self.continueTheNextStep()
            case .codeReceived:
                await registerViewModel.updateUserAccount(registrationStatus: .codeReceived)
                await self.continueTheNextStep()
            case .marketingChannels,
                 .relationshipInterests,
                 .nameAndBirthday,
                 .gender,
                 .almaMaterOccupationCompany,
                 .height,
                 .education,
                 .ethnicity,
                 .politics,
                 .religion:
                await continueTheNextStep()
            case .activityInterests:
                registerViewModel.saveActivityInterests()
                await continueTheNextStep()
            case .imageUpload:
                registerViewModel.blockScreen = true
                do {
                    try await registerViewModel.uploadMediaAndFetchUser(step: .imageUpload)
                    await continueTheNextStep()
                } catch {
                    await MainActor.run {
                        debugPrint(String(describing: error))
                        registerViewModel.validateMedia()
                    }
                }
                registerViewModel.blockScreen = false
            case .readOnlyBrowsing:
                if registerViewModel.createProfile {
                    await registerViewModel.updateUserAccount(registrationStatus: .readOnlyBrowsing)
                    await continueTheNextStep()
                } else {
                    await registerViewModel.updateUserStepToDoItLater()
                    router.routeToApp(cycle: .tab, tab: .discover(.List))
                    router.registerationStep(step: .doItLaterOption)
                }
            case .tutorial:
                router.routeToApp(cycle: .tab, tab: .tutorial)
            case .complete:
                router.routeToApp(cycle: .tab, tab: .discover(.List))
            default:
                /*
                 TODO: - replace with logging with Datadog
                 */
                debugPrint("New missing step")
            }
        }
    }

    private func continueTheNextStep() async {
        if let next = step.next() {
            await MainActor.run(body: {
                withAnimation {
                    router.registerationStep(step: next)
                }
            })
        }
    }
    
   @MainActor private func previousAction() {
        guard !backDisabled else { return }
        registerViewModel.validate(.valid)
        if let previous = step.previous() {
            withAnimation {
                router.registerationStep(step: previous)
            }
            registerViewModel.updateLatestStep(step: previous)
        }
    }

    private func skip() {
        Task {
            if let nextStep = RegistrationStep.imageUpload.previous() {
                await registerViewModel.updateUserAccount(registrationStatus: nextStep)
                    await MainActor.run {
                        withAnimation {
                            router.registerationStep(step: .imageUpload)
                        }
                    }
            }
        }
    }

    private func logout() {
        router.logout()
    }

    private func editPhotos() {
        registerViewModel.showImagePicker = true
    }
    
    init(user: User,
         step: RegistrationStep,
         askToContinue: Bool,
         withActivities: Bool = true) {
        _registerViewModel = State(initialValue: .init(withActivities: withActivities,
                                                       user: user))
        self.initialStep = step
        self.askToContinue = askToContinue
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(user: .preview,
                         step: .phoneNumber,
                         askToContinue: false)
    }
}

extension RegistrationView {
    struct PrimaryButton: View {
        var isPrimary: Bool = true
        let text: String
        let action: (() -> Void)
        
        var body: some View {
            VStack(spacing: 0) {
                Button(action: action,
                       label: {
                    if isPrimary {
                        TPrimaryLabel(text: text)
                            .animation(.none, value: text)
                    } else {
                        TSecondaryLabel(text: text)
                            .animation(.none, value: text)
                    }
                })
                .buttonStyle(.scalable)
                .trackRUMTapAction(name: text)
                .padding(.top, 16.relative(to: .height))
                .padding(.horizontal, 20.relative(to: .width))
                .frame(maxWidth: .infinity)
                .padding(.bottom, 57)
            }.background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
             .shadow(color: .black.opacity(0.08),
                     radius: 4, x: 0, y: -4)
        }
    }
}
