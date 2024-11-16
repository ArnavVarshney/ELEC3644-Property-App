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
    
    @State var wishlist: Wishlist
    var properties: [Property] {
        var picked: [Property] = []
        for idx in pickedPropertiesIdx {
            picked.append(wishlist.properties[idx])
        }
        return picked
    }
    
    //State management
    @State var state: ScreenState = .view
    @State var pickedPropertiesIdx: [Int] = []
    @State var showingLowerButton = false
    @State var tickable: Bool = false
    @State var deleteButtonDisabled: Bool = false
    @State var compareButtonDisabled: Bool = false
    @State var backButtonDisabled: Bool = false
    @State var isActive = false
    @State var deleteButtonColour: Color = .blue
    @State var compareButtonColour: Color = .blue

    var body: some View {
        NavigationStack() {
            if wishlist.properties.isEmpty {
                VStack{
                    Spacer()
                    Image(systemName: "heart")
                        .font(.largeTitle)
                        .padding()

                    Text("This wishlist is empty")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .padding(4)

                    Text("You removed everything here. Go back to browsing!")
                        .font(.footnote)
                        .foregroundColor(.neutral60)
                        .padding(4)
                    Spacer()
                }
            }else{
                List {
                    ForEach(wishlist.properties.indices, id: \.self) { idx in
                        if !tickable{
                            NavigationLink{
                                PropertyDetailView(property: wishlist.properties[idx])
                            }label:{
                                WishlistItemCard(
                                    property: wishlist.properties[idx], picking: tickable, picked: pickedPropertiesIdx.contains(idx))
                            }
                        }else{
                            Button {
                                pick(idx)
                            } label: {
                                WishlistItemCard(
                                    property: wishlist.properties[idx], picking: tickable, picked: pickedPropertiesIdx.contains(idx))
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
            }
            
            Spacer()
            if showingLowerButton{
                LowerButton(
                    wishlist: $wishlist,
                    pickedPropertiesIdx: $pickedPropertiesIdx,
                    state: state,
                    parent: self
                )
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
            deleteButtonColour = .blue
            compareButtonColour = .blue
        case .delete:
            compareButtonDisabled = false
            deleteButtonDisabled = false
            showingLowerButton = true
            tickable = true
            backButtonDisabled = true
            deleteButtonColour = .red
            compareButtonColour = .gray
        case .compare:
            compareButtonDisabled = false
            deleteButtonDisabled = false
            showingLowerButton = true
            tickable = true
            backButtonDisabled = true
            deleteButtonColour = .gray
            compareButtonColour = .green

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
    @EnvironmentObject private var userViewModel: UserViewModel
    @Binding var wishlist: Wishlist
    @Binding var pickedPropertiesIdx: [Int]
    
    let state: ScreenState
    let parent: WishlistDetailView
    
    var properties: [Property] {
        var picked: [Property] = []
        for idx in pickedPropertiesIdx {
            picked.append(wishlist.properties[idx])
        }
        return picked
    }
    
    var body: some View{
        switch state {
        case .compare:
            if pickedPropertiesIdx.count == 2{
                NavigationLink{
                    WishlistPropertyComparisonView(properties: properties)
                }label:{
                    Text("Compare 2 items")
                }
            }
        case .delete:
            if properties.count > 0{
                Button{
                    wishlist.properties = wishlist.properties.filter{property in
                        if properties.contains(property){
                            pickedPropertiesIdx.removeFirst()
                            Task{
                                await userViewModel.postWishlist(
                                    property: property,
                                    folderName: wishlist.name, delete: true)
                            }
                            return false
                        }
                        return true
                    }
                    
                    let temp = userViewModel.user.wishlists.enumerated().filter{
                        $1.id == wishlist.id
                    }
                    let wishlistIdx = temp.count > 0 ? temp.first?.0 : nil
                    
                    if let idx = wishlistIdx{
                        if wishlist.properties.count == 0{
                            userViewModel.user.wishlists.remove(at: idx)
                        }else{
                            userViewModel.user.wishlists[idx].properties = wishlist.properties
                        }
                    }
                    
                    parent.transition(to: .view)
                }label:{
                    Text("Remove \(properties.count) item\(properties.count > 1 ? "s": "") ")
                }
            }
        default:
            EmptyView()
        }    }
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
