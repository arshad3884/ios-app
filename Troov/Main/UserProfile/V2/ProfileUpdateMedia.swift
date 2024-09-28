//
//  ProfileUpdateMedia.swift
//  Troov
//
//  Created by Levon Arakelyan on 14.10.23.
//

import SwiftUI

struct ProfileUpdateMedia: View {
    @Environment(\.dismiss) private var dismiss
    let user: User
    let imagesUpdate: () -> ()
    private let registerViewModel: RegisterViewModel

    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            RegistrationAddImageView(parent: .profile)
            Spacer()
            BottomBarButtonView(isPrimary: registerViewModel.isNextAllowed,
                                text: "Update",
                                action: update)
        }.environment(registerViewModel)
            .edgesIgnoringSafeArea(.bottom)
            .background(Color.white)
            .navigationTitle("Edit Your Profile Pictures")
            .task {
                if let profile = ProfileViewModel.shared.user,
                   let images = profile.userProfile?.images {
                   await registerViewModel.profileMediaUpdateSetup(serverImages: images)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image("t.arrow.narrow.left")
                            .enlargeTapAreaForTopLeadingButton
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: editPhotos) {
                        Image("t.photo.edit")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(Color.primaryTroovColor)
                            .frame(width: 18, height: 18)
                            .padding(6)
                            .background {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .shadow(radius: 2)
                                    Circle()
                                        .fill(Color.primaryTroovColor.opacity(0.2))
                                }
                            }
                    }
                }
            }.overlay {
                if isLoading {
                    TProgress.Lottie() {
                        isLoading = false
                    }
                }
            }
    }
    
    private func update() {
        guard registerViewModel.allowNext() else { return }
        isLoading = true
        Task {
            do {
                try await registerViewModel.uploadMediaAndFetchUser(step: nil)
                await MainActor.run {
                    isLoading = false
                    dismiss()
                    imagesUpdate()
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    if let error = error as? TRequestError,
                       case .mediaFailed(let array) = error {
                        debugPrint(array?.first?.errorMessage ?? error.message)
                    }  else {
                        debugPrint(String(describing: error))
                    }
                }
            }
        }
    }

    private func editPhotos() {
        registerViewModel.showImagePicker = true
    }

    init(user: User,
         imagesUpdate: @escaping () -> ()) {
        self.user = user
        self.imagesUpdate = imagesUpdate
        self.registerViewModel = .init(withActivities: false,
                                       user: user)
    }
}

#Preview {
    ProfileUpdateMedia(user: .preview,
                       imagesUpdate: {})
}
