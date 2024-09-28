//
//  CreateDateView.swift
//  mango
//
//  Created by Leo on 25.02.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI
import Combine

struct CreateTroovView: View, KeyboardReadable {
    var troov: Troov?

    @Environment(\.dismiss) private var dismiss
    @Environment(MyTroovsViewModel.self) var myTroovViewModel
    @State private var viewModel = CreateTroovViewModel()
    @State private var cancellables : Set<AnyCancellable> = []
    @State private var step: Step = .title
    @State private var showingWarning = false
    @State private var warning = ""
    @State private var isLoading = false
    @State private var keyboardIsOpen = false
    @State private var bottomBarSize: CGSize = .zero
        
    private var isUpdate: Bool {
        troov != nil
    }

    private var backgroundColor: Color {
        if step == .preview {
            return Color(red: 0.97,
                         green: 0.97,
                         blue: 0.97)
        }
        return .white
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .center, spacing: 0) {
                if step != .end && step != .preview {
                    CreateTroovTopBarView(step: step)
                }
                if step == .end {
                    Spacer()
                    CreateTroovStepEndView()
                        .transition(.opacity)
                        .animation(.smooth, value: step)
                } else {
                    ScrollView(showsIndicators: false) {
                        CreateTroovBodyView(step: step)
                            .padding(.vertical, 22.relative(to: .height))
                            .offset(y: keyboardIsOpen ? -step.keyboardOffset(padding: viewModel.keyboardPadding) : 0)
                            .padding(.bottom, bottomBarSize.height + 10)
                    }.containerRelativeFrame(.horizontal)
                }
                Spacer()
            }.background(backgroundColor)
            BottomBarButtonView(isPrimary: viewModel.isNextAllowed,
                                text: step.buttonTitle(isUpdate: isUpdate),
                                action: { nextAction() })
            .readSize { size in
                if bottomBarSize != size {
                    bottomBarSize = size
                }
            }
        }
        .ignoresSafeArea(edges: [.horizontal, .bottom])
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: appear)
        .environment(viewModel)
        .onTapGesture(perform: endEditing)
        .toolbar(step == .end ? .hidden : .visible,
                 for: .navigationBar)
        .toolbar {
            if step == .dateLocationTag {
                keyboardToolbarHashtag {
                    viewModel.createHashtag.toggle()
                }
            } else {
                keyboardToolbar
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button(action: previousAction) {
                    Image("t.arrow.narrow.left")
                        .enlargeTapAreaForTopLeadingButton
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text(step.title(isUpdate: isUpdate))
                    .fontWithLineHeight(font: .poppins600(size: 16), lineHeight: 16)
                    .foregroundColor(.rgba(51, 51, 51, 1))
            }
            
            if step == .preview {
                @Bindable var viewModel = viewModel
                ToolbarItem(placement: .topBarTrailing) {
                    TToggleView(isOn: $viewModel.previewCellIsBig)
                        .frame(width: 72,
                               height: 38)
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
        .alert("", isPresented: $showingWarning) {
            Button("Ok") {}
        } message: {
            Text(warning)
                .fontWithLineHeight(font: .poppins600(size: 16), lineHeight: 16)
        }
    }
    
    @MainActor private func nextAction() {
        guard viewModel.allowNext() else { return }
        
        if step == .end {
            dismiss()
            return
        }
        
        Task {
            if step == .preview {
                isLoading = true
                let result = await myTroovViewModel.createUpdateTroov(isUpdate: isUpdate,
                                                                      troov: viewModel.troov)
                switch result {
                case .success:
                    await MainActor.run(body: {
                        isLoading = false
                        step = .end
                    })
                case .failure:
                    await MainActor.run(body: {
                        warning = "Something went wrong!"
                        showingWarning = true
                        isLoading = false
                    })
                    return
                case .moderationFailure:
                    await MainActor.run(body: {
                        warning = "This troov violates our content policy. Please try again."
                        showingWarning = true
                        isLoading = false
                    })
                    return
                }
            }
            
            if let next = step.next() {
                withAnimation {
                    step = next
                }
            }
        }
    }
    
    private func previousAction() {
        if let previous = step.previous() {
            withAnimation {
                step = previous
            }
        } else {
            dismiss()
        }
    }
    
    private func appear() {
        if let troov = troov {
            viewModel.initialSetup(troov: troov)
        } else if viewModel.troov == nil {
            viewModel.initialSetup(troov: nil)
        }
        keyboardPublisher.sink { isOpen in
            if [Step.title, Step.dateLocationTag].contains(step) {
                withAnimation {
                    if keyboardIsOpen != isOpen {
                        keyboardIsOpen = isOpen
                    }
                }
            }
        }.store(in: &cancellables)
    }

    init(troov: Troov? = nil) {
        self.troov = troov
    }
}

struct CreateTroovView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTroovView()
    }
}

fileprivate extension MyTroovsViewModel {
    func createUpdateTroov(isUpdate: Bool, troov: Troov?) async -> CreateTroovViewModel.Response {
        guard var troov = troov else { return .failure }
        /**
         To make sure we alwasy send troov to server with valid date at the end, even though we checked its validity along the way
         */
        let validTime = troov.startTime?.validTroovStartTimeDuringCreation
        troov.troovCoreDetails?.startTime = validTime
        
        if isUpdate {
            switch await service.update(troov: troov) {
            case .success(_):
                await fetchOwnTroovs()
                return .success
            case .failure(let error):
                if error.message.contains("content not allowed") {
                    return .moderationFailure
                }
                return .failure
            }
        } else {
            switch await service.create(troov: troov) {
            case .success(_):
                await fetchOwnTroovs()
                return .success
            case .failure(let error):
                if error.message.contains("content not allowed") {
                    return .moderationFailure
                }
                return .failure
            }
        }
    }
}
