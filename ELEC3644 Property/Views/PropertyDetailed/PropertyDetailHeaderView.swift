//
//  PropertyDetailHeaderView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//
import SwiftUI

struct PropertyDetailHeaderView: View {
    let property: Property
    var body: some View {
        VStack(alignment: .leading) {
            Text(property.name)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(.neutral100)
                .padding(.bottom, 1)
            HStack(spacing: 0) {
                Text(property.address)
                Text(", ")
                Text(LocalizedStringKey(property.subDistrict))
            }
            .font(.system(size: 18, weight: .regular))
            .foregroundColor(.neutral100)
            HStack(spacing: 0) {
                Text(LocalizedStringKey(property.district))
                Text(", ")
                Text(LocalizedStringKey(property.area))
            }
            .font(.system(size: 18, weight: .regular))
            .foregroundColor(.neutral70)
        }
    }
}
