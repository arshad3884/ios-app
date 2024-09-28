//
//  TRouter+Troov.swift
//  Troov
//
//  Created by Levon Arakelyan on 06.09.24.
//

import Foundation

extension TRouter {
    
    func dataDogTapAction(named actionName: String, customSuffix: String? = nil) -> String {
        let dataDogScreenName = self.dataDogScreenName(customSuffix: customSuffix)
        return actionName + " -> " + dataDogScreenName
    }
    
    func dataDogScreenName(customSuffix: String? = nil) -> String {
        
        var appCycleDataDogScreenName = appCycle.dataDogScreenName
        if appCycle != .tab {
            if registrationStep != .complete {
                appCycleDataDogScreenName += "/" + registrationStep.rawValue.cleanEnums
            }
        } else {
            var appTabDataDogScreenName = appTab.dataDogScreenName
            
            if let navigationPath = navigationPath {
                let navigationPathDataDogScreenName = navigationPath.dataDogScreenName
                appTabDataDogScreenName += "/" + navigationPathDataDogScreenName
            }
            
            if let presentationPath = presentationPath {
                let navigationPathDataDogScreenName = presentationPath.dataDogScreenName
                appTabDataDogScreenName += "/" + navigationPathDataDogScreenName
            }
            
            if let sheet = picksDetailViewSheetPath {
                let sheetDataDogScreenName = sheet.dataDogScreenName
                appTabDataDogScreenName += "/" + sheetDataDogScreenName
            }
            
            appCycleDataDogScreenName += "/" + appTabDataDogScreenName
        }
        
        
        if let customSuffix = customSuffix {
            appCycleDataDogScreenName += "/" + customSuffix
        }

        return appCycleDataDogScreenName
    }
}

extension TRouter {
    enum AppCycle: Equatable {
        case launch
        case onboarding
        case register(user: User,
                      step: RegistrationStep,
                      askToContinue: Bool = false)
        case tab

        fileprivate var dataDogScreenName: String {
            switch self {
            case .launch:
                return "Launch"
            case .onboarding:
                return "Onboarding"
            case .register:
                return "Register"
            case .tab:
                return "Main"
            }
        }
    }
}

extension TRouter {
    enum NavigationPath: Hashable {
        case createTroov(troov: Troov? = nil)
        case discoverPages(troovId: String, troovs: [Troov])
        case chat(sessionId: String?)
        case adminChat(sessionId: String?)
        case discover(troov: Troov)

        fileprivate var dataDogScreenName: String {
            switch self {
            case .createTroov(let troov):
                return "Create Troov With Troov ID: \(troov?.troovId ?? "")"
            case .discoverPages(let troovId, _):
                return "Discover Pages Troov ID: \(troovId)"
            case .chat(let sessionId):
                return "Chat With Session ID: \(sessionId ?? "Unknown")"
            case .adminChat(let sessionId):
                return "Admin Chat With Session ID: \(sessionId ?? "Unknown")"
            case .discover(let troov):
                return "Discover Detail For Troov ID: \(troov.id)"
            }
        }
    }

    enum PresentationPath: Identifiable, Equatable {
        var id: String {
            switch self {
            case .sortedBy:
                return "sortedBy"
            case .filters:
                return "filters"
            case .addChatSession(let troov):
                return "addChatSession_\(troov.id)"
            case .event:
                return "event"
            case .profile(let item):
                return "profile_\(item.rawValue)"
            case .completeRegistrationView(let step):
                return "completeRegistrationView_\(step.rawValue)"
            }
        }
    
        static func == (lhs: PresentationPath, rhs: PresentationPath) -> Bool {
            switch (lhs, rhs) {
            case (.filters, .filters):
                return true
            case (.sortedBy, .sortedBy):
                return true
            case (.event, .event):
                return true
            case (.addChatSession(let a), .addChatSession(let b)):
                return a.id == b.id  // This compares 'Troov' instances. Ensure 'Troov' conforms to 'Equatable'.
            case (.profile(let a), .profile(let b)):
                return a == b // This compares 'ProfileEditMenuItem' instances. Ensure 'ProfileEditMenuItem' conforms to 'Equatable'.
            case (.completeRegistrationView(let a), .completeRegistrationView(let b)):
                return a == b
            default:
                return false  // Covers cases where the two cases are different
            }
        }
        
