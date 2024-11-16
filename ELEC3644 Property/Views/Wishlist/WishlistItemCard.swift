//
//  WishlistItemCard.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 17/11/2024.
//

import SwiftUI

struct WishlistItemCard: View {
    let property: Property
    let picking: Bool
    var picked: Bool

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: property.imageUrls[0])) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(width: 110)
            } placeholder: {
                ProgressView()
            }

            VStack(alignment: .leading) {
                Text(property.name).font(.headline).foregroundStyle(.black)
                Text("\(property.area)")
                Text("MTR info?")
                Spacer()
                HStack {
                    Text("S.A \(property.saleableArea) ft²").foregroundStyle(.black)
                    Text("@ \(property.saleableAreaPricePerSquareFoot)")
                }
                HStack {
                    Text("GFA \(property.grossFloorArea) ft²").foregroundStyle(.black)
                    Text("@ \(property.grossFloorAreaPricePerSquareFoot)")
                }
            }
            .foregroundColor(.neutral60)
            .font(.system(size: 10))
            .lineLimit(1)

            Spacer()
            VStack {
                if picking {
                    HStack {
                        Spacer()
                        Image(systemName: picked ? "checkmark.circle.fill" : "checkmark.circle")
                            .foregroundStyle(picked ? .blue : .black)
                    }
                }
                Spacer()
                HStack {
                    Spacer()
                    Text("\(property.netPrice)")
                }
            }.frame(width: 60)
        }.padding(0)
            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }.foregroundStyle(.black)
    }
}

#Preview {
    WishlistItemCard(property: Mock.Properties.first!, picking: false, picked: false)
}
