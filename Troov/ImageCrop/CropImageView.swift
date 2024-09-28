//
//  TroovView.swift
//  Troov
//
//  Created by leo on 23.10.2023.
//

import SwiftUI

struct CropImageView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var pickedImages: [PickedImage]
    @Binding var selectedImageIndex: Int
    var crop: Bool
    var currentImageIndex: Int
    let next: (Int) -> ()
    
    @State private var scale: CGFloat = 1
    private let rectangleLineSize: CGFloat = 5
    private let rectangleLineWidth: CGFloat = 3
    @State private var fixedRect = Crop.rectangle.size()
    @State private var actualRect = Crop.rectangle.size()
    
    @State private var isChanging: Bool = false
    @State private var cutting: Bool = false

    var body: some View {
        Image(uiImage: pickedImages[currentImageIndex].image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .overlay {
                Rectangle()
                    .fill(Material.ultraThinMaterial.opacity(isChanging ? 0.4 : 1))
                    .animation(.bouncy, value: isChanging)
                    .mask(CropShape(actualRect: actualRect).fill(style: FillStyle(eoFill: true)))
            }
            .overlay {
                GeometryReader { proxy in
                    if !cutting {
                        Grid()
                            .customFrame(actualRect)
                            .onAppear(perform: { appear(proxy: proxy) })
                            .onChange(of: actualRect, { oldValue, newValue in
                                let screen = CGRect(origin: .zero, size: proxy.size)
                                let wratio = actualRect.width / actualRect.height
                                let hratio = actualRect.height / actualRect.width
                                let midX = actualRect.midX
                                let midY = actualRect.midY
                                if actualRect.width > screen.width {
                                    actualRect.size.width = screen.width
                                    actualRect.size.height = screen.width * hratio
                                    actualRect = actualRect.offsetBy(dx: midX - actualRect.midX, dy: midY - actualRect.midY)
                                }
                                if actualRect.height > screen.height {
                                    actualRect.size.height = screen.height
                                    actualRect.size.width = screen.height * wratio
                                    actualRect = actualRect.offsetBy(dx: midX - actualRect.midX, dy: midY - actualRect.midY)
                                }
                                if actualRect.minX < screen.minX {
                                    actualRect.origin.x = 0
                                }
                                if actualRect.minY < screen.minX {
                                    actualRect.origin.y = 0
                                }
                                if actualRect.maxX > screen.maxX {
                                    actualRect.origin.x -= actualRect.maxX - screen.maxX
                                }
                                if actualRect.maxY > screen.maxY {
                                    actualRect.origin.y -= actualRect.maxY - screen.maxY
                                }
                            }).onChange(of: crop) { _, _ in
                                if selectedImageIndex == currentImageIndex {
                                    let scaledRect = CGRect(
                                        x: actualRect.origin.x * scale,
                                        y: actualRect.origin.y * scale,
                                        width: actualRect.width * scale,
                                        height: actualRect.height * scale
                                    )
                                    if let newImage = pickedImages[selectedImageIndex].image.croppedImage(inRect: scaledRect) {
                                        let index = currentImageIndex
                                        withAnimation(.easeIn(duration: 0.3)) {
                                            pickedImages[index].image = newImage
                                            cutting = true
                                        }
                                        
                                        reset()

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                            withAnimation(.easeOut(duration: 0.3)) {
                                                cutting = false
                                            }
                                        })
                                    }
                                }
                            }
                    }
                }
            }.overlay {
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                isChanging = true
                                if let anchor = fixedRect.anchor(for: value.startLocation) {
                                    actualRect = fixedRect.magnify(with: anchor, translation: value.translation)
                                } else {
                                    actualRect = fixedRect.offsetBy(dx: value.translation.width, dy: value.translation.height)
                                }
                            })
                            .onEnded({ _ in
                                fixedRect = actualRect
                                isChanging = false
                            })
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged({ value in
                                isChanging = true
                                actualRect = fixedRect.insetBy(dx: fixedRect.width / 2 - value * fixedRect.width / 2, dy: fixedRect.height / 2 - value * fixedRect.height / 2)
                            })
                            .onEnded({ _ in
                                fixedRect = actualRect
                                isChanging = false
                            })
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .coordinateSpace(name: "CROPVIEW")
    }

    private func reset() {
        scale = 1
        fixedRect = Crop.rectangle.size()
        actualRect = Crop.rectangle.size()
        isChanging = false
    }
    
    @ViewBuilder
    func Grid() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .stroke(.white, lineWidth: rectangleLineWidth)
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(.white)
                    .frame(width: rectangleLineSize, height: 15)
                Rectangle()
                    .fill(.white)
                    .frame(width: 15, height: rectangleLineSize)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(.white)
                    .frame(width: rectangleLineSize, height: 15)
                Rectangle()
                    .fill(.white)
                    .frame(width: 15, height: rectangleLineSize)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(.white)
                    .frame(width: rectangleLineSize, height: 15)
                Rectangle()
                    .fill(.white)
                    .frame(width: 15, height: rectangleLineSize)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            ZStack(alignment: .bottomTrailing) {
                Rectangle()
                    .fill(.white)
                    .frame(width: rectangleLineSize, height: 15)
                Rectangle()
                    .fill(.white)
                    .frame(width: 15, height: rectangleLineSize)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
    }
    
    private func appear(proxy: GeometryProxy) {
        let screen = CGRect(origin: .zero, size: proxy.size)
        scale = min(pickedImages[currentImageIndex].image.size.width / proxy.size.width,
                    pickedImages[currentImageIndex].image.size.height / proxy.size.height)
        let xScale = screen.width / actualRect.width
        let yScale = screen.height / actualRect.height
        let minScale = min(xScale, yScale)
        if minScale < 1 {
            actualRect = actualRect.applying(CGAffineTransform(scaleX: minScale, y: minScale))
        }
        actualRect = actualRect.offsetBy(dx: screen.midX - actualRect.midX, dy: screen.midY - actualRect.midY)
        fixedRect = actualRect
    }
}

