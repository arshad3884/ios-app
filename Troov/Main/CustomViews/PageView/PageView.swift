//
//  PageView.swift
//  Troov
//
//  Created by Levon Arakelyan on 14.11.23.
//

import SwiftUI

struct PageView<Content: View,
                Pages: RandomAccessCollection>: View where Pages: MutableCollection,
                                                           Pages.Element: Identifiable {
    let pages: Pages
    @Binding var positionId: Pages.Element.ID?
    let configuration: PageViewConfiguration
    @ViewBuilder var content: (Pages.Element) -> Content

    var body: some View {
            ScrollView(.horizontal) {
                HStack(alignment: configuration.vAlignment,
                           spacing: configuration.sliderInteritemSpacing) {
                    ForEach(pages, id: \.id) { page in
                        content(page)
                            .containerRelativeFrame(.horizontal)
                            .scrollTransition { effect, phase in
                                return effect.scaleEffect(y: configuration.allowScalling ? phase.isIdentity ? 1: 0.86 : 1)
                            }
                    }
                }.scrollTargetLayout()
            }.scrollIndicators(.hidden)
             .scrollTargetBehavior(.viewAligned)
             .scrollPosition(id: $positionId)
        }
}


#Preview {
    PageView(pages: [PageViewPreviewItem.init()],
             positionId: .constant(UUID()),
             configuration: .init(sliderInteritemSpacing: 20,
                                  vAlignment: .top)) { page in
        Text("\(page.id)")
    }
}

private struct PageViewPreviewItem: Identifiable {
    private(set) var id = UUID()
    
}
