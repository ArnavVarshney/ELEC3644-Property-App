//
//  backButton.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 11/10/2024.
//

import AVKit
import SwiftUI

struct BackButtonModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    HStack {
                        Button(action: {
                            self.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .frame(width: 18, height: 18)
                                .foregroundColor(.black)
                                .padding(12)
                                .background(
                                    Circle()
                                        .fill(Color.white)
                                )
                                .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 4)
                        }
                    }
                }
            }
    }
}

struct AddShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 4)
    }
}

extension View {
    func backButton() -> some View {
        self.modifier(BackButtonModifier())
    }

    func addShadow() -> some View {
        self.modifier(AddShadow())
    }
}

extension AVPlayerViewController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.showsPlaybackControls = false
        self.videoGravity = .resizeAspect
    }
}


struct favoriteIcon: View{
    @EnvironmentObject var userViewModel: UserViewModel
    @State var showingSheet = false
    
    let property: Property
    var propertyIdx: (Int, Int)? {
        for (i, wishlist) in userViewModel.user.wishlists.enumerated() {
            for (j, property) in wishlist.properties.enumerated() {
                if property.id == self.property.id {
                    return (i, j)
                }
            }
        }
        return nil
    }
    
    
    var body: some View{
        Button {
            if propertyIdx != nil {
                withAnimation {
                    //We're going to unfavorite
                    userViewModel.user.wishlists[propertyIdx!.0].properties.remove(
                        at: propertyIdx!.1)

                    //Check for empty folder
                    userViewModel.user.wishlists = userViewModel.user.wishlists.filter({
                        !$0.properties.isEmpty
                    })
                }
            } else {
                showingSheet = true
            }
        } label: {
            if propertyIdx != nil {
                return Image(systemName: "heart.fill")
                    .foregroundColor( /*@START_MENU_TOKEN@*/
                        .red /*@END_MENU_TOKEN@*/
                    ).bold()
            }
            return Image(systemName: "heart").foregroundColor(.black).bold()
        }
        .padding(2)
        .background(propertyIdx != nil ? Color.clear : Color.white)
        .clipShape(.circle)
        .sheet(isPresented: $showingSheet) {
            FavoriteSubmitForm(property: property).presentationDetents([.height(250.0)])
        }
    }
}


#Preview {
    NavigationStack {
        VStack {
            Text("Hello")
            Spacer()
        }
        .backButton()
        .navigationTitle("Test")
    }
}
