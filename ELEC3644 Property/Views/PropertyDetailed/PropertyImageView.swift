//
//  PropertyImageView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//

import SwiftUI

struct PropertyImageView: View {
    var body: some View {
        TabView {
            ForEach(1 ..< 6) { index in
                Image("Property\(index)")
                    .resizable()
                    .scaledToFill()
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(.page)
        .frame(height: 310)
        .padding(.bottom, 4)
    }
}
