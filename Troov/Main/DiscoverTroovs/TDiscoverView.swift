//
//  TDiscoverView.swift
//  Troov
//
//  Created by Leo on 10.02.23.
//

import SwiftUI

struct TDiscoverView: View {
    @Environment(TRouter.self) var router: TRouter
    @Environment(DiscoverViewModel.self) var discoverViewModel
    
    @State private var declinedLocationInfoPopoverIsShowing = false
    
    private let horizontalPadding: CGFloat = 10
    
    private var troovs: [ExtendedTroov] {
        discoverViewModel.extendedTroovs
    }
    
    let searchText: String
    let locationStatus: LocationManager.LocationAutorizationStatus
    
    private var troovsAreLoading: Bool {
        discoverViewModel.troovsAreLoading
    }
    
    private var numberOfTroovs: Int {
        if searchText.isClean {
            return discoverViewModel.numTroovsFound ?? 0
        } else {
            return discoverViewModel.extendedTroovs.count
        }
    }
    
    @State private var scrollPosition: String?
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .center,
                       spacing: 0) {
                    HStack(alignment: .center) {
                        Text("\(numberOfTroovs)")
                            .fontWithLineHeight(font: .poppins600(size: 18),
                                                lineHeight: 18)
                            .foregroundColor(.primaryTroovColor)
                        Text("Troovs found")
                            .fontWithLineHeight(font: .poppins400(size: 14),
                                                lineHeight: 14)
                            .foregroundStyle(Color.rgba(51, 51, 51, 1))
                        Spacer()
                        if case .declined = locationStatus {
                            Image(systemName: "location.slash")
                                .imageScale(.large)
                                .foregroundStyle(Color.primaryTroovColor)
                                .padding(.trailing, 5)
                                .onTapGesture {
                                    declinedLocationInfoPopoverIsShowing.toggle()
                                }
                                .popover(isPresented: $declinedLocationInfoPopoverIsShowing) {
                                    LocationManager.AllowLocationPopover()
                                        .frame(minHeight: 80)
                                        .presentationBackground(content: {
                                            Color.primaryTroovColor.opacity(0.08)
                                        })
                                        .presentationCornerRadius(15)
                                        .presentationCompactAdaptation(.popover)
                                }
                        }
                        Button(action: { sortedByAction() }) {
                            TPrimaryLabel(text: "Sort by",
                                          height: 28,
                                          font: .poppins500(size: 12))
                            .frame(width: 63)
                        }
                        .buttonStyle(.scalable)
                        .padding(.trailing, 8)
                        .trackRUMTapAction(name: router.dataDogTapAction(named: "Sort Troovs By"))
                        @Bindable var discoverViewModel = discoverViewModel
                        TToggleView(isOn: $discoverViewModel.isBig)
                            .frame(width: 72,
                                   height: 38)
                    }
                }.padding(.horizontal, horizontalPadding)
                    .padding(.vertical, 16)
                VStack(spacing: 12) {
                    ForEach(troovs, id: \.troovId) { troov in
                        TTroovCell(troov: troov.element2,
                                   isExpanded: troov.isExpanded,
                                   isOwn: troov.isOwn,
                                   expand: {
                            expandFromSmallCell(troov.element2)
                            withAnimation(.default.delay(0.5)) {
                                scrollPosition = troov.troovId
                            }
                        },
                                   seeDetails: {
                            show(troov: troov.element2)
                        },
                                   showLocation: { item in showLocation(for: item) },
                                   request: {
                            request(troov.element2)
                        })
                        .id(troov.troovId)
                        .onAppear { cellAppeared(with: troov.troovId) }
                    }
                    if troovs.count == 0 {
                        if troovsAreLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                        } else {
                            Placeholder(headline: "Could not find any troovs with your filter settings",
                                        subHeadline: nil,
                                        hashtags: nil,
                                        rightButtonTitle: "Change Filters",
                                        rightButtonAction: { router.present(.filters) })
                            .padding([.horizontal, .bottom], 17)
                            .padding(.top, 10)
                            .trackRUMTapAction(name: router.dataDogTapAction(named: "Change Filters"))
                        }
                    }
                }.scrollTargetLayout()
            }.padding(.bottom, CGFloat.tabBarHeight)
        }
        .scrollPosition(id: $scrollPosition, anchor: .zero)
        .refreshable(action: {
            if !searchText.isClean {
                Task { await discoverViewModel.searchByTerm(term: searchText) }
            } else {
                discoverViewModel.tryToFetchTroovs()
            }
        })
        .onChange(of: discoverViewModel.isBig, { _, newValue in
            Task {
                try await Task.sleep(nanoseconds: 5_000_000_00)
                discoverViewModel.expandAllTroovs(!newValue)
            }
        })
    }
    
    @MainActor private func show(troov: Troov) {
        discoverViewModel.setCurrentTroov(troov)
        let troovs = discoverViewModel.troovs
        router.navigateTo(.discoverPages(troovId: troov.id, troovs: troovs))
    }
    
    @MainActor private func showLocation(for troov: Troov) {
        discoverViewModel.setCurrentTroov(troov, refreshMap: true)
        router.routeToApp(cycle: .tab, tab: .discover(.Map))
    }

    @MainActor private func request(_ troov: Troov) {
        discoverViewModel.setCurrentTroov(troov)
        if router.registrationStep == .doItLaterOption {
            router.present(.completeRegistrationView(.joinRequest))
        } else {
            router.present(.addChatSession(troov: troov))
        }
    }
    
    private func expandFromSmallCell(_ troov: Troov) {
        discoverViewModel.epxandTroov(id: troov.troovId)
    }

    private func cellAppeared(with troovId: String?) {
        guard searchText.isClean else { return }
        discoverViewModel.tryToFetchTroovs(troovId: troovId,
                                           refresh: false)
    }

    @MainActor private func sortedByAction() {
        router.present(.sortedBy)
    }
}

