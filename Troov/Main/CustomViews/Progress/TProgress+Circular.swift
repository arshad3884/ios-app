//
//  TProgress+Circular.swift
//  Troov
//
//  Created by Levon Arakelyan on 18.09.24.
//

import SwiftUI

extension TProgress {
    struct Circular: View {
        var initialProgress: Double = 0
        let progress: Double
        let configuration: Configuration
        let lineWidth: CGFloat
        
        var body: some View {
            Circle()
                .trim(from: initialProgress, to: progress)
                .stroke(configuration.strokeActive,
                        style: StrokeStyle(lineWidth: lineWidth,
                                           lineCap: .round)
                )
                .padding(lineWidth/2)
                .rotationEffect(.degrees(-90))
                .background {
                    Circle()
                        .stroke(configuration.strokeBackground,
                                lineWidth: lineWidth)
                        .padding(lineWidth/2)
                }
        }
    }
}

extension TProgress.Circular {
    struct Configuration {
        let strokeActive: Color
        let strokeBackground: Color
    }
}

extension  TProgress.Circular.Configuration {
    static var primary: TProgress.Circular.Configuration {
        TProgress.Circular.Configuration(strokeActive: .primaryTroovColor,
                                         strokeBackground: .white)
    }
    
    static var alert: TProgress.Circular.Configuration {
        TProgress.Circular.Configuration(strokeActive: .primaryTroovRed,
                                         strokeBackground: .white)
    }
}


#Preview {
    TProgress.Circular(progress: 0.5,
                       configuration: .primary,
                       lineWidth: 5)
}
