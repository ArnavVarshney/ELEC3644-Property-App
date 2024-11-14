//
//  WishlistDetailView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 26/10/24.
//

import SwiftUI

struct PropertyDetail: Hashable {
    let id: Int
}

enum screenState {
    case view, delete, compare
}

struct WishlistDetailView: View {
    @State private var path = NavigationPath()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userViewModel: UserViewModel

    let wishlist: Wishlist
    let propertyDetail = PropertyDetail(id: 0)

    var properties: [Property] {
        var picked: [Property] = []
        for idx in pickedPropertiesIdx {
            picked.append(wishlist.properties[idx])
        }
        return picked
    }

    @State var state: screenState = .view
    @State var pickedPropertiesIdx: [Int] = []
    @State var showingSheet = false

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(wishlist.properties.indices, id: \.self) { idx in
                    Button {
                        if state == .view {
                            path.append(propertyDetail)
                        } else {
                            //We're picking stuff
                            if pickedPropertiesIdx.contains(idx) {
                                pickedPropertiesIdx.remove(
                                    at: pickedPropertiesIdx.firstIndex(of: idx)!)
                            } else {
                                //For comparison, we can only pick 2
                                if pickedPropertiesIdx.count >= 2 && state == .compare {
                                    pickedPropertiesIdx.removeLast()
                                }
                                pickedPropertiesIdx.append(idx)
                            }
                        }
                    } label: {
                        WishlistItemCard(
                            pickedPropertiesIdx: $pickedPropertiesIdx,
                            property: wishlist.properties[idx], picking: state != .view, idx: idx)
                    }.navigationDestination(for: PropertyDetail.self) { p in
                        PropertyDetailView(property: wishlist.properties[idx])
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }.disabled(state != .view)
                }

                ToolbarItem(placement: .principal) {
                    Text("Wishlist - \(wishlist.name)").bold()
                }

                ToolbarItem(placement: .topBarTrailing) {
                    //delete button
                    Button {
                        //Change state
                        if state != .delete {
                            state = .delete
                        } else {
                            setViewState()
                        }
                    } label: {
                        Image(systemName: "xmark.bin")
                    }.foregroundStyle(getDeleteColor())
                }

                ToolbarItem(placement: .topBarTrailing) {
                    //compare button
                    Button {
                        //change state
                        if state != .compare {
                            state = .compare
                        } else {
                            setViewState()
                        }
                    } label: {
                        Image(systemName: "calendar.day.timeline.trailing").foregroundStyle(
                            getCompareColor())
                    }
                }
            }

            Spacer()
            switch state {
            case .compare:
                if pickedPropertiesIdx.count == 2 {
                    NavigationLink {
                        WishlistPropertyComparisonView(properties: properties).onAppear {
                            setViewState()
                        }
                    } label: {
                        Text("Compare \(properties.count) item\(properties.count > 1 ? "s": "") ")
                    }.buttonStyle(.borderedProminent).frame(width: .infinity)
                }
            case .delete:
                if pickedPropertiesIdx.count > 0 {
                    Button {
                        for property in properties {
                            Task {
                                await userViewModel.postWishlist(
                                    property: property,
                                    folderName: wishlist.name, delete: true)
                            }
                        }

                        Task {
                            await userViewModel.fetchWishlist(with: userViewModel.currentUserId)
                        }

                    } label: {
                        Text("Remove \(properties.count) item\(properties.count > 1 ? "s": "") ")
                    }.buttonStyle(.borderedProminent)
                }
            default:
                Text("").hidden()
            }
        }
    }

    func getDeleteColor() -> Color {
        switch state {
        case .view:
            return .blue
        case .delete:
            return .red
        case .compare:
            return .gray
        }
    }

    func getCompareColor() -> Color {
        switch state {
        case .view:
            return .blue
        case .delete:
            return .gray
        case .compare:
            return .green
        }
    }

    func setViewState() {
        state = .view
        pickedPropertiesIdx = []
        showingSheet = false
    }
}

struct WishlistItemCard: View {
    @Binding var pickedPropertiesIdx: [Int]

    let property: Property
    let picking: Bool
    let idx: Int
    var picked: Bool {
        return pickedPropertiesIdx.contains(idx)
    }

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: property.imageUrls[0])) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(width: 110)
            } placeholder: {
                ProgressView()
            }

            VStack(alignment: .leading) {
                Text(property.name).font(.headline).foregroundStyle(.black)
                Text("\(property.area)")
                Text("MTR info?")
                Spacer()
                HStack {
                    Text("S.A \(property.saleableArea) ft²").foregroundStyle(.black)
                    Text("@ \(property.saleableAreaPricePerSquareFoot)")
                }
                HStack {
                    Text("GFA \(property.grossFloorArea) ft²").foregroundStyle(.black)
                    Text("@ \(property.grossFloorAreaPricePerSquareFoot)")
                }
            }
            .foregroundColor(.neutral60)
            .font(.system(size: 10))
            .lineLimit(1)

            Spacer()
            VStack {
                if picking {
                    HStack {
                        Spacer()
                        Image(systemName: picked ? "checkmark.circle.fill" : "checkmark.circle")
                            .foregroundStyle(picked ? .blue : .black)
                    }
                }
                Spacer()
                HStack {
                    Spacer()
                    Text("\(property.netPrice)")
                }
            }.frame(width: 60)
        }.padding(0)
            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }.foregroundStyle(.black)
    }
}

let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = "HKD"
    formatter.currencySymbol = "$"
    formatter.maximumSignificantDigits = 3
    formatter.decimalSeparator = "."
    return formatter
}()

#Preview {
    WishlistDetailView(wishlist: Mock.Users[0].wishlists[0]).environmentObject(UserViewModel())
}
