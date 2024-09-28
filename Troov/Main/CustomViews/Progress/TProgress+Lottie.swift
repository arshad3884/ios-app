//
//  TProgress+Lottie.swift
//  Troov
//
//  Created by Levon Arakelyan on 15.09.23.
//

import SwiftUI

extension TProgress {
    struct Lottie: View {
        let closeOnTap: () -> ()

        @State private var opacity = 0.0
        @State private var closed = false
        private let duration = 0.7

        var body: some View {
            ZStack {
                Color.black.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                ITLottieView(name: "t.loading.animation", loopMode: .loop)
                    .scaleEffect(0.3)
                    .background(Color.clear)
                    .frame(width: 80,
                           height: 80)
            }
             .opacity(opacity)
             .animation(.linear(duration: max(duration - 0.2, 0)), value: opacity)
             .onAppear(perform: appear)
             .edgesIgnoringSafeArea(.all)
        }

        private func tap() {
            guard closed else { return }
            closed = true
            withAnimation {
                opacity = 0.0
                DispatchQueue.main.asyncAfter(deadline: .now() + duration,
                                              execute: {
                    closeOnTap()
                })
            }
        }

        private func appear() {
            withAnimation {
                opacity = 1.0
            }
        }
    }

    
    struct Lottie_Previews: PreviewProvider {
        static var previews: some View {
            TProgress.Lottie(closeOnTap: {})
        }
    }
}
