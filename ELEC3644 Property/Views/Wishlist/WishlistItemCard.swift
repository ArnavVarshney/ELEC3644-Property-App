//
//  WishlistItemCard.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 17/11/2024.
//

import SwiftUI

struct WishlistItemCard: View {
    let property: Property
    let picking: Bool
    var picked: Bool
    var imageHeight: Double = 300
    var moreDetail: Bool = true

    @Binding var propertyNote: String
    @State var showingSheet = false

    var showNote = true

    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                if picking {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: picked ? "checkmark.circle.fill" : "checkmark.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(picked ? .blue : .black)
                                .padding(1)
                                .background(
                                    Circle()
                                        .fill(Color.white)
                                )
                                .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 4)
                                .frame(width: 24, height: 24)
                        }
                        Spacer()
                    }.padding(.init(top: 5, leading: 5, bottom: 5, trailing: 5)).zIndex(1)
                }

                AsyncImage(url: URL(string: property.imageUrls[0])) { image in
                    image
                        .resizable()
                } placeholder: {
                    ProgressView()
                }
            }.frame(width: imageHeight, height: imageHeight).cornerRadius(10)

            HStack {
                VStack(alignment: moreDetail ? .leading : .center) {
                    Text(property.name).font(.headline).foregroundStyle(.black)
                    Text("\(property.area)")
                    if moreDetail{
                        Text("MTR info?")

                        HStack {
                            Text("S.A \(property.saleableArea) ft²").foregroundStyle(.black)
                            Text("@ \(property.saleableAreaPricePerSquareFoot)")
                        }
                        HStack {
                            Text("GFA \(property.grossFloorArea) ft²").foregroundStyle(.black)
                            Text("@ \(property.grossFloorAreaPricePerSquareFoot)")
                        }
                    }
                }
                .foregroundColor(.neutral60)
                .font(.system(size: 10))
                .lineLimit(1)

                Spacer()
                
                if moreDetail{
                    Text("\(property.netPrice)")
                }
            }

            //Note button
            if showNote {
                Button {
                    showingSheet = true
                } label: {
                    HStack {
                        if propertyNote.replacingOccurrences(of: " ", with: " ")
                            .count
                            > 0
                        {
                            Text("\(propertyNote)")
                                .font(.footnote)
                                .foregroundColor(.neutral60)
                                .padding(10)
                        }

                        Text(
                            propertyNote.replacingOccurrences(of: " ", with: " ")
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
                }
            }
        }
        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
        .foregroundStyle(.black)
    }
}

#Preview {
    WishlistItemCard(
        property: Mock.Properties.first!, picking: false, picked: true, imageHeight: 150, moreDetail: false, propertyNote: .constant(""), showNote: false
    )
    .environmentObject(UserViewModel())
}
