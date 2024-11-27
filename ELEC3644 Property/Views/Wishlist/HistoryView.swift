//
//  HistoryView.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 23/11/2024.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var propertyViewModel: PropertyViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    let coloumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PropertyHistory.dateTime, ascending: false)],
        animation: .default)
    private var records: FetchedResults<PropertyHistory>

    private var dateTimes: [Date] {
        records.map {
            $0.dateTime!
        }
    }

    private var groups: [HistorySection] {
        let records = self.records.filter { p in
            p.userId == UUID(uuidString: userViewModel.currentUserId())
        }

        var sections: [HistorySection] = []
        var groups: [String: [PropertyHistory]] = [:]
        let dateTimes = Array(
            Set(
                records.map {
                    itemFormatter.string(from: $0.dateTime!)
                }))

        for time in dateTimes {
            groups[time] = []
        }

        for record in records {
            groups[itemFormatter.string(from: record.dateTime!)]!.append(record)
        }

        let df = DateFormatter()
        df.dateFormat = "dd MMM yyyy"
        for date in groups.keys {
            let propertyHistories = groups[date]!
            let properties = propertyHistories.map { h in
                propertyViewModel.properties.first { p in
                    p.id == h.propertyId
                } ?? Mock.Properties[0]
            }

            let section = HistorySection(
                date: date, properties: properties, propertyHistories: propertyHistories,
                comparableDate: df.date(from: date)!)
            sections.append(section)
        }

        sections = sections.sorted(by: { s1, s2 in
            s1.comparableDate > s2.comparableDate
        })
        return sections
    }

    @State var state: WishlistState = .view
    @State var tickable: Bool = false
    @State var deleteButtonDisabled: Bool = false
    @State var backButtonDisabled: Bool = false
    @State var deleteButtonColour: Color = .neutral100

    var body: some View {
        NavigationStack {
            if groups.isEmpty {
                VStack {
                    Spacer()
                    Image(systemName: "book.closed")
                        .font(.largeTitle)
                        .padding()

                    Text("Your history is empty")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .padding(4)

                    Text("Recently viewed properties will be recorded here")
                        .font(.footnote)
                        .foregroundColor(.neutral70)
                        .padding(4)
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                        }.disabled(backButtonDisabled)
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            if state != .delete {
                                transition(to: .delete)
                            } else {
                                transition(to: .view)
                            }
                        } label: {
                            Image(systemName: "trash")
                        }.foregroundStyle(deleteButtonColour).disabled(deleteButtonDisabled)
                    }
                }
                .navigationBarBackButtonHidden()
                .navigationTitle("Recently Viewed")
            } else {
                ScrollView {
                    ForEach(groups) {
                        group in
                        HStack {
                            Text(
                                "\(group.date == itemFormatter.string(from: Date()) ? "Today" : group.date)"
                            )
                            Spacer()
                        }

                        ForEach(group.properties.indices.filter { $0 % 2 == 0 }, id: \.self) {
                            idx in
                            HStack(spacing: 10) {
                                if !tickable {
                                    NavigationLink {
                                        PropertyDetailView(property: group.properties[idx])
                                    } label: {
                                        WishlistItemCard(
                                            property: group.properties[idx],
                                            imageHeight: 170,
                                            moreDetail: false,
                                            showingSheet: false,
                                            showNote: false)
                                    }.frame(width: UIScreen.main.bounds.width / 2 - 32)

                                    if idx + 1 < group.properties.count {
                                        NavigationLink {
                                            PropertyDetailView(property: group.properties[idx + 1])
                                        } label: {
                                            WishlistItemCard(
                                                property: group.properties[idx + 1],
                                                imageHeight: 170,
                                                moreDetail: false,
                                                showingSheet: false,
                                                showNote: false)
                                        }.frame(width: UIScreen.main.bounds.width / 2 - 32)
                                    }
                                } else {
                                    Button {
                                        let record = group.propertyHistories[idx]
                                        delete(record: record)
                                    } label: {
                                        WishlistItemCard(
                                            property: group.properties[idx],
                                            deletable: true,
                                            imageHeight: 170,
                                            moreDetail: false,
                                            showNote: false)
                                    }.frame(width: UIScreen.main.bounds.width / 2 - 32)

                                    if idx + 1 < group.properties.count {
                                        Button {
                                            let record = group.propertyHistories[idx + 1]
                                            delete(record: record)
                                        } label: {
                                            WishlistItemCard(
                                                property: group.properties[idx + 1],
                                                deletable: true,
                                                imageHeight: 170, moreDetail: false,
                                                showNote: false)
                                        }.frame(width: UIScreen.main.bounds.width / 2 - 32)
                                    }
                                }
                                Spacer()
                            }
                        }
                    }.padding()
                }
                .navigationTitle("Recently Viewed")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                        }.disabled(backButtonDisabled)
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            if state != .delete {
                                transition(to: .delete)
                            } else {
                                transition(to: .view)
                            }
                        } label: {
                            Image(systemName: "trash")
                        }.foregroundStyle(deleteButtonColour).disabled(deleteButtonDisabled)
                    }
                }
                .navigationBarBackButtonHidden()
            }
        }
    }

    func transition(to state: WishlistState) {
        switch state {
        case .view:
            deleteButtonDisabled = false
            tickable = false
            backButtonDisabled = false
            deleteButtonColour = .neutral100
        case .delete:
            deleteButtonDisabled = false
            tickable = true
            backButtonDisabled = true
            deleteButtonColour = .red
        default:
            break
        }

        self.state = state
    }

    func delete(record: PropertyHistory) {
        withAnimation {
            viewContext.delete(record)
        }

        do {
            try viewContext.save()
        } catch {
            print("Couldn't delete from db: \(error)")
        }
    }

    private var itemFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}

struct HistorySection: Identifiable {
    let id = UUID()
    let date: String
    let properties: [Property]
    let propertyHistories: [PropertyHistory]
    let comparableDate: Date
}

#Preview {
    HistoryView().environment(
        \.managedObjectContext, PersistenceController.preview.container.viewContext
    ).environmentObject(PropertyViewModel()).environmentObject(UserViewModel())
}
