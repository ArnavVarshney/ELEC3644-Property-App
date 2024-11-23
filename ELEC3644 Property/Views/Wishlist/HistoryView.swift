//
//  HistoryView.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 23/11/2024.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PropertyHistory.dateTime, ascending: true)],
        animation: .default)
    private var records: FetchedResults<PropertyHistory>
    
    var body: some View {
        NavigationStack{
            ForEach(records.indices.filter({$0 % 2 == 0}), id: \.self){
                idx in
                Text("Hello")
            }
        }
    }
}

#Preview {
    HistoryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
