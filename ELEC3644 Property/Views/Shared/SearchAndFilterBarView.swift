//
//  SearchAndFilterBarView.swift
//  ELEC3644 Property
//
//  Created by Mak Yilam on 21/11/2024.
//

import SwiftUI

struct SearchAndFilterBarView: View {
    @Binding var searchText: String
    @Binding var isActive: Bool
//    var onSearch: () -> Void  // Closure to call when searching
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .padding(10)
                    .fontWeight(.semibold)

                TextField("District | MTR | School Net | University | Estate", text: $searchText)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
//                    .onSubmit(of: .search) {
//                        print("Search submitted with text: \(searchText)")  // Debugging line
//                        onSearch()  // Call the parent's function
//                    }
            }
            .padding(8)
            .background(.neutral10)
            .cornerRadius(48)
            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 3)
            .background(.neutral10)
            Spacer()
            Button {
                isActive.toggle()
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                    .padding(10)
                    .foregroundColor(.black)
                    .background(.neutral10)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(Color.neutral50, lineWidth: 1)
                    )
            }
        }
        .padding(.trailing, 40)
    }
}

//
//#Preview {
//    SearchAndFilterBarView(location: .constant("Kowloon"))
//}

//#Preview {
//    struct SearchAndFilterBarView_Preview: View {
//        @State private var searchText = ""
//        var onSearch: () -> Void // Closure to call when searching
//        var body: some View {
//            SearchAndFilterBarView(searchText: $searchText, isActive: .constant(true))
//        }
//    }
//    return SearchAndFilterBarView_Preview()
//}
