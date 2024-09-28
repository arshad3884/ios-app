//
//  SwiftTextView.swift
//  mango
//
//  Created by Leo on 17.05.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct SwiftTextView: UIViewRepresentable {
    var placeholder: String
    @Binding var text: String
    @Binding var isEditing: Bool
    @Binding var returnKeyPressed: Bool
    @Binding var height: CGFloat
    var isFirstResponder: Bool = false

    func makeCoordinator() -> SwiftTextView.Coordinator {
        return SwiftTextView.Coordinator(parent: self)
    }

    func makeUIView(context: UIViewRepresentableContext<SwiftTextView>) -> UITextView {
        let tview = UITextView()
        tview.isEditable = true
        tview.backgroundColor = .clear
        if text == "" {
            tview.text = placeholder
        } else {
            tview.text = text
        }
        tview.textColor = .gray
        tview.font = .poppins500(size: 16.0)
        tview.delegate = context.coordinator
        if isFirstResponder {
            tview.becomeFirstResponder()
        }
        return tview
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<SwiftTextView>) {
        if let text = uiView.text {
            DispatchQueue.main.async {
                self.text = text
            }

            // Compute the desired height for the content
              let fixedWidth = uiView.frame.size.width
              let newSize = uiView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))

            DispatchQueue.main.async {
                self.height = newSize.height
            }
        }
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: SwiftTextView

        init(parent: SwiftTextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }

        func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
            withAnimation {
                self.parent.isEditing.toggle()
            }
            return true
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.text = self.parent.text
            textView.textColor = .black
            DispatchQueue.main.async {
                self.parent.returnKeyPressed = true
            }
        }
    }
}
