//
//  OnboardingView.swift
//  Troov
//
//  Created by Leo on 30.08.2023.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(TRouter.self) var router: TRouter
    @State private var currentPageId: UUID?
    private let pages = Page.pages
    
    var body: some View {
        @Bindable var router = router
        ZStack(alignment: .top,
               content: {
            PageView(pages: pages,
                     positionId: $currentPageId,
                     configuration: .init(sliderInteritemSpacing: 0,
                                          vAlignment: .top)) { page in
                Image("t.onboarding.\(index(page) + 1)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .background(Color.white)
            }
            VStack(alignment: .center,
                   spacing: 18,
                   content: {
                Spacer()
                OnboardingPageControl(bodyText: page.body,
                                      pagesCount: pages.count,
                                      currentPage: currentPageIndex,
                                      onPageChange: onPageChange)
                .allowsHitTesting(false)
                OnboardingBottomToolbar(signIn: signIn,
                                        createAccount: createAccount)
            }).layoutPriority(1)
        }).ignoresSafeArea()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

fileprivate extension OnboardingView {
    /**
     Functional
     */
    func createAccount() {
        Task { await router.auth0(type: .signUp) }
    }
    
    func signIn() {
        Task { await router.auth0(type: .signIn) }
    }
}

fileprivate extension OnboardingView {
    /**
     UI
     */
    struct Page: Identifiable {
        private(set) var id = UUID()
        var body: LocalizedStringKey
    
        init(body: LocalizedStringKey) {
            self.body = body
        }
    }

    var currentPageIndex: Int {
        if let currentPageId = currentPageId,
           let index = pages.firstIndex(where: {$0.id == currentPageId}) {
            return index
        }
        return 0
    }
    
    var page: Page {
       return pages[currentPageIndex]
    }

    func onPageChange(_ newPageIndex: Int) {
        if newPageIndex >= 0 && newPageIndex < pages.count {
            withAnimation {
                currentPageId = pages[newPageIndex].id
            }
        }
    }

    func index(_ page: Page) -> Int {
        if let index = pages.firstIndex(where: {$0.id == page.id}) {
            return index
        }
        return 0
    }
}

fileprivate extension OnboardingView.Page {
    static var pages: [OnboardingView.Page] {
        [.init(body: "Looking for a trail running\npartner?"),
         .init(body: "Join me on a scenic bike tour!"),
         .init(body: "Let's take our dogs for a walk in\nthe park."),
         .init(body: "Pool night at my preferred dive,\nyou in?")]
    }
}
