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
        GeometryReader { geometry in
            VStack(spacing: 8) {
                ImageCarouselView(imageUrls: self.property.imageUrls)
                    .frame(height: geometry.size.height * 0.1) // Adjust height as needed

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
                
                Spacer() // Pushes content to the top if needed
            }
            .frame(width: geometry.size.width, height: geometry.size.height * 0.5) // Set to half screen height
            .background(Color.white) // Background color for the pop-up
            .cornerRadius(20) // Rounded corners for the pop-up
            .shadow(radius: 10) // Shadow for depth
        }
        .edgesIgnoringSafeArea(.all) // Ignore safe area to allow full-width pop-up
    }
}
#Preview {
    struct MapPopUp_Preview: View {
      @EnvironmentObject var propertyViewModel: PropertyViewModel

      var body: some View {
        PropertyCardView(property: Mock.Properties[0])
      }
    }

    return MapPopUp_Preview()
      .environmentObject(PropertyViewModel())
}
