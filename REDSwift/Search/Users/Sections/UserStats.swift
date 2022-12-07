//
//  UserStats.swift
//  REDSwift
//
//  Created by Tarball on 12/6/22.
//

import SwiftUI

struct UserStats: View {
    let formatter = DateFormatter()
    @State var profile: UserProfile
    init(_ profile: UserProfile) {
        self._profile = State(initialValue: profile)
        formatter.dateStyle = .short
    }
    var body: some View {
        RectangleOverlay {
            VStack {
                HStack {
                    Text("Joined:")
                    Spacer()
                    Text(formatter.string(from: profile.joinedDate))
                }
                if let lastSeen = profile.lastSeen {
                    HStack {
                        Text("Last seen:")
                        Spacer()
                        Text(formatter.string(from: lastSeen))
                    }
                }
                if let uploaded = profile.uploaded {
                    HStack {
                        Text("Uploaded:")
                        Spacer()
                        Text(uploaded.toRelevantDataUnit())
                    }
                }
                if let downloaded = profile.downloaded {
                    HStack {
                        Text("Downloaded:")
                        Spacer()
                        Text(downloaded.toRelevantDataUnit())
                    }
                }
                if let ratio = profile.ratio {
                    if ratio > 0 {
                        HStack {
                            Text("Ratio:")
                            Spacer()
                            Text(String(format: "%.2f", ratio))
                        }
                    }
                }
                if let requiredRatio = profile.requiredRatio {
                    HStack {
                        Text("Required Ratio:")
                        Spacer()
                        Text(String(format: "%.2f", requiredRatio))
                    }
                }
            }
        }
    }
}
