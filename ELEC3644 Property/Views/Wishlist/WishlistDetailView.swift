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
    var wishlistsDEBUG: [Wishlist]? = nil

    @State var showingSheet = false

    var wishlist: Wishlist {
        let temp: [Wishlist]
        let wishlists = wishlistsDEBUG == nil ? userViewModel.user.wishlists : wishlistsDEBUG!

        temp = wishlists.filter { wishlist in
            wishlist.id == wishlistId
        }

        if temp.count == 0 {
            return Wishlist(id: wishlistId, name: "Deleted", properties: [])
        }
        return temp.first!
    }

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
    @State var deleteButtonColour: Color = .black
    @State var compareButtonColour: Color = .black

    var body: some View {
        NavigationStack {
            //Title
            HStack {
                Text("\(wishlist.name)").font(.largeTitle)
                Spacer()
            }.padding()

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
                List {
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

                            //Note button
                            Button {
                                showingSheet = true
                            } label: {
                                HStack {
                                    if getNote(for: idx).replacingOccurrences(of: " ", with: " ")
                                        .count
                                        > 0
                                    {
                                        Text("\(getNote(for: idx))")
                                            .font(.footnote)
                                            .foregroundColor(.neutral60)
                                            .padding(10)
                                    }

                                    Text(
                                        getNote(for: idx).replacingOccurrences(of: " ", with: " ")
                                            .count > 0 ? "Edit" : "Add note"
                                    )
                                    .font(.footnote)
                                    .foregroundColor(.neutral60)
                                    .padding(10)
                                    .underline(true)

                                    Spacer()
                                }
                                .background(
                                    Color(UIColor.lightGray)
                                        .opacity(0.3)
                                )
                                .cornerRadius(6)
                            }.sheet(isPresented: $showingSheet) {
                                WishlistNoteView(note: .constant(""))
                                    .presentationDetents([.height(500)])
                            }.listRowSeparator(.hidden)
                        } else {
                            Button {
                                pick(idx)
                            } label: {
                                WishlistItemCard(
                                    property: wishlist.properties[idx], picking: tickable,
                                    picked: pickedPropertiesIdx.contains(idx),
                                    propertyNote: .constant("")
                                )
                            }
                        }

                        Divider().listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
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
                .scrollContentBackground(.visible)
            }
            Spacer()
            if showingLowerButton {
                LowerButton(
                    wishlist: wishlist,
                    pickedPropertiesIdx: $pickedPropertiesIdx,
                    state: state,
                    parent: self
                )
                .padding(10)
                .background(Rectangle().fill(.black))
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: 5))
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

    func getNote(for id: Int) -> String {
        return ""
    }
}

struct LowerButton: View {
    @EnvironmentObject private var userViewModel: UserViewModel
    @State var wishlist: Wishlist
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

    var body: some View {
        switch state {
        case .compare:
            if pickedPropertiesIdx.count == 2 {
                NavigationLink {
                    WishlistPropertyComparisonView(properties: properties)
                } label: {
                    Text("Compare 2 items")
                }
            }
        case .delete:
            if properties.count > 0 {
                Button {
                    wishlist.properties = wishlist.properties.filter { property in
                        if properties.contains(property) {
                            pickedPropertiesIdx.removeFirst()
                            Task {
                                await userViewModel.postWishlist(
                                    property: property,
                                    folderName: wishlist.name, delete: true)
                            }
                            return false
                        }
                        return true
                    }

                    let temp = userViewModel.user.wishlists.enumerated().filter {
                        $1.id == wishlist.id
                    }
                    let wishlistIdx = temp.count > 0 ? temp.first?.0 : nil

                    if let idx = wishlistIdx {
                        if wishlist.properties.count == 0 {
                            userViewModel.user.wishlists.remove(at: idx)
                        } else {
                            userViewModel.user.wishlists[idx].properties = wishlist.properties
                        }
                    }

                    parent.transition(to: .view)
                } label: {
                    Text("Remove \(properties.count) item\(properties.count > 1 ? "s": "") ")
                }
            }
        default:
            EmptyView()
        }
    }
}

#Preview {
    WishlistDetailView(
        wishlistId: Mock.Users[0].wishlists[0].id, wishlistsDEBUG: Mock.Users[0].wishlists
    ).environmentObject(UserViewModel())
}