        case filters
        case addChatSession(troov: Troov)
        case event(troov: Troov)
        case profile(item: ProfileEditMenuItem)
        case sortedBy
        case completeRegistrationView(MainView.CompleteRegistrationView.Step)

        fileprivate var dataDogScreenName: String {
            switch self {
            case .filters:
                return "Filters"
            case .addChatSession(let troov):
                return "Add Chat Session Troov ID: \(troov.id)"
            case .event(let troov):
                return "Event Troov ID: \(troov.id)"
            case .profile(let item):
                return "Profile Edit: \(item.profileDetailsEditorMenuName)"
            case .sortedBy:
                return "Sorted By"
            case .completeRegistrationView(let step):
                return "Complete Registration: \(step.rawValue)"
            }
        }
    }
}

enum TTabRoute: CaseIterable, Identifiable, Equatable {
    static var allCases: [TTabRoute] = [.tutorial, .mytroovs, .discover(.List), .chatSessions, .myprofile]
        
    var id: String {
        switch self {
        case .tutorial:
            return "createTroov"
        case .mytroovs:
            return "mytroovs"
        case .discover(let value):
            return "discover\(value.rawValue)"
        case .chatSessions:
            return "chatSessions"
        case .myprofile:
            return "myprofile"
        }
    }
    
    case tutorial
    case mytroovs
    case discover(Discover)
    case chatSessions
    case myprofile

    static func == (lhs: TTabRoute, rhs: TTabRoute) -> Bool {
         switch (lhs, rhs) {
         case (.tutorial, .tutorial),
              (.mytroovs, .mytroovs),
              (.chatSessions, .chatSessions),
              (.myprofile, .myprofile):
             return true
         case (.discover(let leftValue), .discover(let rightValue)):
             return leftValue == rightValue
         default:
             return false
         }
     }

    var dataDogScreenName: String {
        switch self {
        case .tutorial:
            return "Tutorial"
        case .mytroovs:
            return "My Troovs"
        case .discover(let discover):
            return "Discover \(discover.rawValue)"
        case .chatSessions:
            return "Chat Sessions"
        case .myprofile:
            return "My Profile"
        }
    }
}

extension TTabRoute {
    enum Discover: String, Equatable {
        case List
        case Map
    }
}

// MARK: - Extension for Image Tab Pages

extension TTabRoute {
    var icon: String {
        switch self {
        case .discover:
            return "t.discover"
        case .mytroovs:
            return "t.toolbar.calendar"
        case .tutorial:
            return "t.create.troov"
        case .chatSessions:
            return "t.toolbar.chat"
        case .myprofile:
            return "t.toolbar.person"
        }
    }
}

/**
 Sheet presentation
 */
extension PicksDetailView {
    enum SheetPath: Identifiable, Equatable {
        var id: String {
            switch self {
            case .troovRequestView(let troov):
                return "troovRequestView_\(troov.id)"
            case .troovAcceptDialogueView(let item):
                return "troovAcceptDialogueView\(item.id)"
            case .chat:
                return "chat"
            }
        }

        static func == (lhs: SheetPath, rhs: SheetPath) -> Bool {
            switch (lhs, rhs) {
            case (.troovAcceptDialogueView(let a), .troovAcceptDialogueView(let b)):
                return a.id == b.id  // This compares 'Troov' instances. Ensure 'Troov' conforms to 'Equatable'.
            case (.troovRequestView(let a), .troovRequestView(let b)):
                return a.id == b.id  // This compares 'Troov' instances. Ensure 'Troov' conforms to 'Equatable'.
            case (.chat, .chat):
                return true
            default:
                return false
            }
        }
    
        case troovRequestView(troov: Troov)
        case troovAcceptDialogueView(item: TroovRequestView.AcceptDialogueView.Item)
        case chat

        fileprivate var dataDogScreenName: String {
            switch self {
            case .troovRequestView(let troov):
                return "Troov Request Troov ID: \(troov.id)"
            case .troovAcceptDialogueView(let item):
                return "Troov Accept Dialogue Name: \(item.name)"
            case .chat:
                /**
                 TODO: - Maybe can be added the Session ID
                 */
                return "Troov Request Chat"
            }
        }
    }
}
