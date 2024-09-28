//
//  BinarySlider.swift
//  mango
//
//  Created by Leo on 06.01.22.
//  Copyright © 2022 Levon Arakelyan. All rights reserved.
//

import SwiftUI

struct BinarySlider: View {
    var suffix: String
    var type: BinarySliderTypes
    var freeze: [BinarySliderFreeze]
    var hide: [BinarySliderHide]

    static var sliderExternalWidth = UIScreen.main.bounds.width

    static let internalPadding: CGFloat = CGFloat(0)
    static let sliderHeight: CGFloat = CGFloat(24)

    static let sliderWidth: CGFloat = CGFloat(BinarySlider.sliderExternalWidth - BinarySlider.internalPadding)
    static let maxX: CGFloat = CGFloat(BinarySlider.internalPadding/2.0 +
                               BinarySlider.sliderWidth -
                                       BinarySlider.yPosition)

    static let minX: CGFloat = CGFloat(BinarySlider.internalPadding/2.0 +
                                       BinarySlider.yPosition)
    static let middleXandY = BinarySlider.maxX - BinarySlider.minX
    
    static private let yPosition: CGFloat = BinarySlider.sliderHeight/2

    @State private var leftCirclePosition = CGPoint(x: BinarySlider.minX,
                                                    y: BinarySlider.yPosition)
    @State private var rightCirclePosition = CGPoint(x: BinarySlider.maxX,
                                                     y: BinarySlider.yPosition)

    @State var leftValue: CGFloat = maxX
    @State var rightValue: CGFloat = minX
    @Binding var values: BinarySliderValues
    var currentValues: [Int] = []

    var body: some View {
        ZStack {
            let hideLeft = hide.contains(.left)
            if hideLeft {
                Color.primaryTroovColor
                    .frame(width: BinarySlider.sliderHeight,
                           height: 2)
                    .position(CGPoint(x: leftCirclePosition.x,
                                      y: BinarySlider.yPosition))
            } else {
                let freezeLeft = freeze.contains(.left)
                NumberedCircle(number: rightValue,
                              suffix: suffix,
                              type: type,
                              forgraundColor: freezeLeft ? Color.white : .primaryTroovColor,
                              value: $values.low)
                    .position(leftCirclePosition)
                    .zIndex(1.0)
                    .gesture(DragGesture().onChanged { value in
                        guard !freezeLeft else { return }
                        if value.location.x < BinarySlider.minX {
                            self.leftCirclePosition = CGPoint(x: BinarySlider.minX,
                                                               y: BinarySlider.yPosition)
                            self.rightValue = BinarySlider.minX

                           return
                        }

                        if value.location.x > self.rightCirclePosition.x - BinarySlider.sliderHeight {
                            return
                        }

                        self.rightValue = value.location.x

                        self.leftCirclePosition = CGPoint(x: value.location.x,
                                                          y: BinarySlider.yPosition)
                    })
            }

            ZStack(alignment: .center) {
                Rectangle()
                    .fill(Color(UIColor.systemGray6))
                    .frame(width: BinarySlider.sliderWidth,
                           height: 2)
                    .position(CGPoint(x: (BinarySlider.minX + BinarySlider.maxX)/2,
                                      y: BinarySlider.yPosition))

                Rectangle()
                    .fill(Color.rgba(17, 45, 106, 1))
                    .frame(width: rightCirclePosition.x - leftCirclePosition.x - BinarySlider.sliderHeight,
                           height: 2)
                    .position(CGPoint(x: (leftCirclePosition.x + rightCirclePosition.x)/2,
                                      y: BinarySlider.yPosition))
            }

            let hideRight = hide.contains(.right)

            if hideRight {
                Color.primaryTroovColor
                    .frame(width: BinarySlider.sliderHeight,
                           height: 2)
                    .position(CGPoint(x: rightCirclePosition.x,
                                      y: BinarySlider.yPosition))
            } else {
                let freezeRight = freeze.contains(.right)
                NumberedCircle(number: leftValue,
                              suffix: suffix,
                              type: type,
                              forgraundColor: freezeRight ? Color.white : .primaryTroovColor,
                              value: $values.high)
                    .position(rightCirclePosition)
                    .zIndex(1.0)
                    .gesture(DragGesture().onChanged { value in
                        guard !freezeRight else { return }
                        if value.location.x > BinarySlider.maxX {
                            self.rightCirclePosition = CGPoint(x: BinarySlider.maxX,
                                                               y: BinarySlider.yPosition)
                            self.leftValue = BinarySlider.maxX

                           return
                        }

                        if value.location.x < self.leftCirclePosition.x + BinarySlider.sliderHeight {
                            return
                        }

                        self.leftValue = value.location.x
                        self.rightCirclePosition = CGPoint(x: value.location.x,
                                                           y: BinarySlider.yPosition)
                    })
            }
        }.frame(width: BinarySlider.sliderExternalWidth,
                height: BinarySlider.sliderHeight,
                alignment: .center)
        .onAppear {
            if currentValues.count == 2,
               let leadingValue = currentValues.first,
               let trailingValue = currentValues.last {
                let rightBody = (BinarySlider.middleXandY * (CGFloat(trailingValue) - self.type.min))/(self.type.max - self.type.min)
                let right = BinarySlider.minX + rightBody
                let leftBody = (BinarySlider.middleXandY * (CGFloat(leadingValue) - self.type.min))/(self.type.max - self.type.min)
                let left = BinarySlider.minX + leftBody

                self.rightCirclePosition = CGPoint(x: right,
                                                       y: BinarySlider.yPosition)
                self.rightValue = left
                self.leftCirclePosition = CGPoint(x: left,
                                                  y: BinarySlider.yPosition)
                self.leftValue = right
            }

        }
    }

