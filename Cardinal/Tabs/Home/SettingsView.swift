//
//  SettingsView.swift
//  REDSwift
//
//  Created by Tarball on 12/7/22.
//

import SwiftUI
import GazelleKit

struct SettingsView: View {
    @EnvironmentObject var model: CardinalModel
    @AppStorage("apiKey") var redApiKey: String = ""
    @AppStorage("opsApiKey") var opsApiKey: String = ""
    @AppStorage("tracker") var tracker: GazelleTracker = .redacted
    let version: String?
    let build: String?
    init() {
        version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
    var body: some View {
        List {
            Section("Redacted Key") {
                SecureField("RED API Key", text: $redApiKey)
                Text("An API key can be created in your RED profile settings under Access Settings. Be sure to only select permissions you're comfortable with this app having. Do not share your API key with anyone under any circumstances.")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            Section("Orpheus Key") {
                SecureField("OPS API Key", text: $opsApiKey)
                Text("An API key can be created in your OPS profile settings under Access Settings. Do not share your API key with anyone under any circumstances.")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            Section("About") {
                HStack {
                    Text("App Version:")
                    Spacer()
                    Text("\(version ?? "Error") (\(build ?? "-1"))")
                }
            }
        }
        .navigationTitle("Settings")
        .onChange(of: redApiKey) { apiKey in
            if tracker == .redacted {
                model.setAPIKey(apiKey)
            }
        }
        .onChange(of: opsApiKey) { apiKey in
            if tracker == .orpheus {
                model.setAPIKey(apiKey)
            }
        }
    }
}
