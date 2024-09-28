//
//  CropImageLibraryView.swift
//  Troov
//
//  Created by leo on 23.10.2023.
//

import SwiftUI
import PhotosUI

struct CropImageLibraryView: View {
    @Environment(\.dismiss) private var dismiss
    
    let pickedImages: [UIImage]
    let pickImages: ([(UIImage, Data)]) -> ()

    @State private var images: [PickedImage] = []
    
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var showPhotosPicker: Bool = false
    @State private var showCropView: Bool = false
    @State private var selectedImageIndex: Int = 0
    @State private var isLoading = false
    @State private var draggingImage: PickedImage?
    @State private var showWarningOfCancelingChanges = false

    private let spacing: CGFloat = 2.0
    
    private var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: spacing, alignment: .center),
            GridItem(.flexible(), spacing: spacing, alignment: .center)
        ]
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(images, id: \.id) { pickedImage in
                            Rectangle()
                                .fill(Color.white)
                                .frame(maxWidth: .infinity)
                                .aspectRatio(TFImage.reverseScale, contentMode: .fit)
                                .onTapGesture(perform: {
                                    tapOnImage(pickedImage)
                                })
                                .overlay(alignment: .center) {
                                    Image(uiImage: pickedImage.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .allowsHitTesting(false)
                                }.clipShape(RoundedRectangle(cornerRadius: 5))
                                 .overlay(alignment: .topTrailing) {
                                     VStack(alignment: .trailing, spacing: 0) {
                                         EditLabel()
                                         Spacer()
                                         AddImageCardView.IndexView(index: imageIndex(of: pickedImage))
                                             .padding(5)
                                     }
                                }
                                 .overlay(alignment: .bottomLeading,
                                          content: {
                                     Button(action: { remove(pickedImage) }) {
                                         Image(systemName: "trash")
                                             .imageScale(.large)
                                             .foregroundStyle(Color.primaryTroovRed)
                                             .padding(12)
                                             .background {
                                                 Circle()
                                                     .fill(Material.ultraThick)
                                             }.padding(10)
                                     }.buttonStyle(.scalable)
                                 })
                                .onDrag({
                                    self.draggingImage = pickedImage
                                    return NSItemProvider(item: pickedImage.id as NSString, typeIdentifier: "public.plain-text")
                                })
                                .onDrop(of: [UTType.text],
                                        delegate: DragRelocateDelegate(item: pickedImage,
                                                                       listData: $images,
                                                                       current: $draggingImage))

                    }
                }.padding(.top, 2)
                Spacer()
            }
            .overlay(alignment: .center, content: {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(Color.primaryTroovColor)
                } else if images.count == 0 {
                    Button(action: {
                        pickImageFromGallery()
                    }, label: {
                        Text("No image is selected.")
                            .fontWithLineHeight(font: .poppins400(size: 14),
                                                lineHeight: 20)
                            .foregroundStyle(Color.primaryTroovColor)
                    }).buttonStyle(.scalable)
                }
            })
            .photosPicker(isPresented: $showPhotosPicker,
                          selection: $selectedImages,
                          maxSelectionCount: 5,
                          selectionBehavior: .ordered,
                          matching: PHPickerFilter.images)
            .onChange(of: selectedImages) { _, newValue in
                onUpdate(newValue)
            }
            .preferredColorScheme(.light)
            .navigationTitle("Upload profile photos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                        showWarningOfCancelingChanges = true
                    },
                           label: {
                        Image(systemName: "xmark")
                            .bold()
                            .imageScale(.large)
                            .enlargeTapAreaCircledButton
                    }).disabled(isLoading)
                    Spacer()
                    Button {
                        pickImageFromGallery()
                    } label: {
                        Image(systemName: "plus")
                            .bold()
                            .imageScale(.large)
                            .enlargeTapAreaCircledButton
                    }.disabled(isLoading)
                    if images.count > 0 {
                        Button(action: pick,
                               label: {
                            Image(systemName: "checkmark")
                                .bold()
                                .imageScale(.large)
                                .enlargeTapAreaCircledButton
                        }).disabled(isLoading)
                    }
                }
            }
            .fullScreenCover(isPresented: $showCropView) {
                CropImageEditorView(pickedImages: $images,
                                    selectedImageIndex: $selectedImageIndex)
            }
            .onAppear(perform: appear)
            .alert("", isPresented: $showWarningOfCancelingChanges) {
                Button(role: .cancel,
                       action: { },
                       label:  {
                    Text("Cancel")
                })
                Button(role: .destructive,
                       action: {
                    dismiss()
                }, label:  {
                    Text("Confirm")
                })
            } message: {
                Text("This will undo all your recent updates.")
            }
        }
    }

    private func pickImageFromGallery() {
        reorderSelectedPickerImages()
        showPhotosPicker.toggle()
    }
    
    private func tapOnImage(_ image: PickedImage) {
        if let index = images.firstIndex(where: {$0.id == image.id}) {
            selectedImageIndex = index
        }
        showCropView.toggle()
    }
    
    private func pick() {
        if images.count != 0 {
            isLoading = true
            Task {
                var croppedImages: [(UIImage, Data)] = []
                for image in images {
                    if let croppedImage = image.image.checkAndCrop() {
                        croppedImages.append((croppedImage, croppedImage.resizeByByte(maxByte: 2000000)))
                    }
                }
                isLoading = false
                pickImages(croppedImages)
                dismiss()
            }
        } else {
            dismiss()
        }
    }
    
    private func appear() {
        images = pickedImages.map({.init(image: $0.fixImageOrientation, pickerItem: nil)})
        
        if images.count == 0 {
            showPhotosPicker = true
        }
    }
    
    private func remove(_ image: PickedImage) {
        if let index = images.firstIndex(where: {$0.id == image.id}) {
            withAnimation {
                images.remove(at: index)
            }
        }
    }

   @MainActor private func onUpdate(_ photos: [PhotosPickerItem]) {
        isLoading = true
        Task {
            var imagesArray: [PickedImage] = []
            for item in photos {
                //fixImageOrientation
                do {
                    if let imageData = try await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: imageData)?.fixImageOrientation {
                        imagesArray.append(.init(image: image,
                                                 pickerItem: item))
                    }
                } catch {
                    debugPrint(String(describing: error))
                }
            }
            
            if imagesArray.count == 5 {
                await MainActor.run(body: {
                    self.images = imagesArray
                })
            } else {
                var orderedArray: [PickedImage] = self.images
        
                for pickedImage in imagesArray {
                    if !orderedArray.contains(where: {$0.pickerItem == pickedImage.pickerItem}) {
                        orderedArray.insert(pickedImage, at: 0)
                    }
                }
                
                await MainActor.run(body: {
                    self.images = Array(orderedArray.prefix(5))
                })
            }
            
            isLoading = false
        }
    }

    private func imageIndex(of image: PickedImage) -> Int? {
        if let index = images.firstIndex(where: {$0.id == image.id}) {
            return index + 1
        }
        return nil
    }

    private func editPhotos() {
        if let image = images.first {
            tapOnImage(image)
        }
    }

    private func reorderSelectedPickerImages() {
        var arrayOfPickerImages: [PhotosPickerItem] = []
        for image in images {
            if let pickerImage = image.pickerItem {
                arrayOfPickerImages.append(pickerImage)
            }
        }
    
        selectedImages = arrayOfPickerImages
    }
}

