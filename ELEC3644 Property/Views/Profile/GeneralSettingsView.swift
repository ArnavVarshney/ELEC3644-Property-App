//
//  GeneralSettingsView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 16/11/24.
//
import SwiftUI

class LanguageSetting: ObservableObject {
    @Published var locale = Locale(
        identifier: UserDefaults.standard.string(forKey: "AppleLanguages") ?? "en")
}

struct GeneralSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var languageSetting: LanguageSetting
    @State private var lang: String = UserDefaults.standard.string(forKey: "AppleLanguages") ?? "en"
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            if isLoading {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5, anchor: .center)
                        .padding()
                    Text("Loading...")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .navigationBarBackButtonHidden()
                .toolbar(.hidden, for: .tabBar)
            } else {
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
                        isLoading = true
                        languageSetting.locale = Locale(identifier: lang)
                        UserDefaults.standard.set(lang, forKey: "AppleLanguages")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isLoading = false
                        }
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
            }
        }
    }
}

#Preview {
    struct GeneralSettingsView_Preview: View {
        var body: some View {
            GeneralSettingsView()
                .environmentObject(LanguageSetting())
        }
    }
    return GeneralSettingsView_Preview()
}
