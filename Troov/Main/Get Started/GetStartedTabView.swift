//
//  GetStartedTabView.swift
//  Troov
//
//  Created by Levon Arakelyan on 28.01.24.
//

import SwiftUI

struct GetStartedTabView: View {
    let sizeHeight: CGFloat
    var size: CGSize
    @Binding var step: Step
    
    private var backgroundShape: some View {
        TTabBarShape(Xa: -TDiscoverMapButton.size - 13 + size.width/2,
                     deep: sizeHeight/1.3)
        .foregroundStyle(Color.white)
        .cornerRadius(20)
    }

    private var centralIcon: String {
        if [Step.discoverList, .discoverMap, .discoverTroov].contains(step) {
            return step.icon
        }
        return Step.discoverList.icon
    }

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Button(action: {
                step(to: .createTroov)
            },
                   label: {
                Icon(currentStep: .createTroov,
                           step: step,
                           width: size.width/5,
                           height: size.height/28)
            })
            Button {
                step(to: .mytroovs)
            } label: {
                Icon(currentStep: .mytroovs,
                           step: step,
                           width: size.width/5,
                           height: size.height/28)
            }
            Spacer()
            Button {
                step(to: .chat)
            } label: {
                Icon(currentStep: .chat,
                           step: step,
                           width: size.width/5,
                           height: size.height/28)
            }
            Button {
                step(to: .myprofile)
            } label: {
                Icon(currentStep: .myprofile,
                     step: step,
                           width: size.width/5,
                           height: size.height/28)
            }
        }
        .background(backgroundShape)
        .frame(width: size.width,
               height: sizeHeight,
               alignment: .bottom)
        .shadow(color: Color(red: 0.77, green: 0.7, blue: 0.52).opacity(0.36), radius: 15, x: 0, y: -9)
        .overlay(alignment: .top) {
                TDiscoverMapButton(icon: centralIcon)
         .onTapGesture(perform: { step(to: .discoverMap) })
         .padding(.top, -26)
        }
    }
    
    private func step(to step: Step) {
        self.step = step
    }
}

#Preview {
    GetStartedTabView(sizeHeight: 10,
                      size: .zero,
                      step: .constant(.discoverMap))
}

fileprivate extension GetStartedTabView {
    struct Icon: View {
        var currentStep: Step
        var step: Step

        var width, height: CGFloat

        private var color: Color {
            return step == currentStep ? Color.primaryTroovColor : Color.primaryBlack.opacity(0.8)
        }

        private var icon: String {
            currentStep.icon
        }
        
        var body: some View {
                VStack(spacing: 0) {
                    Image(icon)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .padding(6)
                        .background(content: {
                                Circle()
                                .fill(step == currentStep ? Color.primaryTroovColor.opacity(0.1) : .clear.opacity(1))
                        })
                        .padding(.top, 26)
                        .padding(.bottom, 4.2)
                    Spacer()
                }.frame(width: width)
                 .padding(.horizontal, -4)
                 .foregroundColor(color)
            }
    }
}
 
extension GetStartedTabView {
    enum Step: CaseIterable, Identifiable {
        var id: Step {
            return self
        }
        case createTroov
        case mytroovs
        case discoverList
        case discoverMap
        case discoverTroov
        case chat
        case myprofile
    }
}

extension GetStartedTabView.Step {
    var getStartedInfoTitle: String {
        switch self {
        case .createTroov:
            return "Create A Troov"
        case .mytroovs:
            return "My Troovs"
        case .discoverList:
            return "Discover - List View"
        case .discoverMap:
            return "Discover - Map View"
        case .discoverTroov:
            return "Discover - Troov View"
        case .chat:
            return "Chat"
        case .myprofile:
            return "Profile"
        }
    }
    
    var getStartedInfoBody: String {
        switch self {
        case .createTroov:
            return "Come up with a fun one-on-one activity idea for a troov and find someone to join you."
        case .mytroovs:
            return "Easily manage your posted one-on-one activities, join requests, and view your calendar of upcoming confirmed troovs."
        case .discoverList:
            return "Toggle between the map view and the list view of all active troovs in your surrounding location."
        case .discoverMap:
            return "Toggle between the map view and the list view of all active troovs in your surrounding location."
        case .discoverTroov:
            return "Click on any of the list view troovs to see more details and click the button to request to join."
        case .chat:
            return "Chat with other users you've requested to join their troovs and confirmed troovs."
        case .myprofile:
            return "Manage and edit your profile details.\n "
        }
    }

    var icon: String {
        switch self {
        case .discoverList:
            return "t.discover.icon.unselected"
        case .discoverMap:
            return "t.discover.icon"
        case .discoverTroov:
            return "t.chat.sign"
        case .mytroovs:
            return "t.toolbar.calendar"
        case .createTroov:
            return "t.create.troov"
        case .chat:
            return "t.toolbar.chat"
        case .myprofile:
            return "t.toolbar.person"
        }
    }
    
    func offset(width: CGFloat) -> CGFloat {
        switch self {
        case .discoverList, .discoverMap, .discoverTroov:
            return 0
        case .mytroovs:
            return width/5 + width/10 - width/2
        case .createTroov:
            return width/10 - width/2
        case .chat:
            return width/5
        case .myprofile:
            return width/2.5
        }
    }

    func nextIntroStep() -> Self? {
        let allCases = Self.allCases
        if let index = allCases.firstIndex(of: self),
           index < allCases.count - 1 {
            return allCases[index + 1]
        } else {
            return nil
        }
    }

    var containsDiscover: Bool {
        [GetStartedTabView.Step.discoverMap, .discoverList, .discoverTroov].contains(self)
    }

}
