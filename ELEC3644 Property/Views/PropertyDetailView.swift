import MapKit
import SwiftUI

struct PropertyDetailView: View {
    let property: Property
    @Environment(\.dismiss) var dismiss

    @State private var location: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0)
    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        latitudinalMeters: 1000,
        longitudinalMeters: 1000
    ))

    var body: some View {
        VStack {
            ScrollView {
                PropertyImageView
                PropertyDetails
                MapView
                Spacer()
            }
            .ignoresSafeArea()

            RequestPropertyView
        }.backButton()
    }

    private var PropertyImageView: some View {
        TabView {
            ForEach(1 ..< 6) { _ in
                Image("Property1")
                    .resizable()
                    .scaledToFill()
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(.page)
        .frame(height: 310)
        .padding(.bottom, 4)
    }

    private var PropertyDetails: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(property.name)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(.neutral100)
                .padding(.bottom, 1)

            Text("\(property.address), \(property.subDistrict)")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.neutral100)

            Text("\(property.district), \(property.area)")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.neutral70)

            Divider()

            VStack {
                HStack {
                    Text("Estate: ")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral70)
                    Spacer()
                    Text(property.estate)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral100)
                }
                HStack {
                    Text("Saleable Area: ")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral70)
                    Spacer()
                    Text("\(property.saleableArea)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral100)
                }
                HStack {
                    Text("Saleable Area/Sqft: ")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral70)
                    Spacer()
                    Text("\(property.saleableAreaPricePerSquareFoot)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral100)
                }
                HStack {
                    Text("Gross Floor Area: ")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral70)
                    Spacer()
                    Text("\(property.saleableArea)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral100)
                }
                HStack {
                    Text("Gross Floor Area/Sqft: ")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral70)
                    Spacer()
                    Text("\(property.saleableAreaPricePerSquareFoot)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral100)
                }
                HStack {
                    Text("Primary School Net: ")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral70)
                    Spacer()
                    Text(property.schoolNet.primary)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral100)
                }
                HStack {
                    Text("Secondary School Net: ")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral70)
                    Spacer()
                    Text(property.schoolNet.secondary)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral100)
                }
                HStack {
                    Text("Building Age: ")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral70)
                    Spacer()
                    Text("\(property.buildingAge)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral100)
                }
                HStack {
                    Text("Building Direction: ")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral70)
                    Spacer()
                    Text("\(property.buildingDirection)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral100)
                }
            }

            Divider()
        }
        .padding(.horizontal, 24)
    }

    private var MapView: some View {
        Map(position: $position) {
            Marker("Here!", coordinate: location)
        }
        .onAppear(perform: geocodeAddress)
        .frame(height: 280)
        .padding(.horizontal, 24)
    }

    private func geocodeAddress() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(property.address) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
            } else if let placemark = placemarks?.first, let marker = placemark.location {
                location = marker.coordinate
                position = .region(MKCoordinateRegion(
                    center: marker.coordinate,
                    latitudinalMeters: 1000,
                    longitudinalMeters: 1000
                ))
            }
        }
    }

    private var RequestPropertyView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("$\(property.netPrice) HKD")
                    .font(.system(size: 16, weight: .bold))
                Text("20 year installments")
                    .font(.system(size: 14, weight: .regular))
            }
            Spacer()
            requestButton
        }
        .padding()
        .background(Color(.systemGray6))
    }

    private var requestButton: some View {
        Text("Request")
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.neutral10)
            .padding()
            .background(Color.primary60)
            .cornerRadius(10)
    }
}

#Preview {
    struct PropertyDetail_Preview: View {
        private var property = Property(
            name: "Grandview Garden - 1E",
            address: "8 Nam Long Shan Road",
            area: "HK Island",
            district: "Central and Western",
            subDistrict: "Sheung Wan",
            facilities: [
                Facility(desc: "mtr", measure: 8, measureUnit: "min(s)")
            ],
            schoolNet: SchoolNet(
                primary: "11",
                secondary: "Central and Western District"
            ),
            saleableArea: 305,
            saleableAreaPricePerSquareFoot: 14262,
            grossFloorArea: 417,
            grossFloorAreaPricePerSquareFoot: 10432,
            netPrice: "7.4M",
            buildingAge: 39,
            buildingDirection: "South East",
            estate: "Grandview Garden"
        )

        var body: some View {
            PropertyDetailView(property: property)
        }
    }

    return PropertyDetail_Preview()
}
