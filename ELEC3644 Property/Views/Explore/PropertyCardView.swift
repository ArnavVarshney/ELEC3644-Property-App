//
//  PropertyCardView.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import SwiftUI

let mockPropertyImages = [
    "Property1",
    "Property2",
    "Property3",
    "Property4",
    "Property5",

]

struct PropertyCardView: View {
    let property: Property

    var body: some View {
        VStack(spacing: 8) {
            ImageCarouselView(images: mockPropertyImages)

            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(property.name)
                        .fontWeight(.bold)

                    Text("\(property.saleableArea)sqft")
                        .foregroundColor(.gray)
                    
                    Text("\(property.subDistrict), \(property.area)")
                        .foregroundColor(.gray)
                    
                    Text("HKD \(property.netPrice)")
                        .foregroundColor(.gray)
                        .fontWeight(.semibold)
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
                        }
                    }
                }
            }
            .font(.footnote)
        }
        .padding(.horizontal)
    }
}

#Preview {
    struct PropertyCard_Preview: View {
        @EnvironmentObject var propertyViewModel: PropertyViewModel

        var body: some View {
            PropertyCardView(property: propertyViewModel.properties[0])
        }
    }

    return PropertyCard_Preview()
        .environmentObject(PropertyViewModel())
}
