//
//  UserStats.swift
//  REDSwift
//
//  Created by Tarball on 12/6/22.
//

import SwiftUI
import GazelleKit

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
                    Text("Tracker:")
                    Spacer()
                    Text(GazelleAPI.getTrackerName(tracker))
                }
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
                            if let required = profile.requiredRatio, let ratio = profile.calcRatio {
                                if ratio < required {
                                    Text(String(format: "%.2f", ratio))
                                        .foregroundColor(.red)
                                        .bold()
                                } else {
                                    Text(String(format: "%.2f", ratio))
                                }
                            } else {
                                Text(String(format: "%.2f", ratio))
                            }
                        }
                    }
                }
                if let required = profile.requiredRatio {
                    HStack {
                        Text("Required Ratio:")
                        Spacer()
                        Text(String(format: "%.2f", required))
                    }
                }
            }
        }
    }
}
