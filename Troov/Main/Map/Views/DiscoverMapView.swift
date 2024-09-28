//
//  DiscoverMapView.swift
//  mango
//
//  Created by Leo on 11.02.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI
import CoreLocation.CLLocation
import MapKit.MKAnnotationView
import MapKit.MKUserLocation

struct DiscoverMapView: View {
    @Environment(DiscoverViewModel.self) var discoverViewModel
    @Environment(TRouter.self) var router: TRouter
    
    @State private var position: MapCameraPosition = .userLocation(followsHeading: false, fallback: .automatic)
    @State private var currentTroovId: String?
    @State private var cameraPositionChanged: Bool = false
    @State private var region: MKCoordinateRegion?
    @State private var cameraOriginalRegion: MKCoordinateRegion?
    @State private var cameraRadius: CLLocationDistance?
    @State private var cameraCoordinate: CLLocationCoordinate2D?
    @State private var cameraRectangle: MKMapRect?
    @State private var span: MKCoordinateSpan?
    @State private var heading: Double?

    @State private var showSearchArea: Bool = false

    private var troovs: [Troov] {
        discoverViewModel.sortedByCoordinatesTroovs
    }
    
    private var mapIsVisible: Bool {
        router.appTab == .discover(.Map)
    }
    
    private var currentTroov: Troov? {
        discoverViewModel.currentTroov
    }

    private var searchAreaCoordinates: CLLocationCoordinate2D? {
        if let coordinateCenter = position.camera?.centerCoordinate ?? position.region?.center ?? cameraCoordinate,
           let span = span,
           let heading = heading {
            return span.rotatedOffsetCentroid(center: coordinateCenter,
                                              span: span,
                                              rotationAngleRadians: heading * .pi / 180,
                                              northSouthOffsetProportion: 0.105)
        } else {
            return nil
        }
    }
    
