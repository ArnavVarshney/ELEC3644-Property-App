//
//  SettingsView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 16/11/24.
//
import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Divider()
            Text("Settings").font(.system(size: 24, weight: .medium))
            VStack(alignment: .leading) {
                Text("Notifications").font(.system(size: 16, weight: .bold))
                Toggle("Allow Notifications", isOn: .constant(true))
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            }
            VStack(alignment: .leading) {
                Text("Account").font(.system(size: 16, weight: .bold))
                Button(
                    action: { print("Sign out") },
                    label: {
                        HStack {
                            Image(systemName: "person")
                            Text("Sign Out")
                        }
                        .frame(maxWidth: .infinity)
                    })
            }
        }
    }
}

#Preview {
    struct SettingsView_Preview: View { var body: some View { SettingsView() } }
    return SettingsView_Preview()
}
