//
//  TroovDetailsScreen.swift
//  Troov
//
//  Created by Levon Arakelyan on 09.10.23.
//

import SwiftUI
import MapKit

struct TroovDetailsView: View {
    @Environment(DiscoverViewModel.self) var discoverViewModel

    let troov: Troov
    
    private let service = TUserService()
    
    @State private var snapshotImage: UIImage?
    @State private var currentLocation: CLLocation?
    
    private var relationshipInterestsKeyTags: [TTagTextField.KeyTag] {
        if let relationshipInterests = troov.troovCoreDetails?.relationshipInterests {
            return relationshipInterests.map({TTagTextField.KeyTag(tag: $0.generalUsageRawValue)})
        }
        return []
    }

    private var timeLeftIsCritical: (String, Bool) {
        return troov.expiresInIsCritical(userId: service.userId)
    }
    
    private var displayExpiration: Bool {
        (isOwnMatchRequest && troov.status == ._open)
    }
    
    private var isOwnMatchRequest: Bool  {
        return troov.matchRequests?.contains(where: {$0.requester?.userId == service.userId}) == true
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if displayExpiration {
                TPickTimeLabel(isCritical: timeLeftIsCritical.1,
                               text: timeLeftIsCritical.0)
                .padding(10)
            }
            GeometryReader { proxy in
                ScrollView(showsIndicators: false,
                           content: {
                    let imageSize = CGSize(width: proxy.size.width,
                                           height: proxy.size.width*TFImage.scale)
                    VStack(alignment: .center,
                           content: {
                        HStack(content: {
                            Text(troov.deatils)
                                .lineLimit(10)
                                .fontWithLineHeight(font: .poppins400(size: 13), lineHeight: 18)
                                .foregroundColor(.rgba(51, 51, 51, 1))
                                .fixedSize(horizontal: false,
                                           vertical: true)
                            Spacer()
                        }).padding(.top, 16)
                            .padding(.horizontal, 20)
                        TroovDetailsDatePlaceView(troov: troov)
                            .padding(.top, 20)
                            .padding(.horizontal, 20)
                        if let firstImage = troov.firstImage {
                            TImageView(images: [firstImage],
                                       size: imageSize, update: false)
                            .pinchToZoom()
                            .clipped()
                            .padding(.top, 10)
                            .overlay(alignment: .bottomLeading) {
                                TroovCellExpandedImageSlider.Overlay.NameAndAge(name: troov.firstName,
                                                                                age: nil)
                                .padding(.bottom, 18)
                                .padding(.leading, -10)
                            }
                        }
                        TroovDetailsAgeHeightView(troov: troov)
                            .padding(20)
                        if let secondImage = troov.secondImage {
                            TImageView(images: [secondImage],
                                       size: imageSize, update: false)
                            .pinchToZoom()
                            .clipped()
                        }
                        VStack(alignment: .leading) {
                            if relationshipInterestsKeyTags.count > 0 {
                                HStack(spacing: 0) {
                                    Text("Interested in")
                                        .fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 21)
                                        .foregroundColor(.black)
                                    Spacer()
                                }.padding(.bottom, 11)
                                FlexibleStack(alignment: .leading) {
                                    ForEach(relationshipInterestsKeyTags) { key in
                                        TTagTextField.Label(text: key.tag,
                                                            isSelected: true,
                                                            height: 40,
                                                            fontSize: 12)
                                    }
                                }
                            }
                            if let createdBy = troov.createdBy {
                                TroovDetailsBasicInfoView(requester: createdBy)
                                    .padding(.top, 11)
                                    .padding(.trailing, 20)
                            }
                        }.padding([.top, .leading], 20)
                        
                        if let thridImage = troov.thridImage {
                            TImageView(images: [thridImage],
                                       size: imageSize, update: false)
                            .pinchToZoom()
                            .clipped()
                        }
                        if let image = snapshotImage {
                            Image(uiImage: image)
                                .clipShape(RoundedRectangle(cornerRadius: 2))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5)
                                        .inset(by: 2)
                                        .stroke(Color.primaryTroovColor
                                            .opacity(0.3),
                                                lineWidth: 4)
                                        .padding(-4)
                                }
                                .overlay(alignment: .center) {
                                    Image("t.location.fill")
                                }.padding(.top, 14)
                        }
                        if let distance = distance {
                            Text("\(distance)kms away from you")
                                .foregroundStyle(Color.primaryTroovColor)
                                .fontWithLineHeight(font: .poppins400(size: 12), lineHeight: 18)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 4)
                                .background {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.primaryTroovColor.opacity(0.12))
                                }.padding(.top, 4)
                                .padding(.horizontal, 10)
                        }
                        if let forthImage = troov.forthImage {
                            TImageView(images: [forthImage],
                                       size: imageSize, update: false)
                            .pinchToZoom()
                            .clipped()
                        }
                        if let tags = troov.troovCoreDetails?.tags {
                            THashTagsView(tags: .constant(tags))
                                .disabled(true)
                                .padding(.horizontal, 20)
                                .padding(.top, 10)
                        }
                        if let fiftImage = troov.fiftImage {
                            TImageView(images: [fiftImage],
                                       size: imageSize, update: false)
                            .pinchToZoom()
                            .clipped()
                        }
                        
                        Button(action: report) {
                            HStack(alignment: .center,
                                   spacing: 4) {
                                Text("Report")
                                    .foregroundStyle(Color.primaryTroovRed)
                                    .fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 21)
                                Image("t.flag.report")
                            }
                                   .frame(maxWidth: .infinity)
                                   .padding(.vertical, 6)
                                   .background {
                                       RoundedRectangle(cornerRadius: 50)
                                           .stroke(Color.primaryTroovRed, lineWidth: 1)
                                   }
                        }.padding(.top, 20)
                            .padding(.horizontal, 42)
                            .padding(.bottom, 101)
                    })
                    Spacer()
                }).onAppear(perform: { appear(width: proxy.size.width - 28) })
            }
        }.padding(.top, 10)
    }
    
    private func chat() {
        
    }
    
    private func appear(width: CGFloat) {
        if let location = User.storedLocation {
            currentLocation = location
        }
        
        Task { await generateSnapshot(width: width,
                                      height: 92) }
    }

    private func report() {
        
    }
}

