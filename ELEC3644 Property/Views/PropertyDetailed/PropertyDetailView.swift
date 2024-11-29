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
    @Environment(\.dismiss) private var dismiss
    @State var showAlert = false
    @State var showConfirmation = false
    @State var alertMessage = ""
    @State var deleted = false

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
                if viewModel.location.latitude != 0 && viewModel.location.longitude != 0 {
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
        .onChange(of: deleted) {
            dismiss()
        }
        .alert(isPresented: $showAlert) {
            if showConfirmation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showConfirmation = false
                    showAlert = false
                }
                return Alert(
                    title: Text("Are you sure?"),
                    message: Text("This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        Task {
                            do {
                                let _: Property = try await NetworkManager.shared.patch(
                                    url:
                                        "/properties/\(viewModel.property.id.uuidString.lowercased())",
                                    body: ["isActive": false])
                                deleted = true
                            } catch {
                                print(error)
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )
            } else {
                return Alert(
                    title: Text("Error"), message: Text(alertMessage),
                    dismissButton: .default(Text("OK")))
            }
        }
        .backButton()
        .toolbar {
            if (userViewModel.userRole == .host || userViewModel.userRole == .agent)
                && viewModel.property.isActive
            {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    HStack {
                        Button(action: {
                            showConfirmation = true
                            showAlert = true
                        }) {
                            Image(systemName: "trash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .foregroundColor(.neutral100)
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(Color.white)
                                )
                                .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 4)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
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
