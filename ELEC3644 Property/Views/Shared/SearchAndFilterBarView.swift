//
//  SearchAndFilterBarView.swift
//  ELEC3644 Property
//
//  Created by Mak Yilam on 21/11/2024.
//

import SwiftUI

struct SearchAndFilterBarView: View {
    @Binding var isActive: Bool
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding(10)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("District | MTR | School Net | University | Estate")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Button {
                isActive.toggle()
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .padding(10)
                    .foregroundColor(.neutral100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 1000).inset(by: 1)
                            .strokeBorder(.neutral40, lineWidth: 1)
                    )
            }
        }
        .padding(12)
        .overlay(
            RoundedRectangle(cornerRadius: 48)
                .stroke(.gray, lineWidth: 1)
        )
        .padding(.horizontal, 24)
        .addShadow()
    }
}

//
//#Preview {
//    SearchAndFilterBarView(location: .constant("Kowloon"))
//}

#Preview {
    struct SearchAndFilterBarView_Preview: View {
        
        var body: some View {
            SearchAndFilterBarView(isActive: .constant(true))
        }
    }
    return SearchAndFilterBarView_Preview()
}

