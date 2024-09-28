//
//  TDiscoverContainerView.swift
//  Troov
//
//  Created by Leo on 17.02.23.
//

import SwiftUI

struct TDiscoverContainerView: View {
    @Environment(TRouter.self) var router: TRouter
    @Environment(DiscoverViewModel.self) var discoverViewModel

    let locationStatus: LocationManager.LocationAutorizationStatus

    @State private var isSearching = false
    @State private var textFieldIsFocused: Bool = false
    @State private var searchTriggred: Bool = false
    @State private var searchText: String = ""
    @State private var keyboardIsOn: Bool = false
    @State private var keyboardHeight: CGFloat = 0

    private var mapIsVisible: Bool {
        router.appTab == .discover(.Map)
    }

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                DiscoverTopToolbarView(isSearching: $isSearching,
                                       textFieldIsFocused: $textFieldIsFocused,
                                       searchTriggred: $searchTriggred,
                                       searchText: $searchText)  
                ZStack {
                    DiscoverMapView()
                        .opacity(mapIsVisible ? 1 : 0.0)
                        .animation(.smooth(duration: 0.5), value: mapIsVisible)
                        .disabled(!mapIsVisible)
                    TDiscoverView(searchText: searchText,
                                  locationStatus: locationStatus)
                    .background(Color.white)
                    .disabled(mapIsVisible)
                    .animation(.smooth(duration: 0.5), value: mapIsVisible)
                    .offset(y: mapIsVisible ? proxy.size.height - CGFloat.navigationBarHeight + 40 : 0.0)
                }
                .overlay(alignment: .top) {
                        if isSearching && textFieldIsFocused {
                            DiscoverSearchView(searchTriggred: searchTriggred,
                                               searchText: $searchText)
                            .contentTransition(.opacity)
                            .zIndex(1)
                        }
                }
                /**
                 TODO: - adjust keyboard related codes here
                 */
                .onAppear {
                     NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                         let keyWindow = UIApplication.shared.connectedScenes
                             .filter({$0.activationState == .foregroundActive})
                             .map({$0 as? UIWindowScene})
                             .compactMap({$0})
                             .first?.windows
                             .filter({$0.isKeyWindow}).first
                         let bottom = keyWindow?.safeAreaInsets.bottom ?? 0
                         let value = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                         let height = value.height
                         let newValue = height - bottom
                         DispatchQueue.main.async {
                             if keyboardHeight != newValue {
                                 withAnimation {
                                     keyboardHeight = newValue/2
                                 }
                             }
                         }
                     }

                     NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                         DispatchQueue.main.async {
                             if keyboardHeight != 0 {
                                 withAnimation {
                                     keyboardHeight = 0
                                 }
                             }
                         }
                     }
                 }
                 .onDisappear {
                     NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                     NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
                 }
            }.offset(y: keyboardHeight)
        }
    }
}

struct TDiscoverContainerView_Previews: PreviewProvider {
    static var previews: some View {
        TDiscoverContainerView(locationStatus: .none)
    }
}
