//
//  DetailRows.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//

import SwiftUI

struct PropertyDetailRowsView: View {
    let details: [(String, String)]

    var body: some View {
        ForEach(details, id: \.0) { detail in
            HStack {
                Text("\(detail.0): ")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.neutral70)
                Spacer()
                Text(detail.1)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.neutral100)
            }
        }
    }
}