struct TDiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        TDiscoverView(searchText: "",
                      locationStatus: .none)
    }
}

extension TDiscoverView {
    struct SortedByBody: View {
        let applySelectedOrder: () -> ()

        @Environment(\.dismiss) private var dismiss
        @Environment(TRouter.self) var router

        @State private var filterSettings: DiscoverFilterSettings?
        
        private var order: PaginationOrder? {
            filterSettings?.paginationOrder
        }
            
        private let allOrders = PaginationOrder.allCases
    
        var body: some View {
            VStack(alignment: .leading,
                   spacing: 0) {
                Text("Sorted By")
                    .fontWithLineHeight(font: .poppins500(size: 16), lineHeight: 24)
                    .foregroundStyle(Color.primaryBlack)
                VStack(alignment: .center, spacing: 14) {
                    ForEach(allOrders, id: \.self) { order in
                        Button(action: { select(order: order) }) {
                            Item(order: order, isSelected: self.order == order)
                        }
                    }
                }.padding(.top, 24)
                GeometryReader { proxy in
                    HStack(alignment: .center, spacing: 16) {
                        Button(action: { apply() }) {
                            TPrimaryLabel(text: "Apply")
                        }.buttonStyle(.scalable)
                            .frame(width: proxy.size.width / 1.7)
                            .trackRUMTapAction(name: router.dataDogTapAction(named: applyDataDogActionName))
                        Button(action: { clear() }) {
                            TSecondaryLabel(text: "Cancel")
                        }.buttonStyle(.scalable)
                            .trackRUMTapAction(name: router.dataDogTapAction(named: cancelDataDogActionName))
                    }.padding(.horizontal, 4)
                }.padding(.top, 48)
            }.padding(.horizontal, 16)
            .padding(.top, 24)
            .task { await self.assignFilterSettingsState() }
        }
    
        @MainActor private func assignFilterSettingsState() async {
           self.filterSettings = await SearchFilters.shared.fetchSettings()?.element2
        }
        
        private func select(order: PaginationOrder) {
            Task {
                await SearchFilters.shared.update(paginationOrder: order)
                await self.assignFilterSettingsState()
            }
        }

        @MainActor private func apply() {
            applySelectedOrder()
            dismiss()
        }

        @MainActor private func clear() {
            Task {
                await SearchFilters.shared.update(paginationOrder: .startTime)
                dismiss()
            }
        }

        private var applyDataDogActionName: String {
            "Apply " + (order?.rawValue.cleanEnums ?? PaginationOrder.startTime.rawValue.cleanEnums)
        }

        private var cancelDataDogActionName: String {
            "Cancel " + (order?.rawValue.cleanEnums ?? PaginationOrder.startTime.rawValue.cleanEnums)
        }
    }
}

extension TDiscoverView.SortedByBody {
    struct Item: View {
        let order: PaginationOrder
        let isSelected: Bool

        var body: some View {
            HStack {
                Text(order.rawValue.cleanEnums)
                    .fontWithLineHeight(font: .poppins400(size: 14), lineHeight: 21)
                    .foregroundStyle(Color.primaryBlack)
                Spacer()
                if isSelected {
                    Image("t.checkmark")
                        .renderingMode(.template)
                        .foregroundStyle(Color.primaryTroovColor)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background {
                if isSelected {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.primaryTroovColor.opacity(0.15))
                }
            }
        }
    }
}
