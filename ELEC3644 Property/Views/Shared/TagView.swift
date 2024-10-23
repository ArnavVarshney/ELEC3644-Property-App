//
//  Tag.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import SwiftUI

struct TagView: View {
  @Binding var tag: Tag
  @State var isPresented = false

  var body: some View {
    Button {
      isPresented = true
    } label: {
      Text(tag.content?.isEmpty == false ? tag.content! : tag.label)
        .font(.system(size: 12, weight: .medium))
        .foregroundStyle(.neutral10)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(tag.content?.isEmpty == false ? .primary60 : .neutral100)
        .cornerRadius(12)
    }.sheet(isPresented: $isPresented) {
      if tag.label == "Location" {
        LocationSheetView(tag: $tag)
      }
    }
  }
}

#Preview {
  struct TagView_Preview: View {
    @State private var tag1 = Tag(label: "Location")
    @State private var tag2 = Tag(label: "Not yet implemented")

    var body: some View {
      TagView(tag: $tag1)
      TagView(tag: $tag2)
    }
  }

  return TagView_Preview()
}