    /* 1 mile == 1609.34 meters*/
    private let mapBounds = MapCameraBounds(minimumDistance: 2500,
                                            maximumDistance: 12000000)
    
    
    var body: some View {
        Map(position: $position,
            bounds: mapBounds,
            interactionModes: [.zoom, .pan, .pitch],
            selection: $currentTroovId) {
            if showSearchArea {
                MapCircle(center: searchAreaCoordinates ?? CLLocationCoordinate2D.austin,
                          radius: cameraRadius ?? CLLocationDistance(TroovCoreDetailFilterAttributesMaximumDistance.allowedLocalMax))
                     .foregroundStyle(Color.primaryTroovColor.opacity(0.4))
                     .mapOverlayLevel(level: .aboveRoads)
            }
            ForEach(troovs, id: \.id) { troov in
                Marker(coordinate: troov.coordinate2DHiddenAndVisible) {
                    if let mapPin = troov.locationDetails?.mapPin {
                        Image(mapPin)
                    }
                }.tint(Color.primaryTroovColor)
                    .tag(troov.id)
            }
        }
            .animation(.bouncy, value: currentTroovId)
            .mapStyle(.standard(pointsOfInterest: .including([.publicTransport,
                                                              .airport,
                                                              .amusementPark,
                                                              .aquarium,
                                                              .bakery,
                                                              .hotel,
                                                              .cafe,
                                                              .restaurant,
                                                              .park,
                                                              .parking,
                                                              .nationalPark])))
            .mapControls {
                MapCompass()
                    .controlSize(.mini)
                    .mapControlVisibility(.visible)
                MapPitchToggle()
                    .controlSize(.mini)
                    .mapControlVisibility(.visible)
                MapScaleView(anchorEdge: .leading)
                    .controlSize(.mini)
                    .mapControlVisibility(.visible)
                MapUserLocationButton()
                    .controlSize(.mini)
                    .mapControlVisibility(.visible)
            }
            .tint(Color.primaryTroovColor)
            .overlay(alignment: .bottom) {
                VStack(alignment: .trailing,
                           spacing: 0) {
                    if troovs.count > 0 {
                        Button(action: { exit() }) {
                            TDiscoverMapButton(icon: "t.map.exit.grid")
                        }.buttonStyle(.scalable)
                            .padding([.trailing, .bottom], 10)
                    }
                    PageView(pages: troovs,
                             positionId: $currentTroovId,
                             configuration: sliderConfiguration) { troov in
                        TTroovMapCell(troov: troov,
                                      userId: discoverViewModel.userId,
                                      openChatSession: { openChatSession($0) })
                        .onTapGesture(perform: { navigateToDiscoverPages(troov)})
                    }.animation(.bouncy, value: currentTroovId)
                        .safeAreaPadding(.horizontal, sliderConfiguration.sliderHorizontalEdgesVisibleSize)
                }
            }
            .overlay(alignment: .bottomTrailing, content: {
                if troovs.count == 0 {
                    VStack(alignment: .trailing) {
                        Button(action: { exit() }) {
                            TDiscoverMapButton(icon: "t.map.exit.grid")
                        }
                        .buttonStyle(.scalable)
                        .padding([.trailing, .bottom], 10)
                        .trackRUMTapAction(name: router.dataDogTapAction(named: TTabRoute.discover(.List).dataDogScreenName))
                        Placeholder(headline: "No troovs found in area",
                                    subHeadline: nil,
                                    hashtags: nil,
                                    rightButtonTitle: "Change Filters",
                                    fillColor: .white,
                                    image: nil,
                                    rightButtonAction: { router.present(.filters) })
                        .padding(.bottom, 10)
                        .padding(.horizontal, 10)
                    }
                }
            })
            .overlay(alignment: .top, content: {
                if cameraPositionChanged {
                    Button(action: research) {
                        TTertiaryLabel(text: "Search in this area",
                                       height: 38,
                                       fontSize: 15)
                    }.buttonStyle(.scalable)
                     .frame(width: 230)
                     .padding(.top, 35)
                    .trackRUMTapAction(name: router.dataDogTapAction(named: "Search In This Area"))

                }
            })
            .overlay(alignment: .topLeading, content: {
                Button(action: { showSearchArea.toggle() }) {
                    Image(systemName: showSearchArea ? "circle.circle.fill" : "circle.slash")
                        .imageScale(.large)
                        .foregroundStyle(Color.primaryTroovColor)
                        .padding(5)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Material.regular)
                        }
                }.buttonStyle(.scalable)
                 .padding(.top, 35)
                 .padding(.leading, 15)
                 .trackRUMTapAction(name: router.dataDogTapAction(named: "Show Map Circle Search Area"))

            })
            .onChange(of: discoverViewModel.updateCurrentTroovsOnMap, { oldValue, newValue in
                setupCurrentTroovId()
            })
            .onChange(of: discoverViewModel.positionCamera, { _, _ in
                positionCamera()
            })
            .onChange(of: mapIsVisible, { _, _ in
                if currentTroovId == nil {
                    setupCurrentTroovId()
                }
            })
            .onChange(of: discoverViewModel.setNilCurrentTroovId) { _, _ in
                currentTroovId = nil
            }
            .onChange(of: currentTroovId, { _, newValue in
                guard let rect = cameraRectangle,
                      let region = cameraOriginalRegion,
                      let troov = troovs.first(where: {$0.troovId == newValue}) else { return }
                
                let location = troov.coordinate2DHiddenAndVisible
                guard !rect.contains(coordinate: location) else { return }
                /**
                 Current troov is out of camera rectangle area
                 */
                
                let newRegion = MKCoordinateRegion(center: location, span: region.span)
                
                withAnimation(.smooth(duration: 0.2)) {
                    self.position = .region(newRegion)
                }
                self.region = newRegion
                self.cameraOriginalRegion = newRegion
                self.span = newRegion.span
            })
            .onMapCameraChange(frequency: .continuous, { context in
                let contextRegion = context.region
                let heading = context.camera.heading
                self.heading = heading

                let radius = contextRegion.radius(heading: heading)
                if radius != 0 {
                    cameraRadius = radius
                    cameraCoordinate = contextRegion.center
                    span = contextRegion.span
                }
            })
            .onMapCameraChange(frequency: .onEnd,
                               { context in
                let heading = context.camera.heading
                
                self.heading = heading
                
                let contextRegion = context.region
                let radius = contextRegion.radius(heading: heading)
                if radius != 0 {
                    cameraRadius = radius
                } else {
                    cameraRadius = CLLocationDistance(TroovCoreDetailFilterAttributesMaximumDistance.allowedLocalMax)
                }
                
                cameraCoordinate = contextRegion.center
                
                cameraOriginalRegion = contextRegion
                
                cameraRectangle = context.rect
                
                span = contextRegion.span
                
                if let region = self.region {
                    if !contextRegion.isEqual(region: region) {
                        withAnimation(.bouncy) {
                            cameraPositionChanged = true
                        }
                    } else {
                        withAnimation(.bouncy) {
                            cameraPositionChanged = false
                        }
                    }
                }
            })
            .onAppear {
                positionCamera()
            }
    }
    
    private func research() {
        cameraPositionChanged = false
        if let cameraRadius = cameraRadius,
           let searchAreaCoordinates = searchAreaCoordinates {
            Task {
                await SearchFilters.shared.update(distance: cameraRadius.miles,
                                                  coordinates: searchAreaCoordinates)
                discoverViewModel.tryToFetchTroovs(setCurrentTroov: true,
                                                   positionCamera: false,
                                                   refresh: true)
            }
        }
    }
    
    private func positionCamera() {
        Task {
            guard let region = await SearchFilters.shared.cameraRegion() else { return }
            withAnimation {
                self.region = region
                self.position = .region(region)
            }
        }
    }
    
    @MainActor private func navigateToDiscoverPages(_ troov: Troov) {
        discoverViewModel.setCurrentTroov(troov)
        let troovs = discoverViewModel.troovs
        router.navigateTo(.discoverPages(troovId: troov.id, troovs: troovs))
    }
    
    @MainActor private func openChatSession(_ troov: Troov) {
        discoverViewModel.setCurrentTroov(troov)
        if currentTroov != nil {
            if router.registrationStep == .doItLaterOption {
                router.present(.completeRegistrationView(.joinRequest))
            } else {
                router.present(.addChatSession(troov: troov))
            }
        }
    }
    
    @MainActor private func exit() {
        router.routeToApp(cycle: .tab, tab: .discover(.List))
    }
    
    private func setupCurrentTroovId() {
        guard mapIsVisible else { return }
        if let currentTroov = currentTroov {
            currentTroovId = currentTroov.troovId
        } else if currentTroovId == nil,
                  let firstTroovId = troovs.first?.troovId {
            currentTroovId = firstTroovId
        } else if troovs.count == 0 {
            currentTroovId = nil
        }
    }
}

struct DiscoverMapView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverMapView()
    }
}


fileprivate extension DiscoverMapView {
    private var sliderConfiguration: PageViewConfiguration {
        PageViewConfiguration(sliderInteritemSpacing: 11,
                              vAlignment: .center,
                              allowScalling: true)
    }
}