     func resetAction() {
        withAnimation {
            self.rightCirclePosition = CGPoint(x: BinarySlider.maxX,
                                               y: BinarySlider.yPosition)
            self.leftValue = BinarySlider.maxX
            self.leftCirclePosition = CGPoint(x: BinarySlider.minX,
                                               y: BinarySlider.yPosition)
            self.rightValue = BinarySlider.minX
        }
    }
}

struct BinarySlider_Previews: PreviewProvider {
    static var previews: some View {
        BinarySlider(suffix: "",
                     type: .age,
                     freeze: [.none],
                     hide: [.none],
                     values: .constant(.init(low: 0, high: 0)))
    }
}

struct NumberedCircle: View {
    var number: CGFloat
    var suffix: String
    var type: BinarySliderTypes
    var forgraundColor: Color

    @Binding var value: Int

    private var convertedValue: CGFloat {
         var finalValue: CGFloat = 0
         let var1 = number - BinarySlider.minX
         let var2 = BinarySlider.middleXandY
         let var3 = type.max - type.min
         let diff = (var3*var1)/var2
         finalValue = diff + type.min
         if value != Int(finalValue) {
             DispatchQueue.main.async {
                 value = Int(finalValue)
             }
         }
         return finalValue
     }

    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .strokeBorder(Color.rgba(17, 45, 106, 1), lineWidth: 2)
                .background(Circle()
                                .fill(forgraundColor))
                .frame(width: BinarySlider.sliderHeight,
                       height: BinarySlider.sliderHeight)
            Text("\(text)\(suffix)")
                .fontWithLineHeight(font: .poppins500(size: 14),
                                    lineHeight: 21)
                .foregroundStyle(Color.rgba(17, 45, 106, 1))
                .padding(.bottom, 5 + BinarySlider.sliderHeight*2)
        }
    }

    private var text: String {
        switch type {
        case .age:
            return "\(Int(convertedValue))"
        case .height:
           return ProfileFilterAttributesMinHeight.heightString(of: Double(convertedValue))
        }
    }
}

struct BinarySliderValues: Equatable {
    var low: Int
    var high: Int

    static func == (lhs: BinarySliderValues, rhs: BinarySliderValues) -> Bool {
        return lhs.low == rhs.low && lhs.high == rhs.high
    }
}

enum BinarySliderTypes {
    case age
    case height
}

extension BinarySliderTypes {
    var min: CGFloat {
        switch self {
        case .age:
            return CGFloat(ProfileFilterAttributes.minAgeRule.minimum!)
        case .height:
            return CGFloat(ProfileFilterAttributesMinHeight.min)
        }
    }

    var max: CGFloat {
        switch self {
        case .age:
            return CGFloat(ProfileFilterAttributes.minAgeRule.maximum!)
        case .height:
            return CGFloat(ProfileFilterAttributesMinHeight.max)
        }
    }

    var minInt: Int {
        Int(min)
    }

    var maxInt: Int {
        Int(max)
    }
}

enum BinarySliderFreeze {
    case left
    case right
    case none
}

enum BinarySliderHide {
    case left
    case right
    case none
}
