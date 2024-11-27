//
//  PropertyCardView.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//
import SwiftUI

struct PropertyCardView: View {
    let property: Property
    var body: some View {
        VStack(spacing: 8) {
            ImageCarouselView(
                imageUrls: self.property.imageUrls, property: property, favoritable: true
            )
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(property.name)
                        .fontWeight(.bold)
                        .foregroundColor(.neutral100)
                    Text("\(property.saleableArea)sqft")
                        .foregroundColor(.neutral70)
                    HStack(spacing: 0) {
                        Text(LocalizedStringKey(property.subDistrict))
                        Text(", ")
                        Text(LocalizedStringKey(property.area))
                    }
                    .foregroundColor(.neutral70)
                    Text("\(property.netPrice.toCompactCurrencyFormat())")
                        .foregroundColor(.neutral70)
                        .fontWeight(.semibold)
                        .padding(.top, 1)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    ForEach(property.facilities) { facility in
                        HStack {
                            Image("\(facility.desc)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            Text("\(facility.measure) \(facility.measureUnit)")
                                .fontWeight(.semibold)
                                .foregroundColor(.neutral100)
                        }
                    }
                }
            }
            .font(.footnote)
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    struct PropertyCard_Preview: View {
        @EnvironmentObject var propertyViewModel: PropertyViewModel
        var body: some View {
            PropertyCardView(property: Mock.Properties[0])
        }
    }
    return PropertyCard_Preview()
        .environmentObject(PropertyViewModel())
        .environmentObject(UserViewModel())
}
