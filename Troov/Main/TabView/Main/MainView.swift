//
//  MainView.swift
//  mango
//
//  Created by Leo on 17.01.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(TRouter.self) var router: TRouter
    @State private var discoverViewModel = DiscoverViewModel()
    @State private var chatViewModel = ChatViewModel()
    @State private var myTroovsViewModel = MyTroovsViewModel()
    @State private var initiatedMainTask = false
    private var locationManager = LocationManager()

    private let notifyService = TNotifyService()

    var body: some View {
        NavigationStack {
            @Bindable var router = router
            LazyVStack(alignment: .center,
                   spacing: 0) {
                switch router.appTab {
                case .mytroovs:
                    MyTroovsView()
                        .trackRUMView(name: router.dataDogScreenName())
                        .containerRelativeFrame(.vertical)
                        .environment(chatViewModel)
                        .environment(myTroovsViewModel)
                        .environment(discoverViewModel)
                case .discover, .tutorial:
                    TDiscoverContainerView(locationStatus: locationManager.autorizationStatus)
                        .trackRUMView(name: router.dataDogScreenName())
                        .containerRelativeFrame(.vertical)
                        .environment(discoverViewModel)
                case .chatSessions:
                    ChatSessionsView()
                        .trackRUMView(name: router.dataDogScreenName())
                        .containerRelativeFrame(.vertical)
                        .environment(chatViewModel)
                        .environment(myTroovsViewModel)
                        .environment(router)
                case .myprofile:
                    ProfileView(logout: logout)
                        .trackRUMView(name: router.dataDogScreenName())
                        .containerRelativeFrame(.vertical)
                }
            }.toolbar(.hidden, for: .navigationBar)
             .navigationDestination(item: $router.navigationPath,
                                    destination: { path in
                    switch path {
                    case .createTroov(troov: let troov):
                        CreateTroovView(troov: troov)
                            .environment(myTroovsViewModel)
                            .navigationBarBackButtonHidden()
                            .trackRUMView(name: router.dataDogScreenName())
                    case .discoverPages(troovId: let troovId, troovs: let troovs):
                        TroovDetailsPageView(troovId: troovId, troovs: troovs)
                            .environment(discoverViewModel)
                            .environment(myTroovsViewModel)
                            .trackRUMView(name: router.dataDogScreenName())
                    case .chat:
                        ChatView()
                         .environment(chatViewModel)
                         .environment(discoverViewModel)
                         .trackRUMView(name: router.dataDogScreenName())
                    case .adminChat:
                        AdminChatView()
                            .environment(chatViewModel)
                            .environment(discoverViewModel)
                            .trackRUMView(name: router.dataDogScreenName())
                    case .discover(troov: let troov):
                        TroovDetailsContainerView(troov: troov)
                            .environment(discoverViewModel)
                            .trackRUMView(name: router.dataDogScreenName())
                    }
                })
             .sheet(item: $router.presentationPath, content: { path in
                 switch path {
                 case .filters:
                     SearchFiltersView(applyFilters: {
                         if router.appTab == .discover(.Map) {
                             fetchDiscoverTroovs(setCurrentTroov: true,
                                                 paginationOrder: .distance)
                         } else {
                             fetchDiscoverTroovs()
                         }
                     })
                         .presentationCornerRadius(24)
                 case .addChatSession(let troov):
                     AddChatSessionSheetView(troov: troov,
                                             success: { deleteTroov($0) })
                     .environment(myTroovsViewModel)
                 case .event(let troov):
                     TEventGenerator(isShowing: Binding(get: {
                         false
                     }, set: { _ in
                        router.presentationPath = nil
                     }),
                                     troov: troov)
                     .ignoresSafeArea(edges: .bottom)
                 case .profile(let item):
                     NavigationStack {
                         ProfileEditView(menuItem: item)
                             .navigationBarTitleDisplayMode(.inline)
                             .navigationBarBackButtonHidden(true)
                     }.presentationDetents([.fraction(item.fraction)])
                      .presentationDragIndicator(.visible)
                      .presentationCornerRadius(24)
                 case .sortedBy:
                     TDiscoverView.SortedByBody(applySelectedOrder: { fetchDiscoverTroovs() })
                         .presentationDetents([.height(280)])
                         .presentationDragIndicator(.visible)
                         .presentationCornerRadius(24)
                 case .completeRegistrationView(let step):
                     CompleteRegistrationView(step: step)
                         .presentationDetents([.height(350)])
                         .presentationDragIndicator(.visible)
                         .presentationCornerRadius(24)
                 }
             })
              .overlay(alignment: .bottom) {
                       GeometryReader { proxy in
                           VStack(spacing: 0) {
                               Spacer()
                               ITTabView(size: proxy.frame(in: .global).size)
                           }
                       }.ignoresSafeArea(edges: .bottom)
              }.overlay(alignment: .bottom) {
                  if router.appTab == .tutorial {
                      GetStartedView()
                          .environment(router)
                          .transition(.move(edge: .bottom))
                  }
              }
        }
        .task {
            await mainTask()
        }
        .onChange(of: locationManager.autorizationStatus) { _, status in
            locationStatusChanged(status: status)
        }
        .onChange(of: router.preventPotentialInAppMemoryLeaks) { _, _ in preventPotentialInAppMemoryLeaks() }
    }

    /**
     Called after leaving the app's view in order to make sure the
     memory leak causing potential classes are safely cleaned up before
     */
    private func preventPotentialInAppMemoryLeaks() { notifyService.reset() }

    private func mainTask() async {
        guard !initiatedMainTask else { return }
        initiatedMainTask = true
        
        notifyService.notify(completion: notify(_:))
        
        if User.storedLocation == nil {
            locationManager.requestLocationAutorizationStatus()
            locationManager.startListeningUserLocationUpdates()
        }

        await fetchMyTroovs()
        await fetchChatSessions()
        fetchDiscoverTroovs()
    }

    private func locationStatusChanged(status: LocationManager.LocationAutorizationStatus) {
        DispatchQueue.main.async {
            fetchDiscoverTroovs()
        }
    }

    private func notify(_ notifications: [Notification]) {
        Task {
            var hasChatNotify = false
            for notification in notifications {
                if let type = notification.type {
                    debugPrint("=====>>>> notification: \(type), message: \(notification.message ?? "")")
                    switch type {
                    case .chatSupportAnnouncement, .chatRequest, .chatNewReply: 
                        hasChatNotify = true
                    case .discoverRefresh: fetchDiscoverTroovs()
                        /**
                         Pay attention to enhance this part in the future - We make a call to 3 endpoints per each notification, so it
                         would make sense to distinguish them
                         */
                    case .troovCancelled,
                         .troovJoinRequestCancelled,
                         .troovStartTimeChanged,
                         .troovConfirmed,
                         .troovNewJoinRequest:
                        hasChatNotify = true
                        await fetchMyTroovs()
                    }
                }
            }
        
            if hasChatNotify { await notifyChat() }
        }
    }
    
    private func notifyChat() async {
        await chatViewModel.resetUIContent(resetCurrentSession: false)
        await fetchChatSessions()
    }

    private func fetchDiscoverTroovs(setCurrentTroov: Bool = false,
                                     paginationOrder: PaginationOrder? = nil) {
        discoverViewModel.tryToFetchTroovs(setCurrentTroov: setCurrentTroov,
                                           paginationOrder: paginationOrder)
    }

    private func fetchMyTroovs() async {
        await myTroovsViewModel.fetchTroovs()
    }
    
    private func fetchChatSessions() async {
        let confirmedTroovs = myTroovsViewModel.confirmedTroovs
        let myTroovs = myTroovsViewModel.myTroovs
        let theirTroovs = myTroovsViewModel.theirTroovs

        await chatViewModel.fetchSessions(confirmedTroovs: confirmedTroovs,
                                          myTroovs: myTroovs,
                                          theirTroovs: theirTroovs)
        
    }
    
    
    @MainActor private func deleteTroov(_ troov: Troov) {
        discoverViewModel.remove(troov: troov, storeId: false)
    }

    /**
     Reset notification and updatedLocation listeners
     */
    private func logout() {
        notifyService.reset()        
        DispatchQueue.main.async {
            withAnimation {
                dismiss()
                router.logout()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.light)
    }
}
