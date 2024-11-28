//
//  PropertyListingForm.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 30/10/2024.
//
import PhotosUI
import SwiftUI

//TODO: Acually submit the property
//TODO: Add message after submit
//TODO: Form validation; Type checking
struct PropertyListingForm: View {
    @State private var propertyName = ""
    @State private var address = ""
    @State private var selectedArea = ""
    @State private var selectedContractType = "Buy"
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
    @State private var propertyType = ""
    @State private var primarySchoolNet = ""
    @State private var secondarySchoolNet = ""
    @State private var facilities: [Facility] = []
    @State private var facilityDescription = ""
    @State private var facilityMeasure = ""
    @State private var facilityUnit = ""
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedVRItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var selectedVRImages: [NamedImage] = []
    @State private var selectedTab = 0
    @EnvironmentObject var propertyViewModel: PropertyViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TabView(selection: $selectedTab) {
                    BasicInfoSection(
                        propertyName: $propertyName, address: $address, estate: $estate,
                        buildingDirection: $buildingDirection, buildingAge: $buildingAge,
                        selectedArea: $selectedArea, selectedDistrict: $selectedDistrict,
                        selectedSubDistrict: $selectedSubDistrict,
                        propertyType: $propertyType
                    )
                    .tag(0)
                    PropertyDetailsSection(
                        netPrice: $netPrice, saleableArea: $saleableArea,
                        saleableAreaPricePerSqFt: "\(netPrice)",
                        grossFloorArea: $grossFloorArea,
                        grossFloorAreaPricePerSqFt: "\(grossFloorArea)",
                        contractType: $selectedContractType
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
                    ImagesSection(
                        selectedItems: $selectedItems, selectedImages: $selectedImages,
                        selectedVRItems: $selectedVRItems, selectedVRImages: $selectedVRImages
                    )
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
                        .background(disabledButton(at: selectedTab) ? Color.gray : Color.primary60)
                        .cornerRadius(10)
                        .disabled(disabledButton(at: selectedTab))
                    } else {
                        Button("Submit") {
                            Task {
                                await submitForm()
                            }
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.neutral10)
                        .padding()
                        .background(disabledButton(at: selectedTab) ? Color.gray : Color.primary60)
                        .cornerRadius(10)
                        .disabled(disabledButton(at: selectedTab))
                    }
                }
                .padding()
            }
            .navigationTitle("List a Property")
        }
    }

    private func addFacility() {
        if !facilityDescription.isEmpty && !facilityMeasure.isEmpty && facilityMeasure.isNumber
            && !facilityUnit.isEmpty
        {
            facilities.append(
                Facility(
                    desc: facilityDescription, measure: Int(facilityMeasure) ?? 0,
                    measureUnit: facilityUnit))
            facilityDescription = ""
            facilityMeasure = ""
            facilityUnit = ""
        }
    }

    private func submitForm() async {
        //TODO:
        //1. Upload image
        //2. Get the image URLs
        //3. Post property <- Need to implement
        var imageUrls: [String] = []
        for image in selectedImages {
            do {
                if let data = image.jpegData(compressionQuality: 1) {
                    let res: Data = try await NetworkManager.shared.uploadImage(
                        imageData: data)
                    let json = try JSONSerialization.jsonObject(with: res, options: [])
                    if let json = json as? [String: Any],
                        let imageUrl = json["url"] as? String
                    {
                        imageUrls.append(imageUrl)
                    }
                }
            } catch {
                print("Error uploading image: \(error)")
            }
        }
        var vrImageUrls: [VRImage] = []
        for image in selectedVRImages {
            do {
                if let data = image.image.jpegData(compressionQuality: 1) {
                    let res: Data = try await NetworkManager.shared.uploadImage(
                        imageData: data)
                    let json = try JSONSerialization.jsonObject(with: res, options: [])
                    if let json = json as? [String: Any],
                        let imageUrl = json["url"] as? String
                    {
                        vrImageUrls.append(VRImage(name: image.name, url: imageUrl))
                    }
                }
            } catch {
                print("Error uploading VR image: \(error)")
            }
        }

        let property = Property(
            id: UUID(),
            name: propertyName,
            address: address,
            area: selectedArea,
            district: selectedDistrict,
            subDistrict: selectedSubDistrict,
            facilities: facilities,
            schoolNet: SchoolNet(primary: primarySchoolNet, secondary: secondarySchoolNet),
            saleableArea: Int(saleableArea) ?? 0,
            saleableAreaPricePerSquareFoot: Int(netPrice) ?? 0,
            grossFloorArea: Int(grossFloorArea) ?? 0,
            grossFloorAreaPricePerSquareFoot: Int(grossFloorArea) ?? 0,
            netPrice: Int(netPrice) ?? 0,
            buildingAge: Int(buildingAge) ?? 0,
            buildingDirection: buildingDirection,
            estate: estate,
            imageUrls: imageUrls,
            vrImageUrls: vrImageUrls,
            transactionHistory: [],
            agent: userViewModel.user,
            amenities: [],
            propertyType: propertyType,
            contractType: selectedContractType,
            isActive: true
        )

        do {
            let res: Property = try await NetworkManager.shared.post(
                url: "/properties", body: property)
            print("[Property WORKING] \(res)")
            dismiss()
        } catch {
            print("Error posting property: \(error)")
        }
    }

    private func disabledButton(at selectedTab: Int) -> Bool {
        switch selectedTab {
        case 0:
            return propertyName.isEmpty || address.isEmpty || estate.isEmpty
                || buildingDirection.isEmpty || !buildingAge.isNumber || selectedArea.isEmpty
                || selectedDistrict.isEmpty || selectedSubDistrict.isEmpty
                || propertyType.isEmpty
        case 1:
            return !netPrice.isNumber || !saleableArea.isNumber || !grossFloorArea.isNumber
                || selectedContractType.isEmpty
        case 2:
            return primarySchoolNet.isEmpty || secondarySchoolNet.isEmpty
        case 3:
            return false
        case 4:
            return selectedImages.isEmpty
        default:
            return true
        }
    }
}

struct PropertyDetailsSection: View {
    @Binding var netPrice: String
    @Binding var saleableArea: String
    var saleableAreaPricePerSqFt: String
    @Binding var grossFloorArea: String
    var grossFloorAreaPricePerSqFt: String
    @Binding var contractType: String

    var body: some View {
        Form {
            Section {
                Picker("Contract Type", selection: $contractType) {
                    ForEach(ContractType.allCases, id: \.self) { contract in
                        Text("\(contract)".capitalized).tag("\(contract)".capitalized)
                    }
                }
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
            .environmentObject(UserViewModel())
    }
}
