//
//  MenuItemView.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import SwiftUI

struct MenuItemView: View {
  let item: MenuItem

  var body: some View {
    VStack {
      Image(systemName: item.systemImage)
        .resizable()
        .scaledToFit()
        .frame(width: 24, height: 24)
      Text(item.rawValue)
        .font(.system(size: 12, weight: .medium))
    }
    .padding(.all, 8)
    .frame(height: 60)
    .padding(.bottom, 4)
  }
}

#Preview {
  MenuItemView(item: MenuItem.buy)
}
