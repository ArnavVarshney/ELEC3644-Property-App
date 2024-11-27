//
//  WishlistNoteView.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 19/11/2024.
//

import SwiftUI

struct WishlistNoteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @Binding var note: String

    @FocusState var foc: Bool?

    let TEXT_LIMIT = 250
    @State var record: PropertyNotes?
    let userId: UUID
    let propertyId: UUID

    var body: some View {
        NavigationStack {
            VStack{
                Text(LocalizedStringKey("Name"))
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.neutral100)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 24)
                
                TextField("", text: $note)
                    .focused($foc, equals: true)
                    .textFieldStyle(LoginTextFieldStyle())
                    .multilineTextAlignment(.leading)
                
                Text(
                    "\(note.replacingOccurrences(of: " ", with: "").count)/\(TEXT_LIMIT) characters"
                )
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.neutral70)
                .padding(.top, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .padding(.vertical)
                
                HStack {
                    Button {
                        note = ""
                        if record != nil {
                            viewContext.delete(record!)
                            do {
                                try viewContext.save()
                            } catch {
                                print("couldn't delete note: \(error)")
                            }
                            viewContext.refresh(record!, mergeChanges: true)

                            dismiss()
                        }
                    } label: {
                        Text(record == nil ? "Clear" : "Delete")
                            .underline()
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.neutral100)
                            .underline()
                    }
                    .disabled(note.isEmpty)

                    Spacer()

                    Button {
                        if record == nil {
                            record = PropertyNotes(context: viewContext)
                            record!.id = UUID()
                            record!.userId = userId
                            record!.propertyId = propertyId
                        }
                        record!.note = note

                        do {
                            try viewContext.save()
                        } catch {
                            print("Couldn't save note: \(error)")
                        }

                        dismiss()
                    } label: {
                        Text("Save").bold()
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .cornerRadius(10)
                    }
                    .foregroundStyle(.white)
                    .background(note.isEmpty ? .gray : .neutral100)
                    .clipShape(.buttonBorder)
                    .disabled(note.isEmpty)
                }
            }
            .navigationTitle("Add note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.neutral100)
                    }
                }
            }
            .padding()
        }
        .onChange(of: note) { oldValue, newValue in
            if newValue.replacingOccurrences(of: " ", with: "").count > TEXT_LIMIT {
                note = oldValue
            }
        }
        .onAppear {
            foc = true
        }
    }
}

#Preview {
    WishlistNoteView(
        note: .constant(""), record: PropertyNotes(), userId: UUID(), propertyId: UUID()
    )
    .environment(
        \.managedObjectContext, PersistenceController.preview.container.viewContext
    )
}
