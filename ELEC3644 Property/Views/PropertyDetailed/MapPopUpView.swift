//
//  MapPopUpView.swift
//  ELEC3644 Property
//
//  Created by Mak Yilam on 27/10/2024.
//

import SwiftUI

struct MapPopUpView: View {
    let property: Property

    var body: some View {
        VStack(spacing: 8) {
            ImageCarouselView(
                imageUrls: self.property.imageUrls, cornerRadius: 0, height: 250, property: property
            )

            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(property.name)
                        .fontWeight(.bold)
                        .foregroundColor(.neutral100)

                    Text("\(property.saleableArea)sqft")
                        .foregroundColor(.neutral60)

                    Text("\(property.subDistrict), \(property.area)")
                        .foregroundColor(.neutral60)

                    Text("HKD \(property.netPrice)")
                        .foregroundColor(.neutral60)
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
                                .foregroundColor(.neutral100)
                        }
                    }
                }
            }
            .font(.footnote)
            .padding(.horizontal)
        }
        .padding(.bottom)
        .background(.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    struct MapPopUp_Preview: View {
        @EnvironmentObject var propertyViewModel: PropertyViewModel

        var body: some View {
            MapPopUpView(property: Mock.Properties[0])
        }
    }

    return MapPopUp_Preview()
        .environmentObject(PropertyViewModel())
        .environmentObject(UserViewModel())
}
