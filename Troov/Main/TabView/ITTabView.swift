//
//  TabView.swift
//  Troov
//
//  Created by Levon Arakelyan on 30.08.23.
//

import SwiftUI

struct ITTabView: View {
    let size: CGSize

    @Environment(TRouter.self) var router: TRouter
    
    @State private var route: TTabRoute = .discover(.List)

    private var sizeHeight: CGFloat {
        size.height/8
    }

    private var backgroundShape: some View {
        TTabBarShape(Xa: -TDiscoverMapButton.size - 13 + size.width/2,
                     deep: sizeHeight/1.3)
        .foregroundStyle(Color.white)
        .cornerRadius(20)
    }

    private var centralIcon: String {
        return route == .discover(.List) ? "t.discover.icon" : "t.discover.icon.unselected"
    }
    
    private var hideBottomBar: Bool {
        return route == .discover(.Map) ||
               route == .tutorial
    }

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Button(action: { navigate(to: .createTroov()) },
                   label: {
                TabBarIcon(currentRoute: .tutorial,
                           route: route,
                           width: size.width/5,
                           height: size.height/28)
            })
            .trackRUMTapAction(name: router.dataDogTapAction(named: TTabRoute.tutorial.dataDogScreenName))
            Button {
                route(to: .mytroovs)
            } label: {
                TabBarIcon(currentRoute: .mytroovs,
                           route: route,
                           width: size.width/5,
                           height: size.height/28)
            }
            .trackRUMTapAction(name: router.dataDogTapAction(named: TTabRoute.mytroovs.dataDogScreenName))
            Spacer()
            Button {
                route(to: .chatSessions)
            } label: {
                TabBarIcon(currentRoute: .chatSessions,
                           route: route,
                           width: size.width/5,
                           height: size.height/28)
            }
            .trackRUMTapAction(name: router.dataDogTapAction(named: TTabRoute.chatSessions.dataDogScreenName))
            Button {
                route(to: .myprofile)
            } label: {
                TabBarIcon(currentRoute: .myprofile,
                           route: route,
                           width: size.width/5,
                           height: size.height/28)
            }
            .trackRUMTapAction(name: router.dataDogTapAction(named: TTabRoute.myprofile.dataDogScreenName))
        }
        .background(backgroundShape)
        .frame(width: size.width,
               height: sizeHeight,
               alignment: .bottom)
        .shadow(color: Color(red: 0.77, green: 0.7, blue: 0.52).opacity(0.36), radius: 15, x: 0, y: -9)
        .overlay(alignment: .top) {
                TDiscoverMapButton(icon: centralIcon)
                    .animation(.none, value: centralIcon)
                    .onTapGesture {
                        mapButtonAction(tabRoute: selectRouterForCentralButton())
                    }.offset(y: -26)
                .trackRUMTapAction(name: router.dataDogTapAction(named: selectRouterForCentralButton().dataDogScreenName))
        }.offset(y: hideBottomBar ? sizeHeight + 26: 0)
         .animation(.smooth, value: hideBottomBar)
         .onChange(of: route) { _, newValue in
             router.routeToApp(cycle: .tab, tab: newValue)
         }.onChange(of: router.appTab) { _, newValue in
             route(to: newValue)
         }
    }

    private func selectRouterForCentralButton() -> TTabRoute {
        if route == .discover(.List) {
            return .discover(.Map)
        } else {
            return .discover(.List)
        }
    }

    @MainActor private func mapButtonAction(tabRoute: TTabRoute) {
        route(to: tabRoute)
    }
}

struct ITTabView_Previews: PreviewProvider {
    static var previews: some View {
        ITTabView(size: .zero)
    }
}

extension ITTabView {
    @MainActor private func route(to tab: TTabRoute) {
        if route != tab {
            route = tab
        }
    }

    @MainActor private func navigate(to path: TRouter.NavigationPath) {
        if router.registrationStep == .doItLaterOption {
            router.present(.completeRegistrationView(.createTroov))
        } else {
            router.navigateTo(path)
        }
    }
}
