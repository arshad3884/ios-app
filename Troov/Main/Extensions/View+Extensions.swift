//
//  View+Extensions.swift
//  mango
//
//  Created by Leo on 11.02.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedShape(radius: radius, corners: corners))
    }
}

extension View {
    func fontWithLineHeight(font: UIFont,
                            lineHeight: CGFloat) -> some View {
        ModifiedContent(content: self,
                        modifier: FontWithLineHeight(font: font,
                                                     lineHeight: lineHeight))
    }
}

/**Zooming modifier for any view*/

extension View {
    func pinchToZoom() -> some View {
        self.modifier(PinchToZoom())
    }
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self,
                                value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self,
                            perform: onChange)
    }
}

struct ViewVisibilityKey: PreferenceKey {
    static var defaultValue: Bool = false

    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue() || value
    }
}


fileprivate struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
/*
extension View {
    func keyboardSensible(_ offsetValue: Binding<CGFloat>, defaultOffset: CGFloat = 0) -> some View {
        return self
            .padding(.bottom, offsetValue.wrappedValue + 10 + defaultOffset)
            .onAppear {
                NotificationCenter
                    .default
                    .addObserver(forName: UIResponder.keyboardWillShowNotification,
                                 object: nil,
                                 queue: .main) { notification in
                        let keyWindow = UIApplication.shared.connectedScenes
                            .filter({$0.activationState == .foregroundActive})
                            .map({$0 as? UIWindowScene})
                            .compactMap({$0})
                            .first?.windows
                            .filter({$0.isKeyWindow}).first
                        let bottom = keyWindow?.safeAreaInsets.bottom ?? 0
                        let value = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                        let height = value.height
                        let newValue = height - bottom
                        if newValue != offsetValue.wrappedValue {
                            withAnimation {
                                offsetValue.wrappedValue = newValue
                            }
                        }
                    }
                
                NotificationCenter
                    .default
                    .addObserver(forName: UIResponder.keyboardWillHideNotification,
                                 object: nil,
                                 queue: .main) { _ in
                        withAnimation {
                            offsetValue.wrappedValue = 0
                        }
                    }
            }.onDisappear(perform: {
                NotificationCenter
                    .default
                    .removeObserver(self,
                                    name: UIResponder.keyboardWillShowNotification,
                                    object: nil)
                NotificationCenter
                    .default
                    .removeObserver(self,
                                    name: UIResponder.keyboardWillHideNotification,
                                    object: nil)
            })
    }
}
*/
