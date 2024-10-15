//
//  InboxItemView.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 15/10/2024.
//

import SwiftUI

struct InboxItemView: View {
    let name: String
    let date: String
    var body: some View {
        VStack {
            HStack {
                Text(name)
                Spacer()
                Text(date)
            }
        }
        .padding(/*@START_MENU_TOKEN@*/ .all/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    InboxItemView(name: "Default", date: "Default")
}
