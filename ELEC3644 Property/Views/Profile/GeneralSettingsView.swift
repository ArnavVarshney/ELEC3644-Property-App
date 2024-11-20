//
//  GeneralSettingsView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 16/11/24.
//
import SwiftUI

struct GeneralSettingsView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var lang: String = Locale.preferredLanguages.first ?? "en"
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(LocalizedStringKey("Language"))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Picker("Language", selection: $lang) {
                    Text("繁體中文").tag("zh-HK")
                    Text("English").tag("en")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, 3)
                .onChange(of: lang) {
                    UserDefaults.standard.set([lang], forKey: "AppleLanguages")
                    showAlert.toggle()
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .navigationTitle("General")
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(LocalizedStringKey("Warning")),
                    message: Text(
                        LocalizedStringKey(
                            "You must restart the app for the changes to take effect")),
                    dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    struct GeneralSettingsView_Preview: View { var body: some View { GeneralSettingsView() } }
    return GeneralSettingsView_Preview()
}
