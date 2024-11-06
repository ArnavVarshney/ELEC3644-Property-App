//
//  WishlistPropertyComparisonView.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 27/10/2024.
//

import SwiftUI

struct WishlistPropertyComparisonView: View {
    @Environment(\.dismiss) private var dismiss
    let properties: [Property]

    var body: some View {
        NavigationStack {
            if !properties.isEmpty{
                ScrollView {
                    //Graphical data
                    Grid {
                        GridRow {
                            ForEach(properties.indices, id:\.self){
                                idx in
                                let property = properties[idx]
                                NavigationLink {
                                    PropertyDetailView(property: property)
                                } label: {
                                    ImageCarouselView(imageUrls: property.imageUrls, property: property)
                                }
                            }
                        }

                        //Textual data
                    }
                    Grid(alignment: .leading) {
                        Divider()
                        GridRow {
                            Text("Name")
                            ForEach(properties.indices, id:\.self){
                                idx in
                                let property = properties[idx]
                                Text(property.name)
                            }
                        }
                        Divider()
                        GridRow {
                            Text("Estate")
                            ForEach(properties.indices, id:\.self){
                                idx in
                                let property = properties[idx]
                                Text(property.estate)
                            }
                        }
                        Divider()
                        GridRow {
                            Text("Saleable Area/Sqft")
                            ForEach(properties.indices, id:\.self){
                                idx in
                                let property = properties[idx]
                                Text("\(property.saleableAreaPricePerSquareFoot)")
                            }
                        }
                        Divider()
                        GridRow {
                            Text("Gross Floor Area")
                            ForEach(properties.indices, id:\.self){
                                idx in
                                let property = properties[idx]
                                Text("\(property.grossFloorArea)")
                            }
                        }
                        Divider()
                        GridRow {
                            Text("Primary School Net")
                            ForEach(properties.indices, id:\.self){
                                idx in
                                let property = properties[idx]
                                Text("\(property.schoolNet.primary)")
                            }
                        }
                        Divider()
                        GridRow {
                            Text("Secondary School Net")
                            ForEach(properties.indices, id:\.self){
                                idx in
                                let property = properties[idx]
                                Text("\(property.schoolNet.secondary)")
                            }
                        }
                        Divider()
                        GridRow {
                            Text("Building Age")
                            ForEach(properties.indices, id:\.self){
                                idx in
                                let property = properties[idx]
                                Text("\(property.buildingAge)")
                            }
                        }
                        Divider()
                    }
                }
            }
            else{
                Image(systemName: "hifispeaker.badge.plus")
                    .font(.largeTitle)
                    .padding()

                Text("Nothing to view or compare")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .padding(4)

                Text("Try to pick and choose from your displayed wishlist")
                    .font(.footnote)
                    .foregroundColor(.neutral60)
                    .padding(4)
            }
        }.padding()
    }
}

#Preview {
    WishlistPropertyComparisonView(properties: [Mock.Properties[0], Mock.Properties[1]])
        .environmentObject(UserViewModel())
}
