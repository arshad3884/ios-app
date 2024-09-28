//
//  AddImageCardView.swift
//  mango
//
//  Created by Leo on 12.01.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct AddImageCardView: View {
    let media: TProfileMedia
    var compact: Bool = false
    var index: Int?
    let pick: (() -> ())
    var cornerRadius: CGFloat = 8.0

    private var failure: String? {
        media.element2.failure
    }

    private var result: TCircularProgressResultView.Result {
        return failure != nil ? .failure : .success
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.rgba(249, 249, 249, 1))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Image("t.plus.circle")
                    .resizable()
                    .frame(width: 24,
                           height: 24)
                    .foregroundColor(.primaryBlack)
                if let image = media.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: proxy.size.width,
                               height: proxy.size.height)
                        .cornerRadius(cornerRadius)
                        .clipped()
                }
            }.overlay(alignment: .bottomTrailing) {
                IndexView(index: index)
                    .padding(5)
            }.overlay {
                if media.inProgress && media.image != nil {
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.black.opacity(0.3))
                        TCircularProgressResultView(results: result,
                                                    showBackground: media.finished,
                                                    lineWidth: compact ? 3 :5)
                        .frame(width: compact ? 42 : 80.0,
                               height: compact ? 42 : 80.0)
                    }
                }
            }
        }
    }
}

struct AddImageCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddImageCardView(media: .init(.init(),
                                      .init())) { }
    }
}

extension AddImageCardView {
    struct IndexView: View {
    
        var index: Int?
        
        private var hasIndex: Bool {
            index != nil
        }
        
        private var text: String {
            if let index = index {
                return "\(index)"
            }
            return ""
        }
        
        var body: some View {
            Text(text)
                .fontWithLineHeight(font: .poppins500(size: 14),
                                    lineHeight: 14)
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .background {
                    Circle()
                        .fill(hasIndex ? Color.primaryTroovColor.opacity(1) : .white.opacity(0.5))
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                }
                .overlay {
                    Circle()
                        .stroke(Color.white, lineWidth: 1)
                }
            
        }
    }
}

