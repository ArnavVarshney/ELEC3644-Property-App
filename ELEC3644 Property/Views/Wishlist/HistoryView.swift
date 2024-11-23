//
//  HistoryView.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 23/11/2024.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var propertyViewModel: PropertyViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    let coloumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PropertyHistory.dateTime, ascending: true)],
        animation: .default)
    private var records: FetchedResults<PropertyHistory>
    
    private var dateTimes: [Date]{
        records.map{
            $0.dateTime!
        }
    }
    
    init(){
        
    }
    
    private var groups: [HistorySection]{
        var sections: [HistorySection] = []
        var groups: [String : [UUID]] = [:]
        let dateTimes = Set(records.map{
            itemFormatter.string(from: $0.dateTime!)
        })
        
        for time in dateTimes{
            groups[time] = []
        }
        
        for record in records{
            groups[itemFormatter.string(from: record.dateTime!)]!.append(record.propertyId!)
        }
        
        for date in groups.keys{
            let propertyIds = groups[date]!
            let properties = propertyIds.map{id in
                propertyViewModel.properties.first { p in
                    p.id == id
                } ?? Mock.Properties[0]
            }
            
            let section = HistorySection(date: date, properties: properties)
            sections.append(section)
        }
        return sections
    }
    
    var body: some View {
        NavigationStack{
            HStack {
                Text("\("Recently Viewed")").font(.largeTitle)
                Spacer()
            }.padding()
            ScrollView{
                ForEach(groups){
                    group in
                    HStack{
                        Text("\(group.date == itemFormatter.string(from: Date()) ? "Today" : group.date)")
                        Spacer()
                    }

                    ForEach(group.properties.indices.filter{$0 % 2 == 0}, id:\.self){idx in
                        HStack(spacing: 10){
                            NavigationLink{
                                PropertyDetailView(property: group.properties[idx])
                            }label:{
                                WishlistItemCard(property: group.properties[idx], picking: false, picked: false, imageHeight: 170, moreDetail: false, propertyNote: .constant(""), showingSheet: false, showNote: false)
                            }
                            
                            if idx + 1 < group.properties.count{
                                NavigationLink{
                                    PropertyDetailView(property: group.properties[idx])
                                }label:{
                                    WishlistItemCard(property: group.properties[idx + 1], picking: false, picked: false, imageHeight: 170, moreDetail: false, propertyNote: .constant(""), showingSheet: false, showNote: false)
                                }
                            }
                        }
                    }
                }.padding()
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        
                    }label:{
                        Text("Back")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        
                    }label:{
                        Text("Delete")
                    }
                }
            }
            
        }
    }
    
    private var itemFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}


struct HistorySection: Identifiable{
    let id = UUID()
    let date: String
    let properties: [Property]
}

#Preview {
    HistoryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).environmentObject(PropertyViewModel())
}
