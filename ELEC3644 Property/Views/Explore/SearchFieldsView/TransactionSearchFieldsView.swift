//
//  TransactionSearchFieldsView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 21/10/2024.
//
import SwiftUI

struct TransactionSearchFieldsView: View {
    @EnvironmentObject private var viewModel: PropertyViewModel
    @State private var contractType = "Buy"

    func onSubmit() {
        contractType = viewModel.searchFields.contractType
        viewModel.properties = viewModel.getByContractType(
            contractType: viewModel.searchFields.contractType)
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Property Type")
                            .fontWeight(.semibold)
                            .padding(.bottom, 4)
                        Picker("Contract Type", selection: $viewModel.searchFields.contractType) {
                            ForEach(["Buy", "Rent", "Lease"], id: \.self) {
                                Text(LocalizedStringKey($0.capitalized)).tag($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                Spacer()
                Divider()
                BottomBar(onSubmit: onSubmit)
            }
        }
    }
}

#Preview {
    TransactionSearchFieldsView()
}
