//
//  ImageCarouselView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 21/10/24.
//

import SwiftUI

struct ImageCarouselView: View {
  let images: [String]
  let height: Double = 320
  var cornerRadius: Double = 8

  var body: some View {
    TabView {
      ForEach(images, id: \.self) { image in
        Image(image)
          .resizable()
          .scaledToFill()
      }
    }
    .frame(height: height)
    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    .tabViewStyle(.page)
  }
}

#Preview {
  ImageCarouselView(images: mockPropertyImages)
}
