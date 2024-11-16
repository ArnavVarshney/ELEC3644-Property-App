//
//  ImagesSection.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 30/10/2024.
//
import PhotosUI
import SwiftUI

struct ImagesSection: View {
    @Binding var selectedItems: [PhotosPickerItem]
    @Binding var selectedImages: [UIImage]
    var body: some View {
        Form {
            Section {
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
    }
}

struct ImagesSection_Previews: PreviewProvider {
    static var previews: some View {
        ImagesSection(selectedItems: .constant([]), selectedImages: .constant([]))
    }
}
