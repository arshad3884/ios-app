//
//  TroovCellExpandedImageSlider.swift
//  Troov
//
//  Created by Leo on 14.02.23.
//

import SwiftUI

struct TroovCellExpandedImageSlider: View {
    let name: String
    let age: String
    let images: [TServerImage]
    var detailsTitle: String = "See details"
    var seeDetails: (() -> ())?
    var shrink: (() -> ())?
    
    var body: some View {
        ExpendedImageSlider(serverImages: images)
            .aspectRatio(TFImage.reverseScale, contentMode: .fit)
            .overlay(alignment: .bottomLeading) {
                    Overlay(name: name,
                            age: age,
                            detailsTitle: detailsTitle,
                            seeDetails: seeDetails)
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

struct TroovCellExpandedImageSlider_Previews: PreviewProvider {
    static var previews: some View {
        TroovCellExpandedImageSlider(name: "", age: "", images: [])

    }
}

extension TroovCellExpandedImageSlider {
    struct Overlay: View {
        let name: String
        let age: String
        let detailsTitle: String
        let seeDetails: (() -> ())?
    
        var body: some View {
            HStack(alignment: .center) {
                NameAndAge(name: name, age: age)
                .padding(.leading, -10)
                Spacer()
                if let seeDetails = seeDetails {
                    Button(action: seeDetails) {
                        Text(detailsTitle)
                            .fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 22)
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Capsule().stroke(Color.white, lineWidth: 1))
                            .background(Capsule().fill(.ultraThinMaterial))
                            .lineLimit(1)
                            .shadow(color: .black.opacity(0.5), radius: 5, x: 1, y: 1)
                    }
                }
            }.padding([.bottom, .trailing], 18)
        }
    }
}

extension TroovCellExpandedImageSlider.Overlay {
    struct NameAndAge: View {
        let name: String
        let age: String?
        
        var body: some View {
            HStack(alignment: .center) {
                Text(name)
                    .fontWithLineHeight(font: .poppins600(size: 16), lineHeight: 16)
                    .lineLimit(1)
                if let age = age {
                    Text(age)
                        .fontWithLineHeight(font: .poppins400(size: 14),
                                            lineHeight: 14)
                        .lineLimit(1)
                }
            }
            .padding(.leading, 26)
            .padding(.trailing, 16)
            .padding(.vertical, 6)
            .foregroundStyle(Color.white)
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
            .background(RoundedRectangle(cornerRadius: 10).fill(.ultraThinMaterial))
            .shadow(color: .black.opacity(0.5), radius: 5, x: 1, y: 1)
        }
    }
}
