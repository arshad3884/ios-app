//
//  DiscoverTopToolbarView.swift
//  mango
//
//  Created by Leo on 20.01.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct DiscoverTopToolbarView: View, KeyboardReadable {
    @Environment(DiscoverViewModel.self) var discoverViewModel
    @Environment(TRouter.self) var router

    @Binding var isSearching: Bool
    @Binding var textFieldIsFocused: Bool
    @Binding var searchTriggred: Bool
    @Binding var searchText: String
    
    @FocusState private var isFocused: Bool

    private var filtersExist: Bool {
        discoverViewModel.activeFiltersCount > 0
    }

    private var mapIsVisible: Bool {
        router.appTab == .discover(.Map)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
                Spacer()
                HStack(alignment: .center,
                       spacing: 0) {
                    if !isSearching {
                        if mapIsVisible {
                            Button(action: { router.routeToApp(cycle: .tab, tab: .discover(.List)) }) {
                                Image("t.arrow.narrow.left")
                                    .renderingMode(.template)
                                    .foregroundStyle(Color.primaryTroovColor)
                                    .padding(.vertical, 2)
                                    .padding(.trailing, 10)
                                    .background(Color.white)
                            }
                            .trackRUMTapAction(name: router.dataDogTapAction(named: TTabRoute.discover(.List).dataDogScreenName))
                        }
                        Text("Discover")
                            .fontWithLineHeight(font: .poppins600(size: 22),
                                                lineHeight: 22)
                            .foregroundStyle(Color.primaryTroovColor)
                            .transition(.opacity)
                            .animation(.smooth, value: mapIsVisible)
                        Spacer()
                    }
                    Button(action: showSearch,
                           label: {
                        Image("t.search")
                            .renderingMode(.template)
                            .foregroundColor(isSearching ? Color.primaryBlack : .primaryTroovColor)
                    }).buttonStyle(.scalable(value: 0.9))
                        .padding(.trailing, 10)
                        .padding(.leading, isSearching ? 16.relative(to: .width) : 0)
                    if isSearching {
                        TextField("Search", text: $searchText,
                                  onCommit: textFieldCommit)
                        .focused($isFocused)
                        .fontWithLineHeight(font: .poppins400(size: 16), lineHeight: 16)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 10)
                        .submitLabel(.search)
                        Button(action: clean,
                               label: {
                            Image("t.x.circle")
                                .renderingMode(.template)
                                .foregroundColor(.primaryBlack)
                        }).buttonStyle(.scalable(value: 0.9))
                            .padding(.trailing, 10)
                    }
                    
                    Button(action: { router.present(.filters) },
                           label: {
                        Image("t.filter")
                            .renderingMode(.template)
                            .foregroundColor(isSearching ? .primaryBlack : .primaryTroovColor)
                            .padding(6)
                            .background(content: {
                                if filtersExist && !isSearching {
                                    Circle()
                                        .stroke(Color.primaryTroovColor, lineWidth: 1.5)
                                }
                            })
                            .overlay(alignment: .topTrailing, content: {
                                if filtersExist && !isSearching {
                                    Text("\(discoverViewModel.activeFiltersCount)")
                                        .fontWithLineHeight(font: .poppins600(size: 14),
                                                            lineHeight: 14)
                                        .foregroundStyle(Color.white)
                                        .padding(9)
                                        .background(content: { Circle().fill(Color.primaryTroovColor) })
                                        .overlay {
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                        }
                                        .padding(.top, -16)
                                        .padding(.trailing, -6)
                                        .shadow(radius: 2)
                                }
                            })
                    }).buttonStyle(.scalable(value: 0.9))
                      .padding(.trailing, isSearching ? 16.relative(to: .width) : 0)
                      .disabled(isSearching)
                      .opacity(!isSearching ? 1 : 0.8)
                }.ignoresSafeArea(.keyboard)
                 .padding(10)
                    .overlay(content: {
                        if isSearching {
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color(red: 0.91, green: 0.92, blue: 0.93), lineWidth: 1)
                                .padding(.horizontal, 10)
                        }
                    })
                    .padding(.bottom, 4.relative(to: .height))
            }
            .overlay(alignment: .bottom) {
                Color.rgba(247, 247, 247, 1)
                    .frame(height: 2)
            }
         .frame(height: .navigationBarHeight)
         .toolbar { keyboardToolbarWithDoneAction(complation: {
             if searchText.isClean { clean() }
             else { isFocused = false }
         }) }
         .onChange(of: isFocused) { _, newValue in
             textFieldIsFocused = newValue
         }
    }

    private func clean() {
        searchText = ""
        isFocused = false

        withAnimation {
            isSearching = false
        }
    
        discoverViewModel.tryToFetchTroovs(search: true)
    }

    private func showSearch() {
        withAnimation {
            isSearching.toggle()
        }
    
        if isSearching {
            isFocused = true
        }
    }
    
    private func textFieldCommit() {
        searchTriggred.toggle()
    }
}

struct DiscoverTopToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverTopToolbarView(isSearching: .constant(false), textFieldIsFocused: .constant(false), searchTriggred: .constant(false), searchText: .constant(""))
    }
}
