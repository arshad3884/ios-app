//
//  TroovEditorView.swift
//  Troov
//
//  Created by leo on 23.10.2023.
//

import SwiftUI

struct CropImageEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var pickedImages: [PickedImage]
    @Binding var selectedImageIndex: Int
    
    @State private var crop = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $selectedImageIndex) {
                    ForEach(pickedImages.indices, id: \.self) { index in
                        ZStack {
                            Color.black
                            CropImageView(pickedImages: $pickedImages,
                                          selectedImageIndex: $selectedImageIndex,
                                          crop: crop,
                                          currentImageIndex: index,
                                          next: next(_:))
                        }
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                .padding(10)
                .navigationTitle("Crop Image")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color.black, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .background { Color.black.ignoresSafeArea() }
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .bold()
                                .imageScale(.large)
                                .enlargeTapAreaCircledButton
                        }
                        Spacer()
                        Button(action: { crop.toggle() },
                               label: {
                            Image(systemName: "crop")
                                .bold()
                                .imageScale(.large)
                                .enlargeTapAreaCircledButton

                        })
                        Button {
                            crop.toggle()
                            dismiss()
                        } label: {
                            Image(systemName: "checkmark")
                                .bold()
                                .imageScale(.large)
                                .enlargeTapAreaCircledButton
                        }
                    }
                }
            }
        }
    }

    private func next(_ index: Int) {
        guard pickedImages.count > 1 else {
            dismiss()
            return
        }
        
        if index < pickedImages.count - 1 {
            withAnimation {
                selectedImageIndex += 1
            }
        } else {
            withAnimation {
                selectedImageIndex = 0
            }
       }
    }
}

#Preview {
    CropImageEditorView(pickedImages: .constant([]),
                        selectedImageIndex: .constant(0))
}
