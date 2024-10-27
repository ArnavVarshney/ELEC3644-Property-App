//
//  WishlistPropertyComparisonView.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 27/10/2024.
//

import SwiftUI

struct WishlistPropertyComparisonView: View {
    let property1: Property
    let property2: Property
    
    var body: some View {
        NavigationStack{
            ScrollView{
                //Graphical data
                Grid{
                    GridRow{
                        NavigationLink {
                            PropertyDetailView(property: property1)
                        } label: {
                            ImageCarouselView(imageUrls: property1.imageUrls, property: property1)
                        }
                        NavigationLink {
                            PropertyDetailView(property: property2)
                        } label: {
                            ImageCarouselView(imageUrls: property2.imageUrls, property: property2)
                        }
                    }
                    
                //Textual data
                }
                Grid{
                    Divider()
                    GridRow{
                        Text("Name")
                        Text(property1.name)
                        Text(property2.name)
                    }
                    Divider()
                    GridRow{
                        Text("Estate")
                        Text(property1.estate)
                        Text(property2.estate)
                    }
                    Divider()
                    GridRow{
                        Text("Saleable Area/Sqft")
                        Text("\(property1.saleableAreaPricePerSquareFoot)")
                        Text("\(property2.saleableAreaPricePerSquareFoot)")
                    }
                    Divider()
                    GridRow{
                        Text("Gross Floor Area")
                        Text("\(property1.grossFloorArea)")
                        Text("\(property2.grossFloorArea)")
                    }
                    Divider()
                    GridRow{
                        Text("Primary School Net")
                        Text("\(property1.schoolNet.primary)")
                        Text("\(property2.schoolNet.primary)")
                    }
                    Divider()
                    GridRow{
                        Text("Secondary School Net")
                        Text("\(property1.schoolNet.secondary)")
                        Text("\(property2.schoolNet.secondary)")
                    }
                    Divider()
                    GridRow{
                        Text("Building Age")
                        Text("\(property1.buildingAge)")
                        Text("\(property2.buildingAge)")
                    }
                    Divider()
                    GridRow{
                        Text("Building Age")
                        Text("\(property1.buildingAge)")
                        Text("\(property2.buildingAge)")
                    }
                    Divider()
                }
            }
        }
    }
}


#Preview {
    WishlistPropertyComparisonView(property1: Mock.Properties[0], property2: Mock.Properties[1]).environmentObject(UserViewModel())
}
