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
        VStack {
            TabView {
                ForEach(1 ..< 6) { _ in
                    Image("Property1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 328, height: 310)
                        .scaledToFit()
                        .cornerRadius(12)
                        .clipped()
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(width: .infinity, height: 310)
            .padding(.bottom, 4)

            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(property.name)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.neutral100)
                        .padding(.bottom, 1)
                    Text("\(property.saleableArea)sqft")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral70)
                    Text("\(property.subDistrict), \(property.area)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral70)
                        .padding(.bottom, 1)
                    Text("HKD \(property.netPrice)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.neutral100)
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
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.neutral100)
                        }
                    }
                }
            }
            .padding(.horizontal, 36)
            .padding(.bottom, 12)
        }
    }
}

#Preview {
    struct PropertyCard_Preview: View {
        private var property = Property(name: "Grandview Garden - 1E",
                                        address: "8 Nam Long Shan Road",
                                        area: "HK Island",
                                        district: "Central and Western",
                                        subDistrict: "Sheung Wan",
                                        facilities: [
                                            Facility(desc: "mtr", measure: 8, measureUnit: "min(s)"),
                                        ],
                                        schoolNet: SchoolNet(
                                            primary: "11",
                                            secondary: "Central and Western District"
                                        ),
                                        saleableArea: 305,
                                        saleableAreaPricePerSquareFoot: 14262,
                                        grossFloorArea: 417,
                                        grossFloorAreaPricePerSquareFoot: 10432,
                                        netPrice: "7.4m",
                                        buildingAge: 39,
                                        buildingDirection: "South East",
                                        estate: "Grandview Garden")
        var body: some View {
            PropertyCardView(property: property)
        }
    }

    return PropertyCard_Preview()
}
