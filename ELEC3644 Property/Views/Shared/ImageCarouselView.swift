//
//  ImageCarouselView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 21/10/24.
//

import SwiftUI

struct ImageCarouselView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    let property: Property
  let images: [String]
  let imageUrls: [String]
  let height: Double
  var cornerRadius: Double
    var propertyIdx: (Int, Int)? {
        for (i,wishlist) in userViewModel.user.wishlists.enumerated(){
            for (j, property) in wishlist.properties.enumerated(){
                if property.id == self.property.id{
                    return (i, j)
                }
            }
        }
        return nil
    }

  init(
    images: [String] = [], imageUrls: [String] = [], cornerRadius: Double = 8, height: Double = 320, property: Property
  ) {
      self.images = images
      self.imageUrls = imageUrls
      self.cornerRadius = cornerRadius
      self.height = height
      self.property = property
  }

  var body: some View {
      ZStack{
          VStack{
              HStack{
                  Spacer()
                  Button {
                      //Not favorited
                      if propertyIdx == nil{
                          let idxs = userViewModel.user.wishlists.enumerated().map({$1.name=="default" ? $0 : -1}).filter({$0 != -1})
                          if idxs.isEmpty{
                              userViewModel.user.wishlists.append(Wishlist(name: "default", properties: [property]))
                          }else{
                              let idx = idxs[0]
                              userViewModel.user.wishlists[idx].properties.append(property)
                          }
                      }else{
                          //We're going to unfavorite
                          userViewModel.user.wishlists[propertyIdx!.0].properties.remove(at: propertyIdx!.1)
                          
                          //Check for empty folder
                          userViewModel.user.wishlists = userViewModel.user.wishlists.filter({!$0.properties.isEmpty})
                      }
                  } label: {
                      if let _ = propertyIdx{
                          return Image(systemName: "heart.fill").foregroundColor(/*@START_MENU_TOKEN@*/.red/*@END_MENU_TOKEN@*/).bold()
                      }
                      return Image(systemName: "heart").foregroundColor(.black).bold()
                  }

              }
              Spacer()
          }.padding(20.0).padding(.trailing, 5.0).zIndex(1)
    
          
          TabView {
            if imageUrls.isEmpty {
              ForEach(images, id: \.self) { image in
                Image(image)
                  .resizable()
                  .scaledToFill()
              }
            } else {
              ForEach(imageUrls, id: \.self) { imageUrl in
                AsyncImage(url: URL(string: imageUrl)) { image in
                  image
                    .resizable()
                    .scaledToFill()
                } placeholder: {
                  ProgressView()
                }
              }
            }
          }
      }.frame(height: height)
          .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
          .tabViewStyle(.page)
  }
}

#Preview {
    ImageCarouselView(imageUrls: Mock.Properties[0].imageUrls, property: Mock.Properties[0]).environmentObject(UserViewModel())
}
