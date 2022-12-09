//
//  SettingsView.swift
//  REDSwift
//
//  Created by Tarball on 12/7/22.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("apiKey") var apiKey: String = ""
    var body: some View {
        List {
            Section("Authentication") {
                SecureField("API Key", text: $apiKey)
                Text("An API key can be created in your RED profile settings under Access Settings.")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
        .navigationTitle("Settings")
    }
}
