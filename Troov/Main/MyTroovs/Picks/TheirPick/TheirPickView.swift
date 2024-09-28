//
//  TheirPickView.swift
//  mango
//
//  Created by Leo on 19.02.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct TheirPickView: View, AppProtocol {
    @Environment(TRouter.self) var router: TRouter
    @Environment(MyTroovsViewModel.self) var myTroovsViewModel
    @Environment(DiscoverViewModel.self) var discoverViewModel

    @State private var cancelPickWarning = false
    @State private var currentTroov: Troov?
    
    private var theirPicks: [PickSection] {
        myTroovsViewModel.theirPicks
    }
    
    private var userId: String {
        myTroovsViewModel.userId
    }

    private var offeredTroovsForConfirmedTroovTab: [ExtendedTroov] {
        discoverViewModel.offeredTroovsForConfirmedTroovTab
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                if theirPicks.count > 0 {
                    ForEach(theirPicks, id: \.id) { pickSection in
                        VStack(spacing: 0) {
                            Section(header: PickSectionHeaderView(imageName: "t.calendar",
                                                                  title: pickSection.day)) {
                                ForEach(pickSection.troovs,
                                        id: \.troovId) { troov in
                                    TheirPickCell(troov: troov,
                                                  userId: userId,
                                                  removePick: removeTheirRequest(_:))
                                    .id(troov.troovId)
                                    .padding(.horizontal, 2)
                                    .onTapGesture {
                                        navigate(to: troov)
                                    }
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
                        Placeholder(headline: "Ready to mingle?",
                                    subHeadline: "Request to join a troov on the Discover tab!",
                                    image: "t.celebrate",
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
        }.refreshable(action: {
            Task {
                await myTroovsViewModel.fetchTheirTroovs()
            }
        })
            .overlay {
                if let troov = currentTroov, cancelPickWarning {
                    ClassicPopover(title: "Cancel your request to join?",
                                   approveTitle: "Yes",
                                   resignTitle: "No",
                                   height: 150,
                                   acceptancePriority: .low,
                                   showPicker: $cancelPickWarning) {
                        removeTheirTroov(troov)
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
    }
    
   @MainActor private func navigate(to troov: Troov) {
       router.navigateTo(.discover(troov: troov))
    }
    
    private func removeTheirRequest(_ troov: Troov) {
        currentTroov = troov
        withAnimation {
            cancelPickWarning.toggle()
        }
    }

    private func removeTheirTroov(_ troov: Troov) {
        DispatchQueue.main.async {
            myTroovsViewModel.deleteTheir(pick: troov)
        }
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

struct TheirPickView_Previews: PreviewProvider {
    static var previews: some View {
        TheirPickView()
    }
}
