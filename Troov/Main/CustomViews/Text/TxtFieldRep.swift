//
//  TxtFieldRep.swift
//  mango
//
//  Created by Leo on 06.05.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct TxtFieldRep: UIViewRepresentable {
    var placeholder: String
    @Binding var text: String
    @Binding var isEditing: Bool
    var isFirstResponder: Bool = false
    @Binding var returnKeyPressed: Bool
    var limit: Int?

    func makeCoordinator() -> TxtFieldRep.Coordinator {
        return TxtFieldRep.Coordinator(parent: self)
    }

    func makeUIView(context: UIViewRepresentableContext<TxtFieldRep>) -> UITextField {
        let tview = UITextField()
        tview.returnKeyType = .done
        tview.placeholder = placeholder
        tview.text = text
        tview.delegate = context.coordinator
        tview.font = .poppins500(size: 16.0)
        if isFirstResponder {
            tview.becomeFirstResponder()
        }
        return tview
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<TxtFieldRep>) {
        if let text = uiView.text {
            DispatchQueue.main.async {
                self.text = text
            }
        }
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: TxtFieldRep

        init(parent: TxtFieldRep) {
            self.parent = parent
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.text = self.parent.text
            textField.textColor = .black
            DispatchQueue.main.async {
                self.parent.returnKeyPressed = true
            }
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            withAnimation {
                self.parent.text = textField.text ?? ""
                self.parent.isEditing = false
            }
            return true
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            if self.parent.isEditing {
                withAnimation {
                    self.parent.text = textField.text ?? ""
                    self.parent.isEditing = false
                }
            }
        }

        func textField(_ textField: UITextField,
                       shouldChangeCharactersIn range: NSRange,
                       replacementString string: String) -> Bool {
            if let limit = parent.limit {
                return self.textLimit(existingText: textField.text,
                                      newText: string,
                                      limit: limit)
            } else {
                return true
            }
        }

        private func textLimit(existingText: String?,
                               newText: String,
                               limit: Int) -> Bool {
            let text = existingText ?? ""
            let isAtLimit = text.count + newText.count <= limit
            return isAtLimit
        }
    }
}
