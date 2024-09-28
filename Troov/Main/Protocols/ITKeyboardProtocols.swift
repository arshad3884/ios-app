//
//  ITKeyboardProtocols.swift
//  Troov
//
//  Created by Leo on 03.02.23.
//

import Combine
import SwiftUI

protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }

    func endEditing() {
        UIApplication.shared.endEditing()
    }

    var keyboardToolbar: ToolbarItemGroup<some View> {
        ToolbarItemGroup(placement: .keyboard) {
            HStack(alignment: .center) {
                Spacer()
                Button(action: endEditing) {
                    Text("Done")
                        .fontWithLineHeight(font: .poppins400(size: 12), lineHeight: 12)
                        .foregroundStyle(Color.primaryTroovColor)
                }.padding(.trailing, 10)
            }
        }
    }
    
    func keyboardToolbarWithDoneAction(complation: @escaping () -> ()) -> ToolbarItemGroup<some View> {
        ToolbarItemGroup(placement: .keyboard) {
            HStack(alignment: .center) {
                Spacer()
                Button(action: complation) {
                    Text("Done")
                        .fontWithLineHeight(font: .poppins400(size: 12), lineHeight: 12)
                        .foregroundStyle(Color.primaryTroovColor)
                }.padding(.trailing, 10)
            }
        }
    }
    
    func keyboardToolbarHashtag(createHashtag: @escaping () -> ()) -> ToolbarItemGroup<some View> {
        ToolbarItemGroup(placement: .keyboard) {
            HStack(alignment: .center) {
                Button(action: createHashtag) {
                    Text("#")
                        .fontWithLineHeight(font: .poppins400(size: 12), lineHeight: 12)
                        .foregroundStyle(Color.primaryTroovColor)
                }.padding(.trailing, 10)
                Spacer()
                Button(action: endEditing) {
                    Text("Done")
                        .fontWithLineHeight(font: .poppins400(size: 12), lineHeight: 12)
                        .foregroundStyle(Color.primaryTroovColor)
                }.padding(.trailing, 10)
            }
        }
    }
}
