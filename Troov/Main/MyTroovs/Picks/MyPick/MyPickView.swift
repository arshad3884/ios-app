//
//  MyPickView.swift
//  mango
//
//  Created by Leo on 12.03.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct MyPickView: View {
    @Environment(MyTroovsViewModel.self) var myTroovsViewModel
    @Environment(TRouter.self) var router

    @State private var presentPickDetail: Bool = false
    @State private var showMyPicksWarning: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                ForEach(myTroovsViewModel.myPicks, id: \.id) { pickSection in
                    VStack(spacing: 0) {
                        Section(header: PickSectionHeaderView(imageName: "t.calendar",
                                                              title: pickSection.day)) {
                            ForEach(pickSection.troovs,
                                    id: \.troovId) { troov in
                                MyPickCell(troov: troov,
                                           cancelMyTroov: { cancelMyTroov($0) },
                                           editMyTroov: { editCreateMyTroov($0) },
                                           interested: { select($0) })
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
            }.padding(.top, 10)
                .padding(.bottom, CGFloat.tabBarHeight)
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity)
                .overlay(alignment: .top, content: {
                    if myTroovsViewModel.myPicks.count == 0 {
                        Placeholder(headline: "Create your own adventure!",
                                    subHeadline: "Need ideas? Here are some trending activity tags:",
                                    hashtags: ["Standup Comedy", "Socials",
                                               "Friendship", "Adventure", "Family Oriented"],
                                    image: "t.rocket",
                                    rightButtonAction: { editCreateMyTroov() })
                        .padding(.bottom, 17)
                        .padding(.horizontal, 10)
                        .padding(.top, 20)
                    }
                })
        }
        .refreshable(action: {
            Task {
                await myTroovsViewModel.fetchOwnTroovs()
            }
        })
        .overlay {
            if showMyPicksWarning {
                ClassicPopover(title: "Cancel This Troov?",
                               approveTitle: "Yes",
                               resignTitle: "No",
                               height: 150,
                               acceptancePriority: .low,
                               showPicker: $showMyPicksWarning) {
                    myTroovsViewModel.cancelMyTroov()
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .fullScreenCover(isPresented: $presentPickDetail,
               content: {
                PicksDetailView()
        })
    }
    
    @MainActor private func select(_ pick: Troov) {
        if pick.pendingMatchRequests?.isEmpty == false {
            myTroovsViewModel.setCurrentMyPick(pick)
            presentPickDetail.toggle()
        }
    }
    
    @MainActor private func cancelMyTroov(_ pick: Troov) {
        myTroovsViewModel.setCurrentMyPick(pick)
        showMyPicksWarning.toggle()
    }

    @MainActor private func editCreateMyTroov(_ troov: Troov? = nil) {
        if router.registrationStep == .doItLaterOption {
            router.present(.completeRegistrationView(.createTroov))
        } else {
            router.navigateTo(.createTroov(troov: troov))
        }
    }
}

struct MyPickView_Previews: PreviewProvider {
    static var previews: some View {
        MyPickView()
    }
}
