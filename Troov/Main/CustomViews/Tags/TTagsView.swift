//
//  TTagsView.swift
//  Troov
//
//  Created by Levon Arakelyan on 18.09.23.
//

import SwiftUI

struct TTagsView: View {
    var tags: [String]
    @Binding var selectedTags: [String]
    
    private var keyTags: [TTagTextField.KeyTag] {
        return tags.map({TTagTextField.KeyTag(tag: $0)})
    }

    private let leadingSpacing: CGFloat = 0
    private let vSpacing: CGFloat = 10
    private let hSpacing: CGFloat = 10

    var body: some View {
        FlexibleStack(alignment: .leading) {
            ForEach(keyTags) { key in
                Button { select(key.tag) } label: {
                    TTagTextField.Label(image: selectedTags.contains(key.tag) ? "t.checkmark.large" : "t.large.plus",
                                        text: key.tag,
                                        isSelected: selectedTags.contains(key.tag),
                                        height: 40,
                                        fontSize: 12)
                }.buttonStyle(.scalable)
            }
        }
    }

    private func select(_ tag: String) {
        if let index = selectedTags.firstIndex(of: tag) {
            selectedTags.remove(at: index)
        } else {
            selectedTags.append(tag)
        }
    }
}

struct TTagsView_Previews: PreviewProvider {
    static var previews: some View {
        TTagsView(tags: ["tag 1", "tagtagatgagaag 1"],
                  selectedTags: .constant(["tag 1"]))
    }
}
