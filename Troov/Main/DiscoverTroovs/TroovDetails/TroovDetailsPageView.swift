//
//  TroovDetailsPageView.swift
//  Troov
//
//  Created by Levon Arakelyan on 12.12.23.
//

import SwiftUI

struct TroovDetailsPageView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(TRouter.self) var router
    @Environment(DiscoverViewModel.self) var discoverViewModel
    
    @State private var sortedTroovs: [Troov]
    @State private var currentTroovId: String?
    @State private var opacity: Double = 0
    @State private var onTheEdgeTroov = true

    private var isFirstTroov: Bool  {
        currentTroovId == sortedTroovs.first?.troovId
    }
    
    private var isLastTroov: Bool  {
        currentTroovId == sortedTroovs.last?.troovId
    }
    
    
    private var hideBackAndForthButtons: Bool {
        return sortedTroovs.count == 1
    }
    
    private let sliderConfiguration = PageViewConfiguration(sliderInteritemSpacing: 0,
                                                            sliderEdgesHorizontalPadding: 0,
                                                            vAlignment: .center,
                                                            allowScalling: true)
    
    private var currentTroov: Troov? {
        sortedTroovs.first(where: {$0.troovId == currentTroovId})
    }

    private var isOwnTroov: Bool {
        currentTroov?.createdBy?.userId == discoverViewModel.userId
    }
    
    var body: some View {
            PageView(pages: sortedTroovs,
                     positionId: $currentTroovId,
                     configuration: sliderConfiguration) { troov in
                TroovDetailsView(troov: troov)
                .opacity(opacity)
            }.animation(onTheEdgeTroov ? .none : .bouncy, value: currentTroovId)
             .safeAreaPadding(.horizontal, sliderConfiguration.sliderHorizontalEdgesVisibleSize)
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.visible, for: .navigationBar)
            .ignoresSafeArea(edges: .bottom)
            .overlay(alignment: .bottom) {
                HStack(alignment: .center, spacing: 0) {
                    Button(action: previous,
                           label: {
                        Image(isFirstTroov ? "t.left.double.chevron" : "t.left.chevron")
                            .padding(14)
                            .background(Circle().fill(Color.white))
                            .shadow(color: .black.opacity(0.15), radius: 14, x: 0, y: 16)
                    }).buttonStyle(.scalable)
                      .opacity(hideBackAndForthButtons ? 0 : 1)
                      .padding(.leading, 16)
                    Button(action: {
                        removeTroovAndStoreId()
                    },
                           label: {
                        Image("t.xmark.bold")
                            .renderingMode(.template)
                            .foregroundStyle(Color.primaryTroovColor)
                            .padding(18)
                            .background(Circle().fill(Color.white))
                            .shadow(color: .black.opacity(0.15), radius: 14, x: 0, y: 16)
                    }).buttonStyle(.scalable)
                      .padding(.leading, 5)
                    Spacer()
                    Button(action: { chat() },
                           label: {
                        ChatLabel()
                    }).buttonStyle(.scalable)
                        .padding(.horizontal, 10)
                        .disabled(isOwnTroov)
                        .opacity(isOwnTroov ? 0 : 1)
                    Spacer()
                    Button(action: next,
                           label: {
                        Image(isLastTroov ? "t.right.double.chevron" : "t.right.chevron")
                            .padding(14)
                            .background(Circle().fill(Color.white))
                            .shadow(color: .black.opacity(0.15), radius: 14, x: 0, y: 16)
                    }).buttonStyle(.scalable)
                      .opacity(hideBackAndForthButtons ? 0 : 1)
                      .padding(.trailing, 16)
                }
                .padding(.top, 30)
                .ignoresSafeArea()
                .background { 
                    Rectangle()
                        .fill(LinearGradient(colors: [Color.clear,
                                                      Color.black.opacity(0.3)],
                                             startPoint: .top,
                                             endPoint: .bottom))
                        .ignoresSafeArea()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image("t.arrow.narrow.left")
                            .enlargeTapAreaForTopLeadingButton
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                        HStack(alignment: .center, spacing: 10) {
                            Image("t.light.bulb.flash")
                            VStack { // Enclosing VStack for vertical centering
                                Text(currentTroov?.title ?? "")
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .fontWithLineHeight(font: .poppins500(size: 16), lineHeight: 19)
                                    .foregroundColor(.primaryTroovColor)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading) // Maximizes height for center alignment
                        }
                    }
            }
            .onAppear {
                /**
                 Life hack to eliminate an error
                 */
                let id = currentTroovId
                currentTroovId = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                    currentTroovId = id
                })
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    withAnimation {
                        opacity = 1
                    }
                })
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                    onTheEdgeTroov = false
                })        
            }
    }
    
    private func success(_ troov: Troov) {
        Task {
            await MainActor.run {
                if sortedTroovs.count == 1 {
                    discoverViewModel.remove(troov: troov, storeId: false)
                } else {
                    navigateAny()
                    discoverViewModel.remove(troov: troov, storeId: false)
                    let troovs = discoverViewModel.troovs
                    sortedTroovs = troovs
                }
                
                if sortedTroovs.count == 0 {
                    dismiss()
                }
            }
        }
    }

    private func chat() {
        if router.registrationStep == .doItLaterOption {
            router.present(.completeRegistrationView(.joinRequest))
        } else {
            if let troov = currentTroov {
                router.present(.addChatSession(troov: troov))
            }
        }
    }

    private func removeTroovAndStoreId() {
        if let troov = currentTroov,
           let index = sortedTroovs.firstIndex(where: {$0.troovId == troov.troovId}) {
            Task {
                await MainActor.run {
                    navigateAny()
                    discoverViewModel.remove(troov: troov, storeId: true)
                    withAnimation(.smooth) {
                        sortedTroovs.remove(at: index)
                    }
                    if sortedTroovs.count == 0 {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func next() {
        guard let id = currentTroovId else { return }
        if let next = sortedTroovs.nextItem(afterID: id) {
            if onTheEdgeTroov {
                onTheEdgeTroov = false
            }
            currentTroovId = next.troovId
        } else {
            onTheEdgeTroov = true
            currentTroovId = sortedTroovs.first?.troovId
        }
    }
    
    private func previous() {
        guard let id = currentTroovId else { return }
        if let previous = sortedTroovs.previousItem(beforeID: id) {
            if onTheEdgeTroov {
                onTheEdgeTroov = false
            }
            currentTroovId = previous.troovId
        } else {
            onTheEdgeTroov = true
            currentTroovId = sortedTroovs.last?.troovId
        }
    }
    
    private func navigateAny() {
        guard let id = currentTroovId else { return }
        if let next = sortedTroovs.nextItem(afterID: id) {
            if onTheEdgeTroov {
                onTheEdgeTroov = false
            }
            currentTroovId = next.troovId
        } else if let previous = sortedTroovs.previousItem(beforeID: id) {
            withAnimation {
                onTheEdgeTroov = true
                currentTroovId = previous.troovId
            }
        }
    }

    init(troovId: String, troovs: [Troov]) {
        _sortedTroovs = State(initialValue: troovs)
        _currentTroovId = State(initialValue: troovId)
    }
}

#Preview {
    TroovDetailsPageView(troovId: "", troovs: [])
}

fileprivate extension Array where Element == Troov {
    func nextItem(afterID id: String) -> Troov? {
        if let currentIndex = self.firstIndex(where: { $0.id == id }) {
            let nextIndex = self.index(after: currentIndex)
            
            if nextIndex < self.endIndex {
                return self[nextIndex]
            }
        }
        return nil
    }
    
    func previousItem(beforeID id: String) -> Troov? {
        if let currentIndex = self.firstIndex(where: { $0.id == id }) {
            let previousIndex = self.index(before: currentIndex)
            
            if previousIndex >= self.startIndex {
                return self[previousIndex]
            }
        }
        return nil
    }
}

extension TroovDetailsPageView {
    struct ChatLabel: View {
        var body: some View {
            HStack(alignment: .center,
                   spacing: 10) {
                Text("Request")
                    .fontWithLineHeight(font: .poppins600(size: 18), lineHeight: 22)
                Image("t.chat.sign")
                    .renderingMode(.template)
            }.foregroundStyle(Color.white)
             .padding(.vertical, 16)
             .frame(maxWidth: .infinity)
             .background(Capsule().fill(LinearGradient(colors: [Color(hex: "4E5CEC"),
                                                                Color(hex: "#1D2CC6")],
                                                       startPoint: .top,
                                                       endPoint: .bottom)))
             .shadow(color: .black.opacity(0.15), radius: 14, x: 0, y: 16)
        }
    }
}
