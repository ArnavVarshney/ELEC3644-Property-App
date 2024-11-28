//
//  ImagesSection.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 30/10/2024.
//
import PhotosUI
import SwiftUI

struct NamedImage: Identifiable {
    let id = UUID()
    let image: UIImage
    let name: String
}

struct ImagesSection: View {
    @Binding var selectedItems: [PhotosPickerItem]
    @Binding var selectedImages: [UIImage]
    
    @Binding var selectedVRItems: [PhotosPickerItem]
    @Binding var selectedVRImages: [NamedImage]
    
    @State private var isNamingImage = false
    @State private var tempImage: UIImage?
    @State private var imageName = ""
    
    var body: some View {
        Form {
            Section(header: Text("Images")) {
                let columns = [
                    GridItem(.flexible(), spacing: 48),
                    GridItem(.flexible(), spacing: 48),
                    GridItem(.flexible(), spacing: 48),
                ]
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(0..<selectedImages.count, id: \.self) { index in
                            Image(uiImage: selectedImages[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    Button {
                                        selectedImages.remove(at: index)
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.neutral10)
                                            .padding(4)
                                    }
                                    .padding(4), alignment: .topTrailing
                                )
                                .padding(.horizontal, 6)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, 0)
                }
                PhotosPicker(
                    selection: $selectedItems,
                    maxSelectionCount: 24,
                    matching: .images
                ) {
                    Label("Add Photos", systemImage: "plus.circle.fill")
                        .foregroundColor(.neutral100)
                }.foregroundColor(.neutral100)
            }
            
            Section(header: Text("VR Images")) {
                let columns = [
                    GridItem(.flexible(), spacing: 48),
                    GridItem(.flexible(), spacing: 48),
                    GridItem(.flexible(), spacing: 48),
                ]

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(selectedVRImages) { namedImage in
                            VStack {
                                Image(uiImage: namedImage.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay(
                                        Button {
                                            selectedVRImages.removeAll { $0.id == namedImage.id }
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.neutral10)
                                                .padding(4)
                                        }
                                        .padding(4), alignment: .topTrailing
                                    )
                                Text(namedImage.name)
                                    .font(.caption)
                                    .foregroundColor(.neutral100)
                            }
                            .padding(.horizontal, 6)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, 0)
                }
                PhotosPicker(
                    selection: $selectedVRItems,
                    maxSelectionCount: 1,
                    matching: .images
                ) {
                    Label("Add VR Photos", systemImage: "plus.circle.fill")
                        .foregroundColor(.neutral100)
                }.foregroundColor(.neutral100)
            }
        }
        .onChange(
            of: selectedItems
        ) { _, newValue in
            Task {
                selectedImages = []
                for item in newValue {
                    if let data = try? await item.loadTransferable(type: Data.self),
                        let image = UIImage(data: data)
                    {
                        selectedImages.append(image)
                    }
                }
            }
        }
        .onChange(
            of: selectedVRItems
        ) { _, newValue in
            Task {
                for item in newValue {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data)
                    {
                        tempImage = image
                        isNamingImage = true
                    }
                }
                selectedVRItems = []
            }
        }
        .alert("Name Your VR Image", isPresented: $isNamingImage) {
            TextField("Image Name", text: $imageName)
            Button("Save") {
                if let image = tempImage {
                    selectedVRImages.append(NamedImage(image: image, name: imageName))
                    imageName = ""
                    tempImage = nil
                }
            }
            Button("Cancel", role: .cancel) {
                imageName = ""
                tempImage = nil
            }
        } message: {
            Text("Please enter a name for your VR image")
        }
    }
}

struct ImagesSection_Previews: PreviewProvider {
    static var previews: some View {
        ImagesSection(
            selectedItems: .constant([]),
            selectedImages: .constant([]),
            selectedVRItems: .constant([]),
            selectedVRImages: .constant([])
        )
    }
}
