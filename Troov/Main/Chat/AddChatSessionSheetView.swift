//
//  AddChatSessionSheetView.swift
//  Troov
//
//  Created by Levon Arakelyan on 15.09.23.
//

import SwiftUI

struct AddChatSessionSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(MyTroovsViewModel.self) var myTroovsViewModel

    private let service = TTroovService()
    
    let troov: Troov
    let success: (Troov) -> ()


    @State private var step: Step = .first
    @State private var message: String = ""
    @State private var messageValidationState: ValidationState = .missing
    @State private var isLoading = false
    @State private var isShowingWarning = false
    @State private var warning = "Your message violates our terms of service. Please try a different messge."
    @State private var triggerAttentionAnimation: Bool = false
    @FocusState private var isFocused: Bool

    private var isValid: Bool {
        messageValidationState == .valid
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ScrollView(showsIndicators: false) {
                TImageView(images: troov.serverImages,
                           size: .init(width: step == .first ? 130.relative(to: .width) : 100.relative(to: .width),
                                       height: step == .first ? 130.relative(to: .width) : 100.relative(to: .width)))
                .clipShape(Circle())
                .padding(.bottom, 24.relative(to: .height))
                Text(step.title(name: troov.firstName))
                    .fontWithLineHeight(font: .poppins500(size: 15), lineHeight: 15)
                    .foregroundStyle(Color.rgba(17, 24, 39, 1))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 14.relative(to: .height))
                HStack(alignment: .top, spacing: 0) {
                    TextField("Enter your message", text: $message, axis: .vertical)
                        .lineLimit(1...3)
                        .fontWithLineHeight(font: .poppins400(size: 16), lineHeight: 23)
                        .focused($isFocused)
                        .padding(20.relative(to: .height))
                        .overlay(alignment: .topTrailing) {
                            ValidatorView<Int, Float>(input: .string(input: message,
                                                                     rule: Chat.messageContentRule),
                                                      output: validate(_:))
                                .padding(20.relative(to: .height))
                        }.disabled(step == .success || isLoading)
                         .overlay(alignment: .trailing) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .padding(.trailing, 10)
                            }
                        }
                }
                .frame(maxWidth: .infinity)
                .softAttentionAnimation(triggerAttention: triggerAttentionAnimation && messageValidationState != .valid,
                                        ceaseAnimation: isFocused,
                                        background: .roundedRectangle(radius: 16))
                .padding(.horizontal, 5)
                if let text = step.notification {
                    HStack(alignment: .center, spacing: 10) {
                        Text(text)
                            .fontWithLineHeight(font: .poppins500(size: 16), lineHeight: 16)
                            .foregroundColor(.rgba(17, 24, 39, 1))
                        Image("t.checkmark")
                            .renderingMode(.template)
                            .foregroundColor(.rgba(56, 218, 102, 1))
                    }
                    .padding(.top, 14.relative(to: .height))
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }.padding(.top, 24.relative(to: .height))

            Button(action: next) {
                if isValid {
                    TPrimaryLabel(text: step.buttonName,
                                  isLoading: isLoading)
                    .disabled(isLoading)
                    .opacity(isLoading ? 0.9 : 1)
                } else {
                    TSecondaryLabel(text: step.buttonName)
                }
            }.disabled(isLoading)
             .padding(.top, 24.relative(to: .height))
        }.padding(.horizontal, 42.relative(to: .width))
            .alert(warning, isPresented: $isShowingWarning,
                   actions: {
                Button("OK") {}
            })
         .presentationDetents([.height(543.relative(to: .height))])
         .presentationDragIndicator(.visible)
         .presentationCornerRadius(24)
         .interactiveDismissDisabled(isLoading)
    }
    
    private func next() {
        if step == .success {
            dismiss()
            return
        }
        guard isValid else {
            if isFocused {
                isFocused = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5,
                                              execute: {
                    triggerAttentionAnimation.toggle()
                })
            } else {
                triggerAttentionAnimation.toggle()
            }
            return
        }
        guard let userId = service.userId,
              let troovId = troov.troovId else { return }
        Task {
            isLoading = true
            let chat = Chat(createdAt: .now,
                            createdByUserId: userId,
                            messageContent: message)
            switch await service.join(by: troovId, chat: chat) {
            case .success(let message):
                debugPrint(message)
                self.refershMyTroovs()
                self.proceed()
            case .failure(let error):
                isShowingWarning = true
                debugPrint(String(describing: error))
            }
            isLoading = false
        }
    }

    private func refershMyTroovs() {
        Task { await myTroovsViewModel.fetchTheirTroovs() }
    }

    private func proceed() {
        success(troov)
        if let next = step.next() {
            withAnimation {
                step = next
            }
        }
    }

    private func validate(_ state: ValidationState) {
        messageValidationState = state
    }
}

struct AddChatSessionSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddChatSessionSheetView(troov: .init()) {_ in}
    }
}

extension AddChatSessionSheetView {
    enum Step {
        case sendMessage
        case success
    }
}

extension AddChatSessionSheetView.Step {
    static var first: AddChatSessionSheetView.Step {
        return .sendMessage
    }
    
    var image: String {
        switch self {
        case .sendMessage: return "t.circle.avatar.demo"
        case .success: return "t.envelop.checkmark"
        }
    }
    
    func title(name: String) -> String {
        return "Send an opening message to \(name). They have 24 hours to respond or the chat will go away."
    }
    
    var notification: String? {
        switch self {
        case .sendMessage: return nil
        case .success: return "Your message has been sent!"
        }
    }
    var buttonName: String {
        switch self {
        case .sendMessage: return "Send Message"
        case .success: return "Okay"
        }
    }
    
    func next() -> AddChatSessionSheetView.Step? {
        switch self {
        case .sendMessage: return .success
        case .success: return nil
        }
    }
}