#Preview {
    CropImageView(pickedImages: .constant([]),
                  selectedImageIndex: .constant(0),
                  crop: false,
                  currentImageIndex: 0) { _ in}
}

fileprivate enum Anchor: CaseIterable {
    case left, right, top, bottom
    case leftTop, leftBottom, rightTop, rightBottom
    
    static let delta: CGFloat = 15
    
    var opposite: Anchor {
        switch self {
        case .left:
            return .right
        case .right:
            return .left
        case .top:
            return .bottom
        case .bottom:
            return .top
        case .leftTop:
            return .rightBottom
        case .leftBottom:
            return .rightTop
        case .rightTop:
            return .leftBottom
        case .rightBottom:
            return .leftTop
        }
    }
}

fileprivate extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let dx = x - point.x
        let dy = y - point.y
        return CGFloat(sqrt(dx * dx + dy * dy))
    }
}

fileprivate extension CGSize {
    var diagonal: CGFloat {
        return CGFloat(sqrt(width * width + height * height))
    }
}

fileprivate extension CGRect {
    func anchor(for point: CGPoint) -> Anchor? {
        Anchor.allCases.first { anchor in
            point.distance(to: self.point(for: anchor)) < Anchor.delta
        }
    }
    
    func point(for anchor: Anchor) -> CGPoint {
        switch anchor {
        case .left:
            return CGPoint(x: minX, y: midY)
        case .right:
            return CGPoint(x: maxX, y: midY)
        case .top:
            return CGPoint(x: midX, y: minY)
        case .bottom:
            return CGPoint(x: midX, y: maxY)
        case .leftTop:
            return CGPoint(x: minX, y: minY)
        case .leftBottom:
            return CGPoint(x: minX, y: maxY)
        case .rightTop:
            return CGPoint(x: maxX, y: minY)
        case .rightBottom:
            return CGPoint(x: maxX, y: maxY)
        }
    }
    
    func scale(with anchor: Anchor, translation: CGSize) -> CGFloat {
        let staticAnchorPoint = point(for: anchor.opposite)
        let movementAnchorPoint = point(for: anchor)
        switch anchor {
        case .left:
            return max(0, -translation.width / width + 1)
        case .right:
            return max(0, translation.width / width + 1)
        case .top:
            return max(0, -translation.height / height + 1)
        case .bottom:
            return max(0, translation.height / height + 1)
        case .leftTop, .leftBottom, .rightTop, .rightBottom:
            let newSize = CGSize(
                width: movementAnchorPoint.x - staticAnchorPoint.x + translation.width,
                height: movementAnchorPoint.y - staticAnchorPoint.y + translation.height
            )
            return newSize.diagonal / size.diagonal
        }
    }
    
    func magnify(with anchor: Anchor, translation: CGSize) -> CGRect {
        let staticAnchorPoint = point(for: anchor.opposite)
        let translationScale = scale(with: anchor, translation: translation)
        let scaled = applying(CGAffineTransform.identity.scaledBy(x: translationScale, y: translationScale))
        let newStaticAnchorPoint = scaled.point(for: anchor.opposite)
        let translated = scaled.applying(CGAffineTransform.identity.translatedBy(
            x: staticAnchorPoint.x - newStaticAnchorPoint.x,
            y: staticAnchorPoint.y - newStaticAnchorPoint.y
        ))
        return translated
    }
}

fileprivate extension View {
    @ViewBuilder
    func customFrame(_ rect: CGRect) -> some View {
        self
            .frame(width: rect.size.width, height: rect.size.height)
            .offset(x: rect.origin.x, y: rect.origin.y)
    }
}

fileprivate struct CropShape: Shape {
    let actualRect: CGRect
    
    func path(in rect: CGRect) -> Path {
        var path = Rectangle().path(in: rect)
        path.addRect(actualRect)
        return path
    }
}
