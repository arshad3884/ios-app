//
//  THashTagsView.swift
//  Troov
//
//  Created by Levon Arakelyan on 22.09.23.
//

import SwiftUI

struct THashTagsView: View {
    @Binding var tags: [String]

    private let leadingSpacing: CGFloat = 0
    private let vSpacing: CGFloat = 10
    private let hSpacing: CGFloat = 10

    private var keyTags: [TTagTextField.KeyTag] {
        return tags.map({TTagTextField.KeyTag(tag: $0)})
    }
    
    var body: some View {
        FlexibleStack(alignment: .center) {
            ForEach(keyTags) { key in
                TTagTextField.Label(image:  "t.hash",
                               text: key.tag,
                               isSelected: true,
                               height: 40,
                               fontSize: 12)
                .highPriorityGesture(LongPressGesture()
                    .onEnded({ _ in
                        remove(key.tag)
                    }))
            }
        }.padding(5)
    }

    private func remove(_ tag: String) {
        if let index = tags.firstIndex(of: tag) {
            withAnimation {
                tags.remove(at: index)
            }
        }
    }
}

struct THashTagsView_Previews: PreviewProvider {
    static var previews: some View {
        THashTagsView(tags: .constant(["tag 1", "tagtagatgagaag 1"]))
    }
}
