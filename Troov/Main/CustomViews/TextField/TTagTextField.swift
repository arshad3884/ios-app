//
//  TTagTextField.swift
//  Troov
//
//  Created by Levon Arakelyan on 22.09.23.
//

import SwiftUI

struct TTagTextField: View {
    var placeholder: String
    @Binding var tags: [String]
    @Binding var tag: String
    
    private let leadingSpacing: CGFloat = 10
    private let vSpacing: CGFloat = 10
    private let hSpacing: CGFloat = 10
    private let textFieldHeight: CGFloat = 60

    private var keyTags: [KeyTag] {
        return tags.map({KeyTag(tag: $0)})
    }

    @FocusState private var isFocused: Bool

    var body: some View {
        FlexibleStack(alignment: .leading) {
            ForEach(keyTags) { key in
                Label(image: "t.hash",
                      text: key.tag,
                      isSelected: true,
                      height: 40,
                      fontSize: 12) {
                    remove(key.tag)
                }
            }
            TextField("",
                      text: $tag,
                      prompt: Text(placeholder)
                .font(Font(UIFont.poppins400(size: 14)))
                .foregroundStyle(Color(hex: "A7AFB8")))
            .focused($isFocused)
            .foregroundStyle(Color.rgba(34, 34, 34, 1))
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .onSubmit {
                tag += ","
            }.frame(width: 80,
                    height: 40)
        }.padding(10)
         .frame(maxWidth: .infinity)
         .frame(minHeight: 60)
         .background(RoundedRectangle(cornerRadius: textFieldHeight/2).fill(Color.primaryLightGray))
         .overlay(content: {
                RoundedRectangle(cornerRadius: textFieldHeight/2)
                    .stroke(Color.overlayGray, lineWidth: 1)
         })
         .onTapGesture {
             if !isFocused {
                 isFocused = true
             }
         }
    }
    
    private func remove(_ tag: String) {
        if let index = tags.firstIndex(of: tag) {
            tags.remove(at: index)
        }
    }
}

#Preview {
    TTagTextField(placeholder: "Tags",
                  tags: .constant([]),
                  tag: .constant(""))
}

extension TTagTextField {
    struct KeyTag: Identifiable {
        let id = UUID()
        let tag: String
    }
}

extension TTagTextField {
    struct Label: View {
        var image: String? = nil
        var text: String
        var isSelected: Bool = false
        var height: CGFloat = 56.0
        var fontSize: CGFloat = 18
        var remove: (() -> (Void))? = nil
        
        var body: some View {
            HStack(alignment: .center,
                   spacing: 0) {
                if let image = image {
                    Image(image)
                        .renderingMode(.template)
                        .padding(.trailing, remove != nil ? 3 : 10)
                }
                Text(text)
                    .fontWithLineHeight(font: .poppins400(size: fontSize), lineHeight: fontSize)
                if let remove = remove {
                    Image("t.xmark")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 11,
                               height: 11)
                        .foregroundColor(.primaryTroovColor)
                        .padding(.leading, 5)
                        .onTapGesture(perform: remove)
                }
            }
                   .foregroundColor(isSelected ? Color.primaryTroovColor : .rgba(34, 34, 34, 1))
                   .padding(.horizontal, 15.relative(to: .width))
                   .frame(height: height)
                   .background(isSelected ? .rgba(236, 236, 255, 1) : Color.white)
                   .cornerRadius(height/2)
                   .overlay(
                    RoundedRectangle(cornerRadius: height/2)
                        .stroke(isSelected ? .primaryTroovColor : Color.black.opacity(0.1), lineWidth: 1)
                   )
        }
    }
}
