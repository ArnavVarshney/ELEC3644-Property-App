//
//  ImageCarouselView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 21/10/24.
//

import SwiftUI

struct ImageCarouselView: View {
    let property: Property
    let images: [String]
    let imageUrls: [String]
    let height: Double
    let favoritable: Bool
    var cornerRadius: Double

    init(
        images: [String] = [], imageUrls: [String] = [], cornerRadius: Double = 8,
        height: Double = 320,
        property: Property? = nil,
        favoritable: Bool = false
    ) {
        self.images = images
        self.imageUrls = imageUrls
        self.cornerRadius = cornerRadius
        self.height = height
        self.property = property ?? Mock.Properties[0]
        self.favoritable = favoritable
    }

    var body: some View {
        ZStack {
            if favoritable {
                VStack {
                    HStack {
                        Spacer()
                        favoriteIcon(property: property)
                    }
                    Spacer()
                }.padding(5).zIndex(1)
            }

            TabView {
                if imageUrls.isEmpty {
                    ForEach(images, id: \.self) { image in
                        Image(image)
                            .resizable()
                            .scaledToFill()
                    }
                } else {
                    ForEach(imageUrls, id: \.self) { imageUrl in
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
            }
        }.frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .tabViewStyle(.page)
    }
}

#Preview {
    ImageCarouselView(
        imageUrls: Mock.Properties[0].imageUrls, property: Mock.Properties[0], favoritable: true
    )
    .environmentObject(UserViewModel())
}
