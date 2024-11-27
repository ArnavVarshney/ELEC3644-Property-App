//
//  PropertyDetailView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//
import MapKit
import SwiftUI

struct PropertyDetailView: View {
    let property: Property
    @StateObject private var viewModel: PropertyDetailViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @Environment(\.managedObjectContext) private var viewContext

    init(property: Property) {
        self.property = property
        _viewModel = StateObject(wrappedValue: PropertyDetailViewModel(property: property))
    }

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PropertyHistory.dateTime, ascending: true)],
        animation: .default)
    private var records: FetchedResults<PropertyHistory>

    var body: some View {
        VStack {
            ScrollView {
                ImageCarouselView(
                    imageUrls: self.property.imageUrls, cornerRadius: 0, property: property
                )
                PropertyDetailListView(viewModel: viewModel)
                if (viewModel.location.latitude != 0 && viewModel.location.longitude != 0) {
                    PropertyDetailMapView()
                        .environmentObject(viewModel)
                    PropertyDetailGraphView(viewModel: viewModel)
                    PropertyDetailAgentView(viewModel: viewModel)
                }
            }
            Spacer()
            PropertyDetailBottomBarView(viewModel: viewModel)
                .padding(.bottom, 8)
        }
        .backButton()
        .ignoresSafeArea()
        .onAppear {
            initializePropertyHistory()
        }
    }

    private func initializePropertyHistory() {
        let p: PropertyHistory
        if let record = records.first(where: { p in
            p.propertyId == property.id
                && p.userId == UUID(uuidString: userViewModel.currentUserId())
        }) {
            p = record
        } else {
            p = PropertyHistory(context: viewContext)
            p.id = UUID()
            p.userId = UUID(uuidString: userViewModel.currentUserId())
            p.propertyId = property.id
        }

        p.dateTime = Date()

        do {
            try viewContext.save()
        } catch {
            print("Error saving history: \(error)")
        }
    }
}

#Preview {
    struct PropertyDetail_Preview: View {
        @EnvironmentObject var propertyViewModel: PropertyViewModel
        var body: some View {
            PropertyDetailView(property: Mock.Properties[0])
                .environmentObject(UserViewModel())
        }
    }
    return PropertyDetail_Preview()
        .environmentObject(PropertyViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(InboxViewModel())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
