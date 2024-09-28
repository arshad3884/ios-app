//
//  DiscoverSearchView.swift
//  Troov
//
//  Created by Leo on 02.10.2023.
//

import SwiftUI

struct DiscoverSearchView: View, KeyboardReadable {
    var searchTriggred: Bool = false
    @Binding var searchText: String
    private let service = TSearchService()
    
    @State private var mostPopularTags: [SearchTag] = []
    @State private var activeTags: [String] = []
    @State private var hideSearchOffers = false
    @State private var isLoading = false
    @Environment(DiscoverViewModel.self) var discoverViewModel
    
    private let leadingSpacing: CGFloat = 0
    private let vSpacing: CGFloat = 10
    private let hSpacing: CGFloat = 10
    
    private var searchResults: [String]? {
        if searchText.isEmpty {
            return nil
        } else {
            return activeTags.filter { $0.contains(searchText) }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Type something in the search field to find results")
                    .padding(.horizontal, 49)
                    .padding(.top, 47)
                    .fontWithLineHeight(font: .poppins400(size: 16), lineHeight: 16)
                Image("t.search.pic")
                Text("Trending Hashtags:")
                    .fontWithLineHeight(font: .poppins400(size: 16), lineHeight: 16)
                FlexibleStack(alignment: .center) {
                    ForEach(mostPopularTags) { tag in
                        Button(action: { search(tagName: tag.tagName) }) {
                            TTagTextField.Label(image: "t.hash",
                                                text: tag.tagName,
                                                isSelected: true,
                                                height: 40,
                                                fontSize: 12)
                        }.buttonStyle(.scalable)
                    }
                }
                .padding(.horizontal, 49)
                Spacer()
            }.padding(.bottom, 70)
        }
        .multilineTextAlignment(.center)
        .background(Color.white)
        .onChange(of: searchTriggred, { _, _ in
            search(tagName: searchText)
        })
        .overlay(alignment: .topLeading) {
            if !hideSearchOffers,
               let results = searchResults, isSearchContainElement() {
                ScrollView {
                    VStack(alignment: .leading, spacing: 11) {
                        ForEach(results, id: \.self) { tag in
                            Button(action: { search(tagName: tag) }) {
                                HStack {
                                    hilightedText(str: tag, searched: searchText)
                                        .fontWithLineHeight(font: .poppins400(size: 16), lineHeight: 16)
                                        .foregroundStyle(Color.primaryBlack)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }.background(Color.white)
                            }.buttonStyle(.scalable)
                            if isTagLast(tag: tag, array: results) {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color(red: 0.91, green: 0.92, blue: 0.93))
                            }
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.vertical, 13)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 4)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 380)
                }
            }
        }
        .overlay(content: {
            if isLoading {
                TProgress.Lottie() {
                    isLoading = false
                }
            }
        })
        .onChange(of: searchText, { oldValue, newValue in
            if oldValue != newValue && hideSearchOffers {
                hideSearchOffers = false
            }
        })
        .task {
            await getTags()
        }
    }
    
    private func isTagLast(tag: String, array: [String]) -> Bool {
        if array.last == tag {
            return false
        }
        return true
    }
    
    private func hilightedText(str: String, searched: String) -> Text {
        guard !str.isEmpty && !searched.isEmpty else { return Text(str) }
        
        var result: Text!
        let parts = str.components(separatedBy: searched)
        for i in parts.indices {
            result = (result == nil ? Text(parts[i]) : result + Text(parts[i]))
            if i != parts.count - 1 {
                result = result + Text(searched).bold()
            }
        }
        return result ?? Text(str)
    }
    
    private func isSearchContainElement() -> Bool {
        if let results = searchResults {
            for word in results {
                if word.contains(searchText) {
                    return true
                }
            }
        }
        return false
    }
    
    private func getTags() async {
        let result = await service.mostPopularTags(count: 5)
        switch result {
        case .success(let tags):
            await MainActor.run {
                withAnimation {
                    self.mostPopularTags = tags
                }
            }
        case .failure(let failure):
            debugPrint("failure: ", failure)
        }
        
        let activeResult = await service.activeTags()
        
        switch activeResult {
        case .success(let tags):
            await MainActor.run {
                self.activeTags = tags
            }
        case .failure(let failure):
            debugPrint("failure: ", failure)
        }
    }
    
    private func search(tagName: String) {
        withAnimation {
            isLoading = true
        }
        searchText = tagName
        endEditing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            hideSearchOffers = true
        })
        
        Task {
            await discoverViewModel.searchByTerm(term: tagName)
            
            await MainActor.run {
                withAnimation {
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    DiscoverSearchView(searchTriggred: false,
                       searchText: .constant(""))
}
