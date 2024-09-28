//
//  GetStartedView.swift
//  Troov
//
//  Created by Levon Arakelyan on 10.10.23.
//

import SwiftUI

struct GetStartedView: View {
    @Environment(TRouter.self) var router: TRouter
    @State private var step: GetStartedTabView.Step = .createTroov
    @State private var offerToStartTutorial: Offer? = .startTutorial
    @State private var animateScreenClosure = false
    
    private var buttonTitle: String {
        if let offer = offerToStartTutorial {
            switch offer {
            case .startTutorial:
                return "Start Tutorial"
            case .next:
                return "Next"
            }
        }
        return ""
    }
    
    private var presentationDetants: CGFloat {
        if let offer = offerToStartTutorial {
            switch offer {
            case .startTutorial:
                return 0.45
            case .next:
                return 0.84
            }
        }
        return 0.4
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                Color.primaryTroovColor
                VStack {
                    Image("troov")
                        .renderingMode(.template)
                        .foregroundStyle(Color.white)
                        .padding(.top, proxy.size.height/12)
                    Spacer()
                }
                VStack(spacing: 0) {
                    if let offer = offerToStartTutorial {
                        VStack {
                            switch offer {
                            case .startTutorial:
                                OfferView()
                                    .padding(.horizontal, 32)
                                    .padding(.top, 42)
                            case .next:
                                TroovView()
                            }
                        }.containerRelativeFrame(.horizontal)
                        Spacer()
                    } else {
                        Spacer()
                        InfoView(step: step,
                                 next: { next() })
                        .padding(.horizontal, 22)
                        .padding(.top, 14)
                        .padding(.bottom, 28)
                        .background(Color.white)
                        .clipShape(Popover(arrowOffset: step.offset(width: proxy.size.width)))
                        .padding(.bottom, 30 + proxy.size.height/8)
                        .padding(.horizontal, 18)
                    }
                }
                .background(offerToStartTutorial == nil ? .clear : Color.white)
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .frame(height: proxy.size.height*presentationDetants)
            }
            .overlay(alignment: .bottom) {
                if offerToStartTutorial == nil {
                        VStack(spacing: 0) {
                            Spacer()
                            GetStartedTabView(sizeHeight: proxy.size.height/8,
                                              size: proxy.size,
                                              step: $step)
                        }
                    .ignoresSafeArea(edges: .bottom)
                } else {
                    Button(action: { next() }) {
                        TPrimaryLabel(text: buttonTitle)
                            .padding(.horizontal, 32)
                            .padding(.bottom, proxy.size.height/25)
                    }.buttonStyle(.scalable)
                }
            }
            .offset(y: animateScreenClosure ? proxy.size.height : 0)
            .animation(.smooth(duration: 0.7), value: animateScreenClosure)
        }.ignoresSafeArea()
    }

   @MainActor private func finishTutorial() {
        animateScreenClosure = true

        Task {
            await ProfileViewModel.updateRegistration(step: .complete)
            try await Task.sleep(nanoseconds: 7_000_000_00)
            router.routeToApp(cycle: .tab, tab: .discover(.List))
        }
    }
    
   @MainActor private func next() {
        if let offer = offerToStartTutorial {
            switch offer {
            case .startTutorial:
                offerToStartTutorial = .next
            case .next:
                offerToStartTutorial = nil
            }
        } else if step.nextIntroStep() == nil {
            finishTutorial()
        } else if let next = step.nextIntroStep() {
            self.step = next
        } else {
            finishTutorial()
        }
    }
}

#Preview {
    GetStartedView()
}

fileprivate extension GetStartedView {
    enum Offer {
        case startTutorial
        case next
    }
}

fileprivate extension GetStartedView {
    struct TroovView: View {
        var body: some View {
            VStack(spacing: 0) {
                    Image("t.getstarted.troov")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .containerRelativeFrame(.vertical) { value, _ in
                            return value/2
                        }
                Text("What is a troov?")
                    .fontWithLineHeight(font: .poppins700(size: 32),
                                        lineHeight: 42)
                    .foregroundStyle(Color.rgba(17, 24, 39, 1))
                    .multilineTextAlignment(.center)
                    .padding(.top, 24)
                    .padding(.horizontal, 27)
                    .fixedSize(horizontal: false, vertical: true)
                    .minimumScaleFactor(0.4)
                VStack(alignment: .center, spacing: 12) {
                    Text("A troov is an activity idea with a\nspecific time and place")
                        .fontWithLineHeight(font: .poppins400(size: 18),
                                            lineHeight: 24)
                        .foregroundStyle(Color.rgba(51, 51, 51, 1))
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.4)
                    Text("Users can request to join troovs\nthat they are interested in.")
                        .fontWithLineHeight(font: .poppins400(size: 18),
                                            lineHeight: 24)
                        .foregroundStyle(Color.rgba(51, 51, 51, 1))
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.4)
                }.padding(.vertical, 20)
                 .padding(.horizontal, 27)
                 .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
        }
    }
}

