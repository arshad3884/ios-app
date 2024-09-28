//
//  RegistrationAddImageView.swift
//  mango
//
//  Created by Leo on 12.01.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct RegistrationAddImageView: View {
    let parent: Parent

    @Environment(RegisterViewModel.self) var registerViewModel: RegisterViewModel
    
    @State private var showingPhotoUploadPolicyPopover = false

    private var pickedImages: [UIImage] {
        return media
            .filter({$0.image != nil})
            .map({$0.image!})
    }
    
    private var filteredMedia: [TProfileMedia] {
        registerViewModel.filteredMedia
    }
    
    private var media: [TProfileMedia] {
        registerViewModel.media
    }
    
    private var firstMedia: TProfileMedia? {
        media.first
    }

    private var showImageUploadFailedWarning: Bool {
        media.contains(where: {$0.failure != nil})
    }
    
    var body: some View {
        @Bindable var registerViewModel = registerViewModel
        VStack(alignment: .center,
               spacing: 0) {
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 14.relative(to: .height), content: {
                if let firstMedia = firstMedia {
                    AddImageCardView(media: firstMedia,
                                     index: imageIndex(of: firstMedia),
                                     pick:  { select(firstMedia) },
                                     cornerRadius: 12)
                        .onTapGesture { select(firstMedia) }
                        .onLongPressGesture {unselect(firstMedia) }
                        .aspectRatio(TFImage.reverseScale, contentMode: .fill)
                        .frame(width: 305.relative(to: .width))
                }
                LazyHGrid(rows: [GridItem(.flexible())],
                          alignment: .center,
                          spacing: 12.relative(to: .height),
                          content: {
                    ForEach(media.suffix(4), id: \.id) { media in
                        AddImageCardView(media: media,
                                         compact: true,
                                         index: imageIndex(of: media)) { select(media) }
                            .onTapGesture { select(media) }
                            .onLongPressGesture {unselect(media) }
                            .aspectRatio(TFImage.reverseScale, contentMode: .fill)
                            .frame(width: 66.relative(to: .width))
                        //Edit Your Profile Pictures
                    }
                })
            }).padding([.horizontal, .bottom], 30.relative(to: .width))
              .padding(.top, 10)
              .transition(.move(edge: .bottom))
              .animation(.smooth, value: showImageUploadFailedWarning)
        }.fullScreenCover(isPresented: $registerViewModel.showImagePicker) {
            CropImageLibraryView(pickedImages: pickedImages,
                                 pickImages: picked(_:))
        }
        .sheet(isPresented: $showingPhotoUploadPolicyPopover,
               content: {
            PhotoPolicyView()
                .presentationDetents([.height(350)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(24)
        })
         .onAppear(perform: appear)
         .onChange(of: showImageUploadFailedWarning, { _, newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        registerViewModel.showImageUploadWarning = true
                    })
                }
            })
    }

    private func select(_ media: TProfileMedia) {
        registerViewModel.showImagePicker = true
    }
    
    private func unselect(_ media: TProfileMedia) {
        registerViewModel.unselect(media: media)
    }

    private func appear() {
        registerViewModel.validateMedia()
        guard parent == .registration else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2,
                                      execute: {
            showingPhotoUploadPolicyPopover = true
        })
    }

    private func picked(_ images: [(UIImage, Data)]) {
        DispatchQueue.main.async {
            registerViewModel.picked(images)
        }
    }

    private func imageIndex(of media: TProfileMedia) -> Int? {
        if let index = filteredMedia.firstIndex(where: {$0.id == media.id}) {
            return index + 1
        }
        return nil
    }
}

struct RegistrationAddImageView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationAddImageView(parent: .registration)
    }
}
 
extension RegistrationAddImageView {
    struct PhotoPolicyView: View {
        
        @Environment(\.dismiss) private var dismiss
        @State private var openURL = false

        var body: some View {
            VStack {
                Button(action: openLink) {
                    Image("t.info.fill")
                }
                .buttonStyle(.scalable)
                .padding(.top, 24)
                Spacer()
                Text("Note: You must upload at least\n2 photos and they must include\na face and not violate our\ncontent policy!")
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fontWithLineHeight(font: .poppins500(size: 18), lineHeight: 21)
                    .foregroundStyle(Color.primaryBlack)
                    .onTapGesture(perform: openLink)
                Spacer()
                Button(action: buttonAction) {
                    TPrimaryLabel(text: "Okay")
                }.containerRelativeFrame(.horizontal) { value, _ in
                    return value * 0.75
                }
                .padding(.bottom, 24)
            }
            .sheet(isPresented: $openURL) {
                WebView(url: URL(string: "https://troov.app/terms_of_services")!)
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(24)
            }
        }

        private func buttonAction() {
            dismiss()
        }

        private func openLink() {
            openURL = true
        }
    }
}

extension RegistrationAddImageView {
    enum Parent {
        case registration
        case profile
    }
}
