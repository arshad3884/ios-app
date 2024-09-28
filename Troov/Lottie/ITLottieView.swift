//
//  ITLottieView.swift
//  Troov
//
//  Created by Levon Arakelyan on 15.09.23.
//

import Lottie
import SwiftUI

struct ITLottieView: UIViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }

    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: name)
        animationView.play()
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundColor = .clear
        return animationView
    }
}
