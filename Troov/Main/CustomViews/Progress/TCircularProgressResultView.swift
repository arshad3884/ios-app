//
//  TCircularProgressResultView.swift
//  Troov
//
//  Created by Levon Arakelyan on 22.02.24.
//

import SwiftUI

struct TCircularProgressResultView: View {
    let results: Result
    let showBackground: Bool
    let lineWidth: CGFloat
    
    @State private var progress: Double = 0.0
    @State private var initialProgress: Double = 0.0
    
    private var circularProgress: Double {
        switch results {
        case .success:
            return progress
        case .failure:
            return 0.25
        }
    }
    
    var body: some View {
        TProgress.Circular(initialProgress: initialProgress,
                           progress: circularProgress,
                           configuration: results.progressConfiguration,
                           lineWidth: lineWidth)
        
        .background {
            results.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(showBackground ? 1 : 0.0)
                .padding(2)
        }
        .onAppear(perform: {
            animate()
        }).onChange(of: showBackground) { _, newValue in
            if newValue {
                stopAnimation()
            } else {
                animate()
            }
        }
    }
    
    private func animate() {
        progress = 0.0
        initialProgress = 0.0

        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: false)) {
            progress = 1.0
        }
        
        withAnimation(.easeInOut(duration: 3).delay(3.1).repeatForever(autoreverses: false)) {
            initialProgress = 1.0
        }
    }

    private func stopAnimation() {
        withAnimation() {
            progress = 1.0
        }
        
        withAnimation() {
            initialProgress = 0.0
        }
    }
}

#Preview {
    TCircularProgressResultView(results: .success,
                                showBackground: true,
                                lineWidth: 5)
}

extension TCircularProgressResultView {
    enum Result {
        case success
        case failure
    }
}

extension TCircularProgressResultView.Result {
    var progressConfiguration: TProgress.Circular.Configuration {
        switch self {
        case .success:
            return .primary
        case .failure:
            return .alert
        }
    }
    
    var image: Image {
        switch self {
        case .success:
            return Image("t.checkmark.translucent")
        case .failure:
            return Image("t.exclamation.translucent")
        }
    }
}
