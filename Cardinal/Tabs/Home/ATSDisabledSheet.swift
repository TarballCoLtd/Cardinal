//
//  ATSDisabledSheet.swift
//  REDSwift
//
//  Created by Tarball on 12/11/22.
//

import SwiftUI

struct ATSDisabledSheet: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Image(systemName: "exclamationmark.shield")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 80)
                    .foregroundColor(.red)
                Text("You are using a version of REDSwift with App Transport Security disabled.")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                Text("This is an inherent security risk. Its only real benefit in this app is to allow loading profile pictures over HTTP instead of HTTPS. Unless this is an essential feature to you, use the normal version of REDSwift.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Warning")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("OK") {
                        dismiss()
                    }
                }
            }
        }
    }
}
