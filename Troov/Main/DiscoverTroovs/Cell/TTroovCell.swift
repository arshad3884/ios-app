//
//  TTroovCell.swift
//  Troov
//
//  Created by Leo on 10.02.23.
//

import SwiftUI

struct TTroovCell: View {
    let troov: Troov
    let isExpanded: Bool
    let isOwn: Bool
    let expand: (() -> ())?
    let seeDetails: () -> ()
    let showLocation: (Troov) -> ()
    let request: (() -> ())?
    
    private var expanded: Bool {
        return isExpanded
    }

    private let horizontalPadding: CGFloat = 10.0

    var body: some View {
        VStack(alignment: .leading,
               spacing: 0) {
            VStack(spacing: 12, content: {
                TTroovCellTopBarView(etroovTitle: troov.title)
                TCalendarCellView(troov: troov) {
                    showLocation(troov)
                }
                    .padding(.leading, 10)
            }).layoutPriority(1)
              .padding(.top, 10)
              .background(Color.white.opacity(0.01))
              .onTapGesture(perform: seeDetails)
            Spacer()
            if !isExpanded {
                TTroovCoreUserInfoView(troov: troov,
                                       expand: expand)
                .onTapGesture(perform: seeDetails)
            } else {
                ImageSlider(name: troov.firstName,
                            age: troov.age,
                            images: troov.serverImages ?? [],
                            isOwn: isOwn,
                            request: request,
                            shrink: expand)
                .onTapGesture(perform: seeDetails)
            }
        }
               .frame(minHeight: expanded ? 500 : 157)
               .clipShape(RoundedRectangle(cornerRadius: 15))
               .padding([.bottom, .horizontal], horizontalPadding)
               .background(Color.white.cornerRadius(15))
               .padding(.horizontal, horizontalPadding)
               .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
               .animation(.smooth(duration: 0.25), value: expanded)
    }
}

struct TTroovCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.yellow
            TTroovCell(troov: .preview,
                       isExpanded: false, isOwn: false, expand: {}, seeDetails: {}, showLocation: { _ in}, request: {})
        }
    }
}

extension TTroovCell {
    struct ImageSlider: View {
        let name: String
        let age: String
        let images: [TServerImage]
        let isOwn: Bool
        var request: (() -> ())?
        var shrink: (() -> ())?
        
        var body: some View {
            ExpendedImageSlider(serverImages: images)
                .aspectRatio(TFImage.reverseScale, contentMode: .fit)
                .overlay(alignment: .bottomLeading) {
                        Overlay(name: name,
                                age: age,
                                isOwn: isOwn,
                                request: request)
                        .disabled(isOwn)
                }
                .overlay(alignment: .topTrailing, content: {
                    if let shrink = shrink {
                        Button(action: shrink) {
                            TExpendView(isSelected: true)
                                .shadow(radius: 3)
                        }.padding(.top, 18)
                         .padding(.trailing, 10)
                    }
                })
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

extension TTroovCell.ImageSlider {
    struct Overlay: View {
        let name: String
        let age: String
        let isOwn: Bool
        let request: (() -> ())?

        var body: some View {
            HStack(alignment: .center) {
                TroovCellExpandedImageSlider.Overlay.NameAndAge(name: name, age: age)
                .padding(.leading, -10)
                Spacer()
                if let request = request {
                    Button(action: request) {
                        TLabel.Primary.Request()
                    }.buttonStyle(.scalable)
                     .padding(.trailing, -27)
                     .disabled(isOwn)
                     .opacity(isOwn ? 0.0 : 1.0)
                }
            }.padding([.bottom, .trailing], 18)
        }
    }
}
