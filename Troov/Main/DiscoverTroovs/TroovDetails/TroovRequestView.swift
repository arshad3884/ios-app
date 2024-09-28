//
//  TroovRequestView.swift
//  Troov
//
//  Created by Levon Arakelyan on 13.10.23.
//

import SwiftUI

struct TroovRequestView: View {
    let troov: Troov?

    @Environment(ChatViewModel.self) var chatViewModel
    @Environment(MyTroovsViewModel.self) var myTroovsViewModel
    
    @Environment(\.dismiss) private var dismiss
    @State private var openChat = false
    @State private var showAccept = false
    @State private var showImagePresenter = false
    @State private var rejectMatchWarning = false
    
    private var match: TroovMatchRequest? {
        myTroovsViewModel.currentTroovMatchRequest
    }
    
    private var firstName: String {
        if let firstName = match?.requester?.firstName {
            return firstName
        }
        return ""
    }
    
    private var age: String {
        if let age = match?.requester?.age {
            return "\(age)"
        }
        return ""
    }
    
    private var images: [TServerImage] {
        if let images = match?.requester?.images {
            return images
        }
        return []
    }
    
    private var userId: String {
        myTroovsViewModel.userId
    }
    
    private var timeLeftIsCritical: (String, Bool) {
        if let matchRequest = troov?.matchRequests?.first(where: {$0.requester?.userId == userId}),
           let expiresAt = matchRequest.expiresAt {
            return expiresAt.timeLeftIsCritical
        }
        return ("Expired", true)
    }
    
    var body: some View {
        VStack(spacing: 14) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 17) {
                    TroovCellExpandedImageSlider(name: firstName,
                                                 age: age,
                                                 images: images)
                    .onTapGesture(perform: presentImages)
                    if let requester = match?.requester {
                        TroovDetailsBasicInfoView(requester: requester)
                            .padding(.bottom, 57)
                    }
                }
            }
            BottomBarView(accept: acceptDialogue,
                          reply: reply,
                          decline: {
                rejectMatchWarning = true
            })
        }.navigationBarBackButtonHidden()
            .padding(.top, 12)
            .padding(.horizontal, 15)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: close) {
                        Image("t.arrow.narrow.left")
                            .enlargeTapAreaForTopLeadingButton
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(alignment: .center,
                           spacing: 10,
                           content: {
                        Image("t.light.bulb.flash")
                        Text(troov?.title ?? "")
                            .lineLimit(2)
                            .fontWithLineHeight(font: .poppins500(size: 16), lineHeight: 19)
                            .foregroundColor(.primaryTroovColor)
                        Spacer()
                    })
                }
            }.navigationDestination(isPresented: $openChat) {
                ChatView()
            }
            .sheet(isPresented: $showAccept) {
                AcceptDialogueView(accept: {
                    Task {
                        await myTroovsViewModel.confirmCurrentMatchRequest()
                        dismiss()
                    }
                },
                                   item: .init(images: images,
                                               name: troov?.createdBy?.firstName ?? "Unknown",
                                               startTime: troov?.startTime ?? .now))
            }
            .fullScreenCover(isPresented: $showImagePresenter, content: {
                ImagePresenterView(images: images)
                    .presentationBackground(Color.black.opacity(0.8))
            }).overlay(content: {
                if rejectMatchWarning {
                    ClassicPopover(title: "Remove this request?",
                                   approveTitle: "Yes",
                                   resignTitle: "No",
                                   height: 150,
                                   acceptancePriority: .low,
                                   showPicker: $rejectMatchWarning) {
                        myTroovsViewModel.declineMatch()
                        dismiss()
                    }
                }
            })
    }
    
    private func close() {
        dismiss()
    }
    
    private func acceptDialogue() {
        showAccept = true
    }
    
    private func reply() {
        if let troov = troov, let match = match {
            chatViewModel.openChatSession(troov: troov,
                                          match: match)
            openChat = true
        }
    }
    
    private func presentImages() {
        showImagePresenter = true
    }
}

#Preview {
    TroovRequestView(troov: .preview)
}

extension TroovRequestView {
    struct BottomBarView: View {
        let accept: () -> ()
        let reply: () -> ()
        let decline: () -> ()
        
        var body: some View {
            HStack(spacing: 8) {
                Button(action: accept) {
                    TCapsuleLabel(text: "Accept",
                                  imageName: "t.chat.sign")
                }.buttonStyle(.scalable)
                Button(action: reply) {
                    TCapsuleLabel(text: "Reply",
                                  imageName: "t.toolbar.chat")
                }.buttonStyle(.scalable)
                
                Button(action: decline,
                       label: {
                    RoundedButton(image: "t.xmark",
                                  imageColor: .white,
                                  fill: .primaryTroovRed,
                                  size: .init(width: 30,
                                              height: 30),
                                  imageSize: .init(width: 12, height: 12),
                                  corner: 15)
                }).buttonStyle(.scalable)
            }
        }
    }
    
    struct AcceptDialogueView: View {
        @Environment(\.dismiss) private var dismiss
        let accept: () -> ()
        let item: Item

        private var images: [TServerImage] {
            item.images
        }

        private var name: String {
            item.name
        }

        private var startTime: Date? {
            item.startTime
        }
        
        private var time: String {
            if let startTime = startTime {
                return "\(startTime.getHourFromDate) on \(startTime.getDayFromDate)th, \(startTime.getMonth)"
            }
            
            return ""
        }
        
        var body: some View {
            VStack(spacing: 24) {
                TImageView(images: images,
                           size: .init(width: 130, height: 130))
                .clipShape(Circle())
                Text("Accept \(name)’s request to join your troov at \(time)")
                    .padding(.horizontal)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                HStack(spacing: 16) {
                    Button(action: {
                        accept()
                        dismiss()
                    }) {
                        TCapsuleLabel(text: "Accept",
                                      imageName: "t.chat.sign")
                    }.buttonStyle(.scalable)
                    Button(action: { dismiss() }) {
                        TCapsuleLabel(imageName: "t.xmark.bold",
                                      imageWidth: 14,
                                      fill: .primaryTroovRed)
                    }.buttonStyle(.scalable)
                }
            }.padding(.horizontal, 20)
                .presentationDetents([.height(368)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(24)
        }
    }
}

extension TroovRequestView.AcceptDialogueView {
    struct Item: Identifiable {
        let id = UUID()
        let images: [TServerImage]
        let name: String
        let startTime: Date?
    }
}
