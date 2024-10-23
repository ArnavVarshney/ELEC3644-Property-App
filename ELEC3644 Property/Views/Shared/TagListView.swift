//
//  TagList.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import SwiftUI

struct TagListView: View {
  @Binding var tags: [Tag]

  var body: some View {
    HStack(spacing: 12) {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 18) {
          ForEach($tags, id: \.self) { tag in
            TagView(tag: tag)
          }
        }
      }
      HStack(spacing: 8) {
        Button {
        } label: {
          Image(systemName: "arrow.up.arrow.down")
        }
      }
    }.padding(.vertical, 6)
  }
}
