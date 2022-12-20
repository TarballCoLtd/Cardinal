//
//  SettingsView.swift
//  REDSwift
//
//  Created by Tarball on 12/7/22.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("apiKey") var apiKey: String = ""
    let version: String?
    let build: String?
    init() {
        version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
    var body: some View {
        List {
            Section("Authentication") {
                SecureField("API Key", text: $apiKey)
                Text("An API key can be created in your RED profile settings under Access Settings.")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            Section("About") {
                Text("App Version: \(version ?? "Error")")
            }
        }
        .navigationTitle("Settings")
    }
}
