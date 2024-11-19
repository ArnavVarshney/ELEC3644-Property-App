//
//  WishlistNoteView.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 19/11/2024.
//

import SwiftUI

struct WishlistNoteView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var note: String

    @FocusState var foc: Bool?

    let TEXT_LIMIT = 250

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                TextField("", text: $note, axis: .vertical).font(.system(size: 15)).focused(
                    $foc, equals: true)
                Text(
                    "\(note.replacingOccurrences(of: " ", with: "").count)/\(TEXT_LIMIT) characters"
                ).font(.footnote).foregroundStyle(.neutral60).padding(
                    .init(top: 10, leading: 0, bottom: 5, trailing: 0))
            }
            .padding(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10).stroke(.black)
            }
            .padding(10)
            Divider()
            HStack {
                Button {
                    note = ""
                } label: {
                    Text("Clear").underline()
                }
                .foregroundStyle(note.isEmpty ? .gray : .black)
                .disabled(note.isEmpty)

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Text("Save").bold().padding(
                        .init(top: 15, leading: 20, bottom: 15, trailing: 20))
                }
                .foregroundStyle(.white)
                .background(note.isEmpty ? .gray : .black)
                .clipShape(.buttonBorder)
                .disabled(note.isEmpty)
            }
            .padding()
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }.foregroundStyle(.black)
                }

                ToolbarItem(placement: .principal) {
                    Text("Add note")
                }
            }
            Spacer()
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
    WishlistNoteView(note: .constant(""))
}
