//
//  PropertyDetailView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//
import MapKit
import SwiftUI

struct PropertyDetailView: View {
    var property: Property
    @ObservedObject var viewModel: PropertyDetailViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    init(property: Property) {
        self.property = property
        viewModel = .init(property: property)
    }

    var body: some View {
        VStack {
            ScrollView {
                ImageCarouselView(
                    imageUrls: self.property.imageUrls, cornerRadius: 0, property: property
                )
                PropertyDetailListView(viewModel: viewModel)
                PropertyDetailMapView()
                    .environmentObject(viewModel)
                PropertyDetailGraphView(viewModel: viewModel)
                PropertyDetailAgentView(viewModel: viewModel)
            }
            Spacer()
            PropertyDetailBottomBarView(viewModel: viewModel)
                .padding(.bottom, 8)
        }
        .backButton()
        .ignoresSafeArea()
        .onAppear{
            let p = PropertyHistory(context: viewContext)
            let d = Date()
            
            p.userId = UUID(uuidString: userViewModel.currentUserId())
            p.propertyId = p.id
            p.dateTime = d
            
            do{
                try viewContext.save()
            }catch{
                print("Error saving history: \(error)")
            }
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