fileprivate extension GetStartedView {
    struct OfferView: View {
        var body: some View {
            VStack(alignment: .center,
                   spacing: 42) {
                HStack(alignment: .center,
                       spacing: 8) {
                    Image("t.clock")
                    Text("30 second tour")
                        .fontWithLineHeight(font: .poppins500(size: 12),
                                            lineHeight: 16)
                        .foregroundColor(.primaryTroovColor)
                }
                Text("Getting started\nwith Troov")
                    .fontWithLineHeight(font: .poppins700(size: 32),
                                        lineHeight: 42)
                    .foregroundStyle(Color.rgba(17, 24, 39, 1))
                    .fixedSize(horizontal: false,
                               vertical: true)
                    .multilineTextAlignment(.center)
            }.padding(.vertical, 24)
        }
    }
}

fileprivate extension GetStartedView {
    struct InfoView: View {
        let step: GetStartedTabView.Step
        let next: () -> ()
    
        private var nextTitle: String {
            if step == .myprofile {
                return "Finish"
            }
            return "Next"
        }
        
        var body: some View {
            VStack(alignment: .leading,
                   spacing: 8) {
                HStack(alignment: .bottom) {
                    HStack(alignment: .center, spacing: 10) {
                        Text(step.getStartedInfoTitle)
                            .fontWithLineHeight(font: .poppins700(size: 18),
                                                lineHeight: 22)
                            .foregroundStyle(Color.rgba(17, 24, 39, 1))
                        if step.containsDiscover {
                            Image(GetStartedTabView.Step.discoverTroov.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 12)
                        }
                    }
                    Spacer()
                    Text(nextTitle)
                        .fontWithLineHeight(font: .poppins400(size: 12),
                                            lineHeight: 18)
                        .foregroundStyle(Color.primaryTroovColor)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 13)
                        .background(RoundedRectangle(cornerRadius: 7)
                            .fill(Color.primaryTroovColor.opacity(0.1)))
                        .onTapGesture(perform: next)
                }
                
                Text(step.getStartedInfoBody)
                    .fontWithLineHeight(font: .poppins700(size: 14),
                                        lineHeight: 20)
                    .foregroundStyle(Color.rgba(79, 95, 113, 1))
                    .lineLimit(3...3)
                HStack {
                    Spacer()
                    Dots(step: step)
                    Spacer()
                }
            }.background(Color.white)
        }
    }
}

fileprivate extension GetStartedView.InfoView {
    struct Dots: View {
        var step: GetStartedTabView.Step
        
        private let steps = GetStartedTabView.Step.allCases
        
        var body: some View {
            HStack(alignment: .center,
                   spacing: 5) {
                ForEach(steps) { step in
                    Circle()
                        .fill(fill(step: step))
                        .frame(width: 6)
                        .animation(.bouncy, value: self.step)
                }
            }
        }
        
        private func fill(step: GetStartedTabView.Step) -> Color {
            return self.step == step ? .primaryTroovColor : .primaryGray6
        }
    }
}

extension GetStartedView {
    struct Popover : Shape {
        let cornerRadius: CGFloat
        let arrowHeight: CGFloat
        let arrowEdge: Edge
        let arrowOffset: CGFloat
        
        init(cornerRadius: CGFloat = 10,
             arrowEdge: Edge = .bottom,
             arrowHeight: CGFloat = 12,
             arrowOffset: CGFloat = 0) {
            self.cornerRadius = cornerRadius
            self.arrowHeight = arrowHeight
            self.arrowEdge = arrowEdge
            self.arrowOffset = arrowOffset
        }
        
