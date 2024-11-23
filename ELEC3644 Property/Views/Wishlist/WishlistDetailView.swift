//
//  WishlistDetailView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 26/10/24.
//
import SwiftUI

enum ScreenState {
    case view, delete, compare
}

struct WishlistDetailView: View {
    @EnvironmentObject private var userViewModel: UserViewModel
    @Environment(\.dismiss) private var dismiss

    let wishlistId: UUID
    var coloumns = [
        GridItem(.flexible())
    ]

    @State var showingSheet = false
    var wishlist: Wishlist {
        if debug {
            return userViewModel.user.wishlists.first ?? Wishlist(name: "Deleted", properties: [])
        }

        return userViewModel.user.wishlists.first { w in
            w.id == wishlistId
        } ?? Wishlist(name: "Deleted", properties: [])
    }

    var pickedProperties: [Property] {
        var picked: [Property] = []
        for idx in pickedPropertiesIdx {
            picked.append(wishlist.properties[idx])
        }
        return picked
    }

    var debug = false

    //State management
    @State var state: ScreenState = .view
    @State var pickedPropertiesIdx: [Int] = []
    @State var showingLowerButton = false
    @State var tickable: Bool = false
    @State var deleteButtonDisabled: Bool = false
    @State var compareButtonDisabled: Bool = false
    @State var backButtonDisabled: Bool = false
    @State var isActive = false
    @State var deleteButtonColour: Color = .black
    @State var compareButtonColour: Color = .black

    let callback: (_: [Property]) -> Void

    var body: some View {
        NavigationStack {
            //Title
            HStack {
                Text("\(wishlist.name)").font(.largeTitle)
                Spacer()
            }.padding()
            ScrollView {
                if wishlist.properties.isEmpty {
                    VStack {
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
                } else {
                    LazyVGrid(columns: coloumns) {
                        ForEach(wishlist.properties.indices, id: \.self) { idx in
                            if !tickable {
                                ScrollView {  // I've no idea why this worked https://forums.developer.apple.com/forums/thread/702376
                                    NavigationLink {
                                        PropertyDetailView(property: wishlist.properties[idx])
                                    } label: {
                                        WishlistItemCard(
                                            property: wishlist.properties[idx], picking: tickable,
                                            picked: pickedPropertiesIdx.contains(idx),
                                            propertyNote: .constant("")
                                        )
                                    }
                                }
                            } else {
                                Button {
                                    pick(idx)
                                } label: {
                                    WishlistItemCard(
                                        property: wishlist.properties[idx], picking: tickable,
                                        picked: pickedPropertiesIdx.contains(idx),
                                        propertyNote: .constant(""),
                                        showNote: false
                                    )
                                }
                            }

                            Divider().listRowSeparator(.hidden)
                        }
                    }.padding()
                }
                Spacer()
                if showingLowerButton {
                    LowerButton(
                        wishlist: wishlist,
                        pickedPropertiesIdx: pickedPropertiesIdx, state: state
                    ) {
                        removedIds in
                        let removedProperties = wishlist.properties.filter { property in
                            return removedIds.contains(property.id)
                        }
                        callback(removedProperties)
                        transition(to: .view)
                    }
                    .padding(10)
                    .background(Rectangle().fill(.black))
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 5))
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

                ToolbarItem(placement: .topBarTrailing) {
                    //delete button
                    Button {
                        if state != .delete {
                            transition(to: .delete)
                        } else {
                            transition(to: .view)
                        }
                    } label: {
                        Image(systemName: "xmark.bin")
                    }.foregroundStyle(deleteButtonColour).disabled(deleteButtonDisabled)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    //compare button
                    Button {
                        if state != .compare {
                            transition(to: .compare)
                        } else {
                            transition(to: .view)
                        }
                    } label: {
                        Image(systemName: "calendar.day.timeline.trailing").foregroundStyle(
                            compareButtonColour
                        ).disabled(compareButtonDisabled)
                    }
                }
            }

        }
    }

    func transition(to state: ScreenState) {
        pickedPropertiesIdx = []
        switch state {
        case .view:
            compareButtonDisabled = false
            deleteButtonDisabled = false
            showingLowerButton = false
            tickable = false
            backButtonDisabled = false
            deleteButtonColour = .black
            compareButtonColour = .black
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

    func pick(_ idx: Int) {
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

struct LowerButton: View {
    @State var wishlist: Wishlist
    @State var pickedPropertiesIdx: [Int]

    let state: ScreenState
    let callback: (_: [UUID]) -> Void

    var pickedProperties: [Property] {
        var picked: [Property] = []
        for idx in pickedPropertiesIdx {
            picked.append(wishlist.properties[idx])
        }
        return picked
    }

    var body: some View {
        switch state {
        case .compare:
            if pickedPropertiesIdx.count == 2 {
                NavigationLink {
                    WishlistPropertyComparisonView(properties: pickedProperties)
                } label: {
                    Text("Compare 2 items")
                }
            }
        case .delete:
            if pickedProperties.count > 0 {
                Button {
                    var removedIds: [UUID] = []
                    let _ = wishlist.properties.filter { property in
                        if pickedProperties.contains(property) {
                            removedIds.append(property.id)
                            return false
                        }
                        return true
                    }
                    callback(removedIds)

                } label: {
                    Text(
                        "Remove \(pickedProperties.count) item\(pickedProperties.count > 1 ? "s": "") "
                    )
                }
            }
        default:
            EmptyView()
        }
    }
}

struct WishlistDetailViewPreview: View {
    @State var wishlist = Mock.Users[0].wishlists[0]
    var body: some View {
        WishlistDetailView(
            wishlistId: UUID(uuidString: "FB7F5ED8-8673-4539-9F45-3BA51D148B10")!, debug: true,
            callback: { _ in }
        ).environmentObject(UserViewModel(user: Mock.Users[0]))
    }
}

#Preview {
    WishlistDetailViewPreview()
}
