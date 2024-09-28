//
//  TRouter.swift
//  mango
//
//  Created by Leo on 14.04.22.
//  Copyright © 2022 Levon Arakelyan. All rights reserved.
//

import SwiftUI
import DatadogRUM

@Observable class TRouter {
    private(set) var appCycle: AppCycle = .launch
    private(set) var appTab: TTabRoute = .discover(.List)
    private(set) var registrationStep: RegistrationStep = .complete
    private(set) var preventPotentialInAppMemoryLeaks = false
    private var task: Task<(), Never>?
    
    var navigationPath: NavigationPath?
    var presentationPath: PresentationPath?
    var picksDetailViewSheetPath: PicksDetailView.SheetPath?
    
    init() {
        if TAuth0.shared.hasValid {
            /**
             In main cases users are going to have  a valid user profile,
             so we don't want to make them to wait each time they relaunch the app.
             Instead, we allow them to login and continue validation in background
             */

            appCycle = .tab
            appTab = .discover(.List)
            validateUserTask()
        } else {
            Task { await logout() }
        }
    }

    private func validateUserTask() {
        task?.cancel()
        task = Task.detached(priority: .background) {
            if let user = await ProfileViewModel.asyncGetUser() {
                ProfileViewModel.setUpdateUserLocalAndServer(user: user)
                await self.validateUser(user: user, askToContinue: true)
            } else {
                await self.logout()
            }
        }
    }

    private func validateUser(user: User, askToContinue: Bool = false) async {
        DataDog.setUserInfo(userId: TAuth0.shared.userInfo?.sub)
        if let step = user.registrationStatus {
            await registerationStep(step: step)
            if step == .complete ||
               step == .doItLaterOption {
                await routeToApp(cycle: .tab, tab: .discover(.List))
            } else if step == .tutorial {
                await routeToApp(cycle: .tab, tab: .tutorial)
            }
            else {
                await self.routeToApp(cycle: .register(user: user,
                                                       step: step,
                                                       askToContinue: askToContinue))
            }
        } else {
            await registerationStep(step: .firstStep)
            await self.routeToApp(cycle: .register(user: user,
                                                   step: .firstStep,
                                                   askToContinue: askToContinue))
        }
    }
    
    private func signInOrSignUp() async throws {
        if let user = await ProfileViewModel.asyncGetUser() {
            ProfileViewModel.setUpdateUserLocalAndServer(user: user)
            await validateUser(user: user,
                               askToContinue: true)
        } else if let user = User() {
            try await ProfileViewModel.create(user: user)
            await validateUser(user: user)
        } else {
            throw TRequestError.custom(message: "Something went wrong! Try again later")
        }
    }

    // MARK: - Auth0 authentication flow
    func auth0(type: TAuth0.`Type`) async {
        if TEnvironment.shared.scheme == .demo {
            await routeToApp(cycle: .tab, tab: .discover(.List))
        }
        do {
            try await TAuth0.shared.start(parameter: type)
            switch type {
            case .signIn: 
                return try await self.signInOrSignUp()
            case .signUp:
                return try await self.signInOrSignUp()
            }
        } catch {
//            await alert(message: String(describing: error))
        }
    }

    @MainActor func routeToApp(cycle: AppCycle, tab: TTabRoute? = nil) {
        if Thread.isMainThread {
             if appCycle != cycle {
                if cycle != .tab { preventPotentialInAppMemoryLeaks.toggle() }
                appCycle = cycle
             }
            
            if let tab = tab, appTab != tab {
                appTab = tab
            }
        } else {
            DispatchQueue.main.async {
                if self.appCycle != cycle {
                    self.appCycle = cycle
                }
               
                if let tab = tab, self.appTab != tab {
                   self.appTab = tab
               }
            }
        }
    }

    @MainActor func navigateTo(_ path: NavigationPath) {
        if self.navigationPath != path {
            self.navigationPath = path
        }
    }

    @MainActor func present(_ path: PresentationPath) {
        if self.presentationPath != path {
            self.presentationPath = path
        }
    }
    
    @MainActor func sheetPicksDetailView(_ path: PicksDetailView.SheetPath) {
        if self.picksDetailViewSheetPath != path {
            self.picksDetailViewSheetPath = path
        }
    }

   @MainActor func logout() {
       TAuth0.shared.logout()
       routeToApp(cycle: .onboarding)
       registerationStep(step: .complete)
    }

    @MainActor func registerationStep(step: RegistrationStep) {
        self.registrationStep = step
    }

    func completeUncompleteRegistraionNow() {
        preventPotentialInAppMemoryLeaks.toggle()
        Task {
            await ProfileViewModel.updateRegistration(step: .phoneNumber)
            if let user = ProfileViewModel.shared.user {
                await registerationStep(step: .phoneNumber)
                await MainActor.run {
                    routeToApp(cycle: .register(user: user,
                                                step: .phoneNumber,
                                                askToContinue: false),
                               tab: nil)
                    
                }
            }
        }
    }
}
