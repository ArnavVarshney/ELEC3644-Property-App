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
    var favoritable: Bool = false

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
            PropertyCardView(property: property,favoritable: favoritable, deletable: deletable, picking: picking, picked: picked
            )
            
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
                }
                .sheet(isPresented: $showingSheet, onDismiss: getNotes) {
                    WishlistNoteView(
                        note: $propertyNote, record: noteRecord,
                        userId: UUID(uuidString: userViewModel.currentUserId())!,
                        propertyId: property.id
                    )
                    .presentationDetents([.height(500)])
                }
                .padding(.horizontal, 24)
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
        property: Mock.Properties.first!, picking: true, picked: false, deletable: false,
        imageHeight: 300,
        moreDetail: true,
        favoritable: false,
        showNote: true
    )
    .environmentObject(UserViewModel())
    .environment(
        \.managedObjectContext, PersistenceController.preview.container.viewContext
    )
}
