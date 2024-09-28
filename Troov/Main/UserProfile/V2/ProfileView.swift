//
//  ProfileView.swift
//  Troov
//
//  Created by  Levon Arakelyan on 18.09.2023.
//

import SwiftUI

struct ProfileView: View {
    let logout: () -> ()
    private let profileViewModel = ProfileViewModel.shared
    
    @Environment(TRouter.self) var router: TRouter
    
    @State private var showLogoutAlert = false
    @State private var updateProfilePhotos: Bool = false
    
    @State private var updateImages = false
    
    private var user: User? {
        profileViewModel.user
    }
    
    private var userProfile: UserProfile? {
        user?.userProfile
    }
    
    private let menuItems = ProfileEditMenuItem.allCases
    
    private let imageSize: CGFloat = 120.relative(to: .width)
    
    private var images: [TServerImage] {
        if let image = userProfile?.images.first {
            return [image]
        } else {
            return []
        }
    }
    
    var body: some View {
        VStack(alignment: .center,
               spacing: 0) {
            PrimitiveNavigationBar(title: "Profile")
                .overlay(alignment: .bottomTrailing) {
                    Button(action: requestLogout) {
                        Text("Log out")
                            .fontWithLineHeight(font: .poppins600(size: 18),
                                                lineHeight: 21)
                            .foregroundStyle(Color.primaryTroovRed)
                    }
                    .padding(.bottom, 20.relative(to: .height))
                    .padding(.trailing, 16.relative(to: .height))
                }
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        VStack {
                            Button(action: {
                                updateProfilePhotos.toggle()
                            }) {
                                TImageView(images: images,
                                           size: .init(width: imageSize,
                                                       height: imageSize),
                                           update: updateImages)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 1)
                            }.buttonStyle(.scalable)
                            if let email = user?.email {
                                Text(email)
                                    .fontWithLineHeight(font: .poppins400(size: 14), lineHeight: 14)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.31, green: 0.37, blue: 0.44))
                                    .padding(.vertical, 18.relative(to: .height))
                            }
                        }
                        Spacer()
                    }
                    .padding(.top, 31.relative(to: .height))
                    if router.registrationStep == .doItLaterOption {
                        CompleteRegistrationView()
                            .padding(.vertical, 8)
                    }
                    Text("Personal Details")
                        .fontWithLineHeight(font: .poppins600(size: 16), lineHeight: 16)
                        .foregroundColor(.black)
                        .padding(.bottom, 16.relative(to: .height))
                        .padding(.leading, 8)
                    ForEach(menuItems, id: \.rawValue) { item in
                        Button {
                            editProfile(item)
                        } label: {
                            TInformativeLabel(title: item.profileDetailsEditorMenuName,
                                              bodyText: item.profileDetailsEditorMenuValue(userProfile: userProfile),
                                              erase: { })
                        }.buttonStyle(.scalable)
                    }
                }.padding(.bottom, CGFloat.tabBarHeight)
                    .padding(.horizontal, 20)
            }.padding(.horizontal, 8.relative(to: .width))
        }.alert("Warning", isPresented: $showLogoutAlert,
                actions: {
            Button(role: .destructive,
                   action: logout) {
                Text("Log out")
            }
            Button(role: .cancel,
                   action: { }) {
                Text("Cancel")
            }
        }, message: {
            Text("Are you sure you want ot log out?")
        })
        /**
         TODO: L.A. - move this fullScreenCover into the MainView into the navigation stack
         */
        .fullScreenCover(isPresented: $updateProfilePhotos) {
            NavigationStack {
                ProfileUpdateMedia(user: user!,
                                   imagesUpdate: { updateImages.toggle() })
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
            }
        }
    }
    
    private func requestLogout() {
        showLogoutAlert = true
    }
    
    @MainActor private func editProfile(_ item: ProfileEditMenuItem) {
        router.present(.profile(item: item))
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView {}
    }
}

extension ProfileView {
    struct CompleteRegistrationView: View {
        
        @Environment(TRouter.self) var router
        
        var body: some View {
            VStack(alignment: .center, spacing: 14) {
                Text("Your profile is incomplete. Complete it\nnow to access Troovs and other features")
                    .fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 14)
                    .foregroundStyle(Color.primaryTroovColor)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                Button {
                    completeNow()
                } label: {
                    TPrimaryLabel(text: "Complete Now",
                                  trailingImage: Image("t.arrow.narrow.right"))
                }.buttonStyle(.scalable)
            }
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.primaryTroovColor.opacity(0.06))
            }
        }
        
        private func completeNow() {
            router.completeUncompleteRegistraionNow()
        }
    }
}

