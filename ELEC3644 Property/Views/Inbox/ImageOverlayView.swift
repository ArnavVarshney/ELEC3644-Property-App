//
//  ImageOverlayView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 28/11/24.
//

import SwiftUI

struct ImageOverlayView: View {
    let imageUrl: String
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0

    var body: some View {
        VStack {
            Spacer()
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(scale)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                scale = value.magnitude
                                if scale < 1.0 {
                                    scale = 1.0
                                }
                            })
            } placeholder: {
                VStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5, anchor: .center)
                        .padding()
                    Text("Loading...")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width)
                .background(.black.opacity(0.5))
            }
            Spacer()
        }
        .background(Color.black.opacity(0.8))
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            dismiss()
        }
    }
}
