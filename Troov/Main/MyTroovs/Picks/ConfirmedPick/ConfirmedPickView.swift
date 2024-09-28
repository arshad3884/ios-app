//
//  ConfirmedPickView.swift
//  mango
//
//  Created by Leo on 16.02.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct ConfirmedPickView: View {
    @Environment(MyTroovsViewModel.self) var myTroovsViewModel
    @Environment(TRouter.self) var router: TRouter
    @Environment(ChatViewModel.self) var chatViewModel
    @Environment(DiscoverViewModel.self) var discoverViewModel

    @State private var selectedTroov: Troov?
    @State private var showConfirmPicksWarning = false
    @State private var scrollPosition: String?

    private var offeredTroovsForConfirmedTroovTab: [ExtendedTroov] {
        discoverViewModel.offeredTroovsForConfirmedTroovTab
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                if myTroovsViewModel.confirmPicks.count > 0 {
                    ForEach(myTroovsViewModel.confirmPicks, id: \.id) { pickSection in
                        VStack(spacing: 0) {
                            Section(header: PickSectionHeaderView(imageName: "t.calendar",
                                                                  title: pickSection.day)) {
                                ForEach(pickSection.troovs,
                                        id: \.troovId) { troov in
                                    ConfirmedPickCell(troov: troov,
                                                      removeConfirmed: { removeConfirmedCalled($0) },
                                                      showEventCalled: { showEventCalled($0) },
                                                      selectTroov: { select($0) },
                                                      chat: { chat($0) })
                                    .id(troov.troovId)
                                    .padding(.horizontal, 2)
                                }
                            }.id(pickSection.id)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 10)
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.primaryTroovColor.opacity(0.1))
                        }
                    }
                } else {
                    VStack(alignment: .center,
                           spacing: 21) {
                        Placeholder(headline: "Time to make some plans!",
                                    subHeadline: "Explore the Discover tab or start your own troov.",
                                    rightButtonAction: { 
                            createTroov()
                        },
                                    leftButtonAction: {
                            withAnimation {
                                router.routeToApp(cycle: .tab, tab: .discover(.List))
                            }
                        })
                        .padding(.bottom, 17)
                        .padding(.horizontal, 10)
                        .padding(.top, 10)
                        if offeredTroovsForConfirmedTroovTab.count > 0 {
                            VStack(alignment: .leading,
                                   spacing: 10) {
                                Text("Checkout these nearby Troovs:")
                                    .fontWithLineHeight(font: .poppins500(size: 18), lineHeight: 27)
                                    .foregroundStyle(Color.primaryBlack)
                                    .padding(.leading, 10.0)
                                ForEach(offeredTroovsForConfirmedTroovTab, id: \.troovId) { troov in
                                    TTroovCell(troov: troov.element2,
                                               isExpanded: false,
                                               isOwn: false,
                                               expand: nil,
                                               seeDetails: {
                                        showDiscover(troov: troov.element2)
                                    },
                                               showLocation: { item in
                                        showDiscoverLocation(for: item)
                                    }, request: nil)
                                    .id(troov.troovId)
                                }
                            }.scrollTargetLayout()
                        }
                    }
                }
            }.padding(.top, 10)
             .padding(.bottom, CGFloat.tabBarHeight)
             .frame(maxWidth: .infinity,
                       maxHeight: .infinity)
        }.scrollPosition(id: $scrollPosition, anchor: .zero)
        .refreshable(action: {
            Task {
                await myTroovsViewModel.fetchConfirmedTroovs()
            }
        })
         .overlay(content: {
                if showConfirmPicksWarning {
                    ClassicPopover(title: "Cancel This Troov?",
                                   approveTitle: "Yes",
                                   resignTitle: "No",
                                   height: 150,
                                   acceptancePriority: .low,
                                   showPicker: $showConfirmPicksWarning) {
                        if let selectedTroov = selectedTroov {
                            myTroovsViewModel.deleteConfirmPick(pick: selectedTroov)
                        }
                    }.frame(maxWidth: .infinity,
                            maxHeight: .infinity)
                }
            })
    }

    @MainActor private func createTroov() {
        if router.registrationStep == .doItLaterOption {
            router.present(.completeRegistrationView(.createTroov))
        } else {
            router.navigateTo(.createTroov())
        }
    }
    
    @MainActor private func select(_ troov: Troov) {
        router.navigateTo(.discover(troov: troov))
    }
    
    @MainActor private func removeConfirmedCalled(_ troov: Troov) {
        selectedTroov = troov
        withAnimation {
            showConfirmPicksWarning = true
        }
    }
    
    @MainActor private func showEventCalled(_ troov: Troov) {
        router.present(.event(troov: troov))
    }
    
    @MainActor private func chat(_ troov: Troov) {
        let sessionId = chatViewModel.selectSession(for: troov)
        router.navigateTo(.chat(sessionId: sessionId))
    }
    
    /**
     Discover view model methods
     */
    @MainActor private func showDiscover(troov: Troov) {
        discoverViewModel.setCurrentTroov(troov)
        let troovs = discoverViewModel.troovs
        router.navigateTo(.discoverPages(troovId: troov.id, troovs: troovs))
    }
    
    @MainActor private func showDiscoverLocation(for troov: Troov) {
        discoverViewModel.setCurrentTroov(troov, refreshMap: true)
        router.routeToApp(cycle: .tab, tab: .discover(.Map))
    }
    
    private func expandFromSmallCell(_ troov: Troov) {
        discoverViewModel.epxandTroov(id: troov.troovId)
    }
}

struct ConfirmedPickView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmedPickView()
    }
}
