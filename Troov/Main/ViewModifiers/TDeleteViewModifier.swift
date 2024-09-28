//
//  TDeleteViewModifier.swift
//  Troov
//
//  Created by Leo on 24.10.22.
//

import SwiftUI

struct TDeleteViewModifier: ViewModifier {
    var contentChange: Bool
    var disable: Bool
    
    let action: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var initialOffset: CGSize = .zero
    @State private var contentWidth: CGFloat = 0.0
    @State private var willDeleteIfReleased = false
    
    //MARK: Constants
    
    private let deletionDistance = CGFloat(200)
    private let halfDeletionDistance = CGFloat(50)
    private let tappableDeletionWidth = CGFloat(100)
    
    func body(content: Content) -> some View {
        return content
            .background(
                GeometryReader { geometry in
                    ZStack {
                        Rectangle()
                            .foregroundColor(.primaryTroovColor)
                        Image("t.trash")
                            .layoutPriority(-1)
                    }.frame(width: -offset.width)
                        .offset(x: geometry.size.width)
                        .onAppear {
                            contentWidth = geometry.size.width
                        }
                        .gesture(TapGesture().onEnded(delete))
                }
            )
            .offset(x: offset.width,
                    y: 0)
            .border(Color.black.opacity(0.1), width: offset.width < 0 ? 1 : 0.0)
            .animation(.linear, value: offset.width)
            .gesture (
                DragGesture()
                    .onChanged { gesture in
                        guard !disable else { return }
                        if gesture.translation.width + initialOffset.width <= 0 {
                            self.offset.width = gesture.translation.width + initialOffset.width
                        }
                        if self.offset.width < -deletionDistance && !willDeleteIfReleased {
                            hapticFeedback()
                            willDeleteIfReleased.toggle()
                        } else if offset.width > -deletionDistance && willDeleteIfReleased {
                            hapticFeedback()
                            willDeleteIfReleased.toggle()
                        }
                    }
                    .onEnded { _ in
                        guard !disable else { return }
                        if offset.width < -deletionDistance {
                            delete()
                        } else if offset.width < -halfDeletionDistance {
                            offset.width = -tappableDeletionWidth
                            initialOffset.width = -tappableDeletionWidth
                        } else {
                            offset = .zero
                            initialOffset = .zero
                        }
                    }
                
            )
            .animation(.interactiveSpring(), value: offset.width)
            .onChange(of: contentChange) { _, newValue in
                if offset != .zero {
                    withAnimation {
                        offset = .zero
                        initialOffset = .zero
                    }
                }
            }
    }
    
    private func delete() {
        withAnimation {
            offset.width = -contentWidth
            action()
        }
    }
    
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
