//
//  SettingsView.swift
//  REDSwift
//
//  Created by Tarball on 12/7/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var model: CardinalModel
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
                Text("An API key can be created in your RED profile settings under Access Settings. Be sure to only select permissions you're comfortable with this app having. Do not share your API key with anyone under any circumstances.")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            Section("About") {
                HStack {
                    Text("App Version:")
                    Spacer()
                    Text("\(version ?? "Error") (\(build ?? "0"))")
                }
            }
        }
        .navigationTitle("Settings")
        .onChange(of: apiKey) { apiKey in
            print("PEEPEE FART")
            model.setAPIKey(apiKey)
        }
    }
}
