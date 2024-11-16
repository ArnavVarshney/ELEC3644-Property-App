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

struct PropertyComparison: Hashable {
    let id: Int
}

enum ScreenState {
    case view, delete, compare
}

struct WishlistDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userViewModel: UserViewModel

    let wishlist: Wishlist
    var properties: [Property] {
        var picked: [Property] = []
        for idx in pickedPropertiesIdx {
            picked.append(wishlist.properties[idx])
        }
        return picked
    }

    @State var state: ScreenState = .view
    @State var pickedPropertiesIdx: [Int] = []
    @State var showingLowerButton = false
    @State var tickable: Bool = false
    @State var deleteButtonDisabled: Bool = false
    @State var compareButtonDisabled: Bool = false
    @State var backButtonDisabled: Bool = false
    @State var isActive = false
    var deleteButtonColour: Color {
        switch state {
        case .view:
            return .blue
        case .delete:
            return .red
        case .compare:
            return .gray
        }
    }
    var compareButtonColour: Color {
        switch state {
        case .view:
            return .blue
        case .delete:
            return .gray
        case .compare:
            return .green
        }
    }

    var body: some View {
        NavigationStack() {
            List {
                ForEach(wishlist.properties.indices, id: \.self) { idx in
                    if !tickable{
                        NavigationLink{
                            PropertyDetailView(property: wishlist.properties[idx])
                        }label:{
                            WishlistItemCard(
                                pickedPropertiesIdx: $pickedPropertiesIdx,
                                property: wishlist.properties[idx], picking: tickable, idx: idx)
                        }
                    }else{
                        Button {
                            if state == .view {
                                isActive = true
                            } else {
                                pick(idx)
                            }
                        } label: {
                            WishlistItemCard(
                                pickedPropertiesIdx: $pickedPropertiesIdx,
                                property: wishlist.properties[idx], picking: tickable, idx: idx)
                        }
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
                    }.disabled(backButtonDisabled)
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Wishlist - \(wishlist.name)").bold()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    //delete button
                    Button {
                        if state != .delete{
                            transition(to: .delete)
                        }else{
                            transition(to: .view)
                        }
                    } label: {
                        Image(systemName: "xmark.bin")
                    }.foregroundStyle(deleteButtonColour).disabled(deleteButtonDisabled)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    //compare button
                    Button {
                        if state != .compare{
                            transition(to: .compare)
                        }else{
                            transition(to: .view)
                        }
                    } label: {
                        Image(systemName: "calendar.day.timeline.trailing").foregroundStyle(compareButtonColour).disabled(compareButtonDisabled)
                    }
                }
            }
            Spacer()
            if showingLowerButton{
                LowerButton(state: state, properties: properties)
            }
        }
    }

    func transition(to state: ScreenState) {
        pickedPropertiesIdx = []
        switch state{
        case .view:
            compareButtonDisabled = false
            deleteButtonDisabled = false
            showingLowerButton = false
            tickable = false
            backButtonDisabled = false
        case .delete, .compare:
            compareButtonDisabled = false
            deleteButtonDisabled = false
            showingLowerButton = true
            tickable = true
            backButtonDisabled = true
        }
        
        self.state = state
    }
    
    func pick(_ idx: Int){
        //Disable navigation, we're picking stuff
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
}


struct LowerButton: View{
    let state: ScreenState
    let properties: [Property]
    
    var body: some View{
        switch state {
        case .compare:
            if properties.count == 2{
                NavigationLink{
                    WishlistPropertyComparisonView(properties: properties)
                }label:{
                    Text("Compare 2 items ")
                }
            }
        case .delete:
            if properties.count > 0{
                Button{
                    
                }label:{
                    Text("Remove \(properties.count) item\(properties.count > 1 ? "s": "") ")
                }
            }
        default:
            EmptyView()
        }
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
