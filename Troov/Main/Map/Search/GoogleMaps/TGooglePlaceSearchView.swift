//
//  TGooglePlaceSearchView.swift
//  mango
//
//  Created by Leo on 23.04.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI
import CoreLocation.CLLocation
import MapKit.MKAnnotationView
import MapKit.MKUserLocation
import GooglePlaces

struct TGooglePlaceSearchView: View {
    @State private var locations: [TLocation] = []
    @StateObject private var viewModel = TGooglePlaceSearchViewModel()
    @Binding var hide: Bool
    @Binding var choosenLocationName: String
    @Binding var location: String
    @Binding var latitude: Double
    @Binding var longitude: Double
    @State private var region = MKCoordinateRegion(center: .init(),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                                          longitudeDelta: 0.01))
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Map(coordinateRegion: $region,
                    showsUserLocation: true,
                    annotationItems: locations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        Image("t.map.location")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 33,
                                   height: 33)
                    }
                }
                TGoogleMapSearchVersion1(beginSearching: self.$viewModel.beginSearching,
                                         pickedPlace: self.$viewModel.pickedPlace)
                    .frame(height: self.viewModel.beginSearching ? 250 : 58)
            }.onAppear(perform: {
                if let place = self.viewModel.pickedPlace {
                    locations.append(.init(name: place.name ?? "",
                                           coordinate: place.coordinate))
                }
            })
            .onReceive(self.viewModel.$pickedPlace, perform: { place in
                if let place = place {
                    locations.append(.init(name: place.name ?? "",
                                           coordinate: place.coordinate))
                }
            })
            .navigationBarTitle(Text("Choose the location"), displayMode: .inline)
             .navigationBarItems(trailing: Button(action: {
                if let place = self.viewModel.pickedPlace,
                   let name = place.name {
                    self.choosenLocationName = name
                    self.location = name
                    self.latitude = place.coordinate.latitude
                    self.longitude = place.coordinate.longitude
                    withAnimation {
                        self.hide.toggle()
                    }
                }
            }, label: {
                Image(systemName: "checkmark")
                    .foregroundColor(.primaryTroovColor)
                    .opacity(self.viewModel.pickedPlace != nil ? 1 : 0)
            }))
      }
    }
}

struct TGooglePlaceSearchView_Previews: PreviewProvider {
    static var previews: some View {
        TGooglePlaceSearchView(hide: .constant(false),
                               choosenLocationName: .constant(""),
                               location: .constant(""),
                               latitude: .constant(0.0),
                               longitude: .constant(0.0))
    }
}

class TGooglePlaceSearchViewModel: ObservableObject {
    @Published var beginSearching = false
    @Published var pickedPlace: GMSPlace?
}
