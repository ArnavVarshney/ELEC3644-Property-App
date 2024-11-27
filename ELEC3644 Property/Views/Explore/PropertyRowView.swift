//
//  PropertyRowView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 26/11/2024.
//

import SwiftUI

struct PropertyRowView: View {
    let property: Property

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: property.imageUrls[0])) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 114, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .padding(.trailing, 4)
            Spacer()
            VStack(alignment: .leading) {
                Text("\(property.name)")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.neutral100)
                HStack(alignment: .center) {
                    Text(
                        property.netPrice.toCompactCurrencyFormat()
                    )
                    .font(.subheadline)
                    .foregroundColor(.neutral70)
                    Spacer()
                }
                HStack {
                    Text(property.contractType)
                        .font(.subheadline)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(.neutral100)
                        .cornerRadius(4)
                        .foregroundColor(.neutral10)
                    Spacer()
                }
            }
        }
    }
}
