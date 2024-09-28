//
//  ClassicPopover.swift
//  mango
//
//  Created by Leo on 23.02.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

enum PopoverAcceptancePriority {
    case low
    case high
}

struct ClassicPopover: View {
    let title: String
    let approveTitle: String
    let resignTitle: String
    var height: CGFloat = 197
    var acceptancePriority: PopoverAcceptancePriority = .high
    
    @Binding var showPicker: Bool
    let approve: () -> ()
    var reject: (() -> ())?

    @State private var appeared = false
    @Namespace private var animation

    var body: some View {
        ZStack {
            Color.black
                 .opacity(0.2)
                 .frame(maxWidth: .infinity, maxHeight: .infinity)
                 .opacity(appeared ? 1 : 0)
            if appeared {
                VStack(spacing: 33) {
                    HStack(alignment: .top) {
                        Spacer()
                        Text(title)
                            .fontWithLineHeight(font: .poppins500(size: 16),
                                                lineHeight: 26)
                            .foregroundColor(.primaryBlack)
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        Button(action: {
                            self.disappear()
                        }, label: {
                            Image("t.xmark")
                                .resizable()
                                .frame(width: 10.29,
                                       height: 10.29)
                                .foregroundColor(.primaryBlack)
                        }).padding(.trailing, 20)
                    }

                    HStack(spacing: 8.8) {
                        Spacer()
                        Button(action: {
                            reject?()
                            disappear()
                        }, label: {
                            if acceptancePriority == .high {
                                lowPriorityButtonBody(text: resignTitle)
                            } else {
                                highPriorityButtonBody(text: resignTitle)
                            }
                        }).buttonStyle(.scalable)

                        Button(action: {
                            self.disappear()
                            withAnimation {
                              self.approve()
                            }
                        }, label: {
                            if acceptancePriority == .high {
                                highPriorityButtonBody(text: approveTitle)
                            } else {
                                lowPriorityButtonBody(text: approveTitle)
                            }
                        }).buttonStyle(.scalable)
                        Spacer()
                    }
                }
                 .frame(height: height)
                 .padding(2)
                 .background(content: {
                     RoundedRectangle(cornerRadius: 24)
                         .fill(Color.white)
                         .shadow(radius: 5)
                 })
                 .padding(.horizontal, 20)
                 .matchedGeometryEffect(id: "popover.animation", in: animation, properties: .position, anchor: .top)
            } else {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.02))
                    .frame(height: height)
                    .padding(.horizontal, 100)
                    .matchedGeometryEffect(id: "popover.animation", in: animation, properties: .position, anchor: .top)
            }
        }.background(Color.clear)
         .ignoresSafeArea(edges: .all)
         .frame(maxWidth: .infinity,
                maxHeight: .infinity)
         .onTapGesture(perform: disappear)
         .onAppear {
             withAnimation {
                 appeared = true
             }
         }
    }

    func highPriorityButtonBody(text: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.primaryTroovColor)
                .frame(height: 40.0)
            Text(text)
                .fontWithLineHeight(font: .poppins500(size: 15),
                                    lineHeight: 15)
                .foregroundColor(.white)
        }
    }

    func lowPriorityButtonBody(text: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.primaryBorder, lineWidth: 1)
                .frame(height: 40.0)
            Text(text)
                .fontWithLineHeight(font: .poppins400(size: 15),
                                    lineHeight: 15)
                .foregroundColor(.primaryTroovColor)
        }.background(Color.white)
    }

    private func disappear() {
        withAnimation {
            appeared = false
        }
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            showPicker = false
        })
    }
}
//
//struct ClassicPopover_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassicPopover(title: "You need to register your account first before choosing your date?",
//                       approveTitle: "Register",
//                       resignTitle: "Later",
//                       showPicker: .constant(false)) {}
//    }
//}