        func path(in rect: CGRect) -> Path {
            
            var rect = rect
            var fit: ((CGPoint) -> (CGPoint)) = { point in return point }
            let arrow: CGSize = CGSize(width: (arrowHeight/811)*2000, height: arrowHeight)
            
            var clockwise = false
            var arc1 = (start: Angle.radians(-.pi*0.5), end: Angle.radians(.pi*0.0))
            var arc2 = (start: Angle.radians(.pi*0.0),  end: Angle.radians(.pi*0.5))
            var arc3 = (start: Angle.radians(.pi*0.5),  end: Angle.radians(.pi*1.0))
            var arc4 = (start: Angle.radians(.pi*1.0),  end: Angle.radians(-.pi*0.5))
            
            var path = Path()
            
            if arrowEdge == .leading || arrowEdge == .trailing {
                clockwise = true
                rect = CGRect(x: rect.origin.y, y: rect.origin.x, width: rect.height, height: rect.width)
                fit = { point in return CGPoint(x: point.y, y: point.x)}
                let newArc1 = (arc3.end, arc3.start)
                let newArc2 = (arc2.end, arc2.start)
                let newArc3 = (arc1.end, arc1.start)
                let newArc4 = (arc4.end, arc4.start)
                arc1 = newArc1; arc2 = newArc2; arc3 = newArc3; arc4 = newArc4
            }
            
            // Move to beginning of Arc 1
            
            rect = CGRect(x: rect.origin.x + arrowOffset, y: rect.origin.y, width: rect.width, height: rect.height)
            
            path.move(to: fit(CGPoint(x: rect.width*0.5 + arrow.width*0.5, y: arrow.height)) )
            
            // Step 1 (arc1)
            path.addArc(center: fit(CGPoint(x: rect.width - cornerRadius, y: cornerRadius + arrow.height)),
                        radius: cornerRadius,
                        startAngle: arc1.start,
                        endAngle: arc1.end,
                        clockwise: clockwise )
            // Step 2 (arc2)
            path.addArc(center: fit(CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius)),
                        radius: cornerRadius,
                        startAngle: arc2.start,
                        endAngle: arc2.end,
                        clockwise: clockwise )
            // Step 3 (arc3)
            path.addArc(center: fit(CGPoint(x: cornerRadius, y: rect.height - cornerRadius)),
                        radius: cornerRadius,
                        startAngle: arc3.start,
                        endAngle: arc3.end,
                        clockwise: clockwise )
            // Step 4 (arc4)
            path.addArc(center: fit(CGPoint(x: cornerRadius, y: cornerRadius + arrow.height)),
                        radius: cornerRadius,
                        startAngle: arc4.start,
                        endAngle: arc4.end,
                        clockwise: clockwise )
            
            // arrow points where x = distance from arrow center, y = distance from top of rect
            let apex = CGPoint(x: arrow.width*0.5*0.000, y: -arrow.height*0.1456)
            let peak = CGPoint(x: arrow.width*0.5*0.149, y: arrow.height*0.0864)
            let curv = CGPoint(x: arrow.width*0.5*0.600, y: arrow.height*0.7500)
            let ctrl = CGPoint(x: arrow.width*0.5*0.750, y: arrow.height*1.0000)
            let base = CGPoint(x: arrow.width*0.5*1.000, y: arrow.height*1.0000)
            
            // Step 5
            path.addLine(to: fit(CGPoint(x: rect.midX - base.x, y: base.y)))
            
            // Step 6
            path.addQuadCurve(to:      fit(CGPoint(x: rect.midX - curv.x, y: curv.y)),
                              control: fit(CGPoint(x: rect.midX - ctrl.x, y: ctrl.y)))
            
            // Step 7
            path.addLine(to: fit(CGPoint(x: rect.midX - peak.x, y: peak.y)))
            
            // Step 8
            path.addQuadCurve(to:      fit(CGPoint(x: rect.midX + peak.x, y: peak.y)),
                              control: fit(CGPoint(x: rect.midX + apex.x, y: apex.y)))
            
            // Step 9
            path.addLine(to: fit(CGPoint(x: rect.midX + curv.x, y: curv.y)))
            
            // Step 10
            path.addQuadCurve(to:      fit(CGPoint(x: rect.midX + base.x, y: base.y)),
                              control: fit(CGPoint(x: rect.midX + ctrl.x, y: ctrl.y)))
            
            var transform = CGAffineTransform(scaleX: 1, y: 1)
            let bounds = path.boundingRect
            if arrowEdge == .trailing {
                // flip horizontally
                transform = CGAffineTransform(scaleX: -1, y: 1)
                transform = transform.translatedBy(x: -bounds.width, y: 0)
            }
            if arrowEdge == .bottom {
                // flip vertically
                transform = CGAffineTransform(scaleX: 1, y: -1)
                transform = transform.translatedBy(x: 0, y: -bounds.height)
            }
            return path.applying(transform)
        }
        
    }
}
