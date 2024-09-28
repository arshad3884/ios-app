//
//  CreateTroovStepTitleGenerateView.swift
//  Troov
//
//  Created by Levon Arakelyan on 15.09.23.
//

import SwiftUI

struct CreateTroovStepTitleGenerateView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var selectedIdea: TActivityIdea
    @State private var allIdeas: [TActivityIdea] = []
    @State private var ideas: [TActivityIdea] = []
    @State private var remainingToGenerate: [TActivityIdea] = []
    private let service = TTroovService()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 17, content: {
                ForEach(ideas, id: \.id) { idea in
                    Button { select(idea) } label: {
                        if selectedIdea.id == idea.id {
                            TSecondaryLabel(text: idea.text,
                                            isFilled: true)
                        } else {
                            TTertiaryLabel(text: idea.text)
                        }
                    }.buttonStyle(.scalable)
                     .padding(1)
                }

                Button(action: generate) {
                    TPrimaryLabel(leadingImage: Image("t.shuffle"),
                                  text: "More suggestions")
                }.buttonStyle(.scalable)
            }).padding(.horizontal, 16.relative(to: .width))
        }
         .padding(.top, 24.relative(to: .height))
         .presentationDetents([.fraction(0.6)])
         .presentationDragIndicator(.visible)
         .presentationCornerRadius(24)
         .onAppear(perform: appear)
    }

    private func select(_ idea: TActivityIdea) {
        withAnimation {
            selectedIdea = idea
        }
        dismiss()
    }

    private func appear() {
        if case .success(let ideas) = service.localActivityIdeas() {
            allIdeas = ideas
            remainingToGenerate = ideas
            generate()
        }
    }

    private func generate() {
        if remainingToGenerate.count >= 5 {
            let random = Array(remainingToGenerate.choose(5))
            ideas = random
            for idea in random {
                remainingToGenerate.removeAll(where: {$0.id == idea.id})
            }
        } else {
            remainingToGenerate = ideas
            generate()
        }
    }
}

struct CreateTroovStepTitleGenerateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTroovStepTitleGenerateView(selectedIdea: .constant(.init(text: "")))
    }
}

fileprivate extension RangeReplaceableCollection {
    /// Returns a new Collection shuffled
    var shuffled: Self { .init(shuffled()) }
    /// Shuffles this Collection in place
    @discardableResult
    mutating func shuffledInPlace() -> Self  {
        self = shuffled
        return self
    }
    func choose(_ n: Int) -> SubSequence { shuffled.prefix(n) }
}

fileprivate extension Collection {
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}
