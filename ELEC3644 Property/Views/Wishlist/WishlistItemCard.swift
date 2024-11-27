//
//  WishlistItemCard.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 17/11/2024.
//

import SwiftUI

struct WishlistItemCard: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var userViewModel: UserViewModel

    let property: Property
    var picking: Bool = false
    var picked: Bool = false
    var deletable: Bool = false
    var imageHeight: Double = 300
    var moreDetail: Bool = true

    @State var propertyNote: String = ""
    @State var showingSheet = false
    @State var noteRecord: PropertyNotes?

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PropertyNotes.id, ascending: true)],
        animation: .default)
    private var records: FetchedResults<PropertyNotes>

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
                                .foregroundColor(picked ? .blue : .neutral100)
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

                if deletable {
                    VStack {
                        HStack {
                            Image(systemName: "xmark")
                                .frame(width: 3, height: 3)
                                .foregroundColor(.neutral100)
                                .padding(12)
                                .background(
                                    Circle()
                                        .fill(Color.white)
                                )
                                .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 4)
                            Spacer()
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
            }.frame(height: imageHeight).cornerRadius(10)

            HStack {
                VStack(alignment: moreDetail ? .leading : .center) {
                    Text(property.name).font(.headline).foregroundStyle(.neutral100)
                    Text("\(property.area)")
                    if moreDetail {
                        HStack {
                            Text("S.A \(property.saleableArea) ft²").foregroundStyle(.neutral100)
                            Text("@ \(property.saleableAreaPricePerSquareFoot)")
                        }
                        HStack {
                            Text("GFA \(property.grossFloorArea) ft²").foregroundStyle(.neutral100)
                            Text("@ \(property.grossFloorAreaPricePerSquareFoot)")
                        }
                    }
                }
                .foregroundColor(.neutral70)
                .font(.system(size: 10))
                .lineLimit(1)

                Spacer()

                if moreDetail {
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
                                .foregroundColor(.neutral70)
                                .padding(10)
                        }

                        Text(
                            propertyNote.replacingOccurrences(of: " ", with: " ")
                                .count > 0 ? "Edit" : "Add note"
                        )
                        .font(.footnote)
                        .foregroundColor(.neutral70)
                        .padding(10)
                        .underline(true)

                        Spacer()
                    }
                    .lineLimit(1)
                    .background(
                        Color(UIColor.lightGray)
                            .opacity(0.3)
                    )
                    .cornerRadius(6)
                }.sheet(isPresented: $showingSheet, onDismiss: getNotes) {
                    WishlistNoteView(
                        note: $propertyNote, record: noteRecord,
                        userId: UUID(uuidString: userViewModel.currentUserId())!,
                        propertyId: property.id
                    )
                    .presentationDetents([.height(500)])
                }
            }
        }
        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
        .foregroundStyle(.neutral100)
        .onAppear {
            getNotes()
        }
    }

    func getNotes() {
        noteRecord = records.first { p in
            p.propertyId == property.id
                && p.userId == UUID(uuidString: userViewModel.currentUserId())
        }
        if let nr = noteRecord {
            propertyNote = nr.note!
        }
    }
}

#Preview {
    WishlistItemCard(
        property: Mock.Properties.first!, picking: false, picked: true, deletable: true,
        imageHeight: 300,
        moreDetail: false, showNote: true
    )
    .environmentObject(UserViewModel())
    .environment(
        \.managedObjectContext, PersistenceController.preview.container.viewContext
    )
}
