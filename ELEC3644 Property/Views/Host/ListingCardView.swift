//
//  ListingCardView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 31/10/24.
//
import SwiftUI

struct ListingCardView: View {
    let property: Property
    var body: some View {
        VStack(spacing: 8) {
            ImageCarouselView(imageUrls: self.property.imageUrls, property: property)
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(property.name)
                        .fontWeight(.bold)
                        .foregroundColor(.neutral100)
                    Text("\(property.subDistrict), \(property.area)")
                        .foregroundColor(.neutral60)
                }
                Spacer()
            }
            .font(.footnote)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }
}

#Preview {
    struct ListingCardViewPreview: View {
        @EnvironmentObject var propertyViewModel: PropertyViewModel
        var body: some View {
            ListingCardView(property: Mock.Properties[0])
        }
    }
    return ListingCardViewPreview()
        .environmentObject(PropertyViewModel())
        .environmentObject(UserViewModel())
}
