//
//  ITSegmentedControlView.swift
//  IELTS Computer
//
//  Created by Leo on 18.08.2023.
//

import SwiftUI

struct SegmentedControlView: View {
    var segments: [SegmentedControlView.Segment]
    
    var currentSegment: SegmentedControlView.Segment?
    var select: (SegmentedControlView.Segment) -> ()
    
    private var selectedIndex: Int {
        segments.firstIndex(where: {currentSegment?.id == $0.id}) ?? 0
    }
    
    private let height: CGFloat = 40
    private let padding: CGFloat = 4
    
    private let fillColor: Color = .rgba(250, 250, 251, 1)
    private var cornerRadius: CGFloat {
        height/2
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(fillColor)
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                    .frame(width: geo.size.width / CGFloat(segments.count))
                    .shadow(color: .primaryBlack.opacity(0.1), radius: 2, x: 1, y: 1)
                    .animation(.spring().speed(1.5), value: currentSegment?.id)
                    .offset(x: selectedIndex == 0 ? 0 : geo.size.width / CGFloat(segments.count) * CGFloat(selectedIndex) - CGFloat(selectedIndex)*2*padding, y: 0)
                    .padding(padding)
                HStack(alignment: .center,
                       spacing: 0) {
                    ForEach(segments, id: \.id) { segment in
                        Text(segment.title)
                            .fontWithLineHeight(font: currentSegment?.id == segment.id ? .poppins700(size: 12) : .poppins500(size: 12),
                                                lineHeight: 12)
                            .tracking(0.4)
                            .foregroundStyle(currentSegment?.id == segment.id ? Color.primaryTroovColor : .rgba(156, 163, 175, 1))
                            .frame(width: geo.size.width / CGFloat(segments.count),
                                   height: height)
                            .background(Color.white.opacity(0.01))
                            .gesture(DragGesture(minimumDistance: 0,
                                                 coordinateSpace: .local)
                                .onEnded({ value in
                                    if value.translation.width < 0 {
                                        if selectedIndex != 0 {
                                            let count = segments.count
                                            select(segments[count - 2])
                                        }
                                    }
                                    if value.translation.width > 0 {
                                        if selectedIndex != segments.count - 1 {
                                            let count = segments.count - 1
                                            select(segments[count])
                                        }
                                    }
                                }))
                            .highPriorityGesture(
                                TapGesture()
                                    .onEnded { _ in select(segment)}
                            )
                    }
                }.animation(.spring().speed(1.5), value: currentSegment?.id)
            }
        }
        .frame(height: height)
        .cornerRadius(cornerRadius)
    }
}

extension SegmentedControlView {
    struct Segment: Identifiable {
        var id: String
        var title: String
    }
}