#Preview {
    NavigationStack {
        TroovDetailsView(troov: .init())
            .navigationBarBackButtonHidden()
    }
}

extension TroovDetailsView {
    private var distance: String? {
        if let currentLocation = currentLocation,
           let center = region?.center {
            let location = CLLocation.init(latitude: center.latitude,
                                           longitude: center.longitude)
            
            let distanceInMeters = currentLocation.distance(from: location)
            let dist: Double = distanceInMeters/1000
            let str = String(format: "%.1f", dist)
            return str
        }
        return nil
    }
    
    private var region: MKCoordinateRegion? {
        if let location = troov.location,
           let latitude = location.coordinates?.latitude,
           let longitude = location.coordinates?.longitude {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude,
                                                                     longitude: longitude),
                                      span: MKCoordinateSpan(latitudeDelta: 0.5,
                                                             longitudeDelta: 0.5))
        }
        return nil
    }
    
    func generateSnapshot(width: CGFloat,
                          height: CGFloat) async {
        guard let region = region else { return }
        // Map options.
        let mapOptions = MKMapSnapshotter.Options()
        mapOptions.region = region
        mapOptions.size = CGSize(width: width,
                                 height: height)
        mapOptions.showsBuildings = true
        // Create the snapshotter and run it.
        let snapshotter = MKMapSnapshotter(options: mapOptions)
        if let result = try? await snapshotter.start() {
            await MainActor.run {
                self.snapshotImage = result.image
            }
        }
    }
}