#Preview {
    CropImageLibraryView(pickedImages: [],
                         pickImages: { _ in })
}

fileprivate extension CropImageLibraryView {
    struct DragRelocateDelegate: DropDelegate {
        let item: PickedImage
        @Binding var listData: [PickedImage]
        @Binding var current: PickedImage?

        func dropEntered(info: DropInfo) {
            if item != current {
                if let from = listData.firstIndex(of: current!),
                   let to = listData.firstIndex(of: item) {
                    if listData[to].id != current!.id {
                        withAnimation {
                            listData.move(fromOffsets: IndexSet(integer: from),
                                toOffset: to > from ? to + 1 : to)
                        }
                    }
                }
            }
        }

        func dropUpdated(info: DropInfo) -> DropProposal? {
            return DropProposal(operation: .move)
        }

        func performDrop(info: DropInfo) -> Bool {
            self.current = nil
            return true
        }
    }
}

struct PickedImage: Identifiable, Equatable {
    let id = UUID().uuidString
    var image: UIImage
    let pickerItem: PhotosPickerItem?
}

extension CropImageLibraryView {
    struct EditLabel: View {
        var compact: Bool = false

        var body: some View {
            Image("t.photo.edit")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.primaryBlack)
                .frame(width: compact ? 12 : 18,
                       height: compact ? 12 : 18)
                .padding(compact ? 6 : 12)
                .background {
                    Circle()
                        .fill(Material.ultraThick)
                }.padding([.horizontal, .top], compact ? 5 : 10)
        }
    }
}
