//
//  PropertyListingForm.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 30/10/2024.
//
import PhotosUI
import SwiftUI

struct PropertyListingForm: View {
    @State private var propertyName = ""
    @State private var address = ""
    @State private var selectedArea = ""
    @State private var selectedDistrict = ""
    @State private var selectedSubDistrict = ""
    @State private var estate = ""
    @State private var buildingDirection = ""
    @State private var saleableArea = ""
    @State private var saleableAreaTotalPrice = ""
    @State private var grossFloorArea = ""
    @State private var grossFloorAreaTotalPrice = ""
    @State private var netPrice = ""
    @State private var buildingAge = ""
    @State private var primarySchoolNet = ""
    @State private var secondarySchoolNet = ""
    @State private var facilities: [(description: String, measure: String, unit: String)] = []
    @State private var facilityDescription = ""
    @State private var facilityMeasure = ""
    @State private var facilityUnit = ""
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var selectedTab = 0
    @EnvironmentObject var propertyViewModel: PropertyViewModel

    private var saleableAreaPricePerSqFt: String {
        guard let area = Double(saleableArea), area > 0,
            let total = Double(netPrice)
        else { return "0" }
        return String(format: "%.2f", total / area)
    }

    private var grossFloorAreaPricePerSqFt: String {
        guard let area = Double(grossFloorArea), area > 0,
            let total = Double(netPrice)
        else { return "0" }
        return String(format: "%.2f", total / area)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TabView(selection: $selectedTab) {
                    BasicInfoSection(
                        propertyName: $propertyName, address: $address, estate: $estate,
                        buildingDirection: $buildingDirection, buildingAge: $buildingAge,
                        selectedArea: $selectedArea, selectedDistrict: $selectedDistrict,
                        selectedSubDistrict: $selectedSubDistrict
                    )
                    .tag(0)
                    PropertyDetailsSection(
                        netPrice: $netPrice, saleableArea: $saleableArea,
                        saleableAreaPricePerSqFt: saleableAreaPricePerSqFt,
                        grossFloorArea: $grossFloorArea,
                        grossFloorAreaPricePerSqFt: grossFloorAreaPricePerSqFt
                    )
                    .tag(1)
                    SchoolNetSection(
                        primarySchoolNet: $primarySchoolNet, secondarySchoolNet: $secondarySchoolNet
                    )
                    .tag(2)
                    FacilitiesSection(
                        facilities: $facilities, facilityDescription: $facilityDescription,
                        facilityMeasure: $facilityMeasure, facilityUnit: $facilityUnit,
                        addFacility: addFacility
                    )
                    .tag(3)
                    ImagesSection(selectedItems: $selectedItems, selectedImages: $selectedImages)
                        .tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Rectangle()
                            .fill(index <= selectedTab ? .primary60 : .neutral40)
                            .frame(height: 8)
                    }
                }
                .ignoresSafeArea()
                .padding(.bottom, 12)
                HStack {
                    if selectedTab > 0 {
                        Button {
                            withAnimation {
                                selectedTab -= 1
                            }
                        } label: {
                            Text("Previous")
                                .underline(true, color: .neutral100)
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.neutral100)
                        .padding()
                        .cornerRadius(10)
                    }
                    Spacer()
                    if selectedTab < 4 {
                        Button("Next") {
                            withAnimation {
                                selectedTab += 1
                            }
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.neutral10)
                        .padding()
                        .background(Color.primary60)
                        .cornerRadius(10)
                    } else {
                        Button("Submit") {
                            Task {
                                await submitForm()
                            }
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.neutral10)
                        .padding()
                        .background(Color.primary60)
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("List a Property")
        }
    }

    private func addFacility() {
        if !facilityDescription.isEmpty && !facilityMeasure.isEmpty && !facilityUnit.isEmpty {
            facilities.append((facilityDescription, facilityMeasure, facilityUnit))
            facilityDescription = ""
            facilityMeasure = ""
            facilityUnit = ""
        }
    }

    private func submitForm() async {
        for image in selectedImages {
            // Upload image to server
            // TODO: Implement image upload
        }
    }
}

struct PropertyDetailsSection: View {
    @Binding var netPrice: String
    @Binding var saleableArea: String
    var saleableAreaPricePerSqFt: String
    @Binding var grossFloorArea: String
    var grossFloorAreaPricePerSqFt: String
    var body: some View {
        Form {
            Section {
                TextField("Net Price", text: $netPrice)
                    .keyboardType(.decimalPad)
            }
            Section(header: Text("Saleable Area")) {
                TextField("Area (sq ft)", text: $saleableArea)
                    .keyboardType(.decimalPad)
                HStack {
                    Text("Price per sq ft")
                    Spacer()
                    Text("$\(saleableAreaPricePerSqFt)")
                        .foregroundColor(.secondary)
                }
            }
            Section(header: Text("Gross Floor Area")) {
                TextField("Area (sq ft)", text: $grossFloorArea)
                    .keyboardType(.decimalPad)
                HStack {
                    Text("Price per sq ft")
                    Spacer()
                    Text("$\(grossFloorAreaPricePerSqFt)")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct PropertyListingForm_Previews: PreviewProvider {
    static var previews: some View {
        PropertyListingForm()
            .environmentObject(PropertyViewModel())
    }
}
