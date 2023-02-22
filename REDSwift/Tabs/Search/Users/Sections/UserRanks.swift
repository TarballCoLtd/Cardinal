//
//  UserRanks.swift
//  REDSwift
//
//  Created by Tarball on 12/6/22.
//

import SwiftUI
import GazelleKit

struct UserRanks: View {
    @State var profile: UserProfile
    init(_ profile: UserProfile) {
        self._profile = State(initialValue: profile)
    }
    var body: some View {
        RectangleOverlay {
            VStack {
                if let uploadedRank = profile.uploadedRank {
                    HStack {
                        Text("Uploaded:")
                        Spacer()
                        Text(String(uploadedRank))
                    }
                }
                if let downloadedRank = profile.downloadedRank {
                    HStack {
                        Text("Downloaded:")
                        Spacer()
                        Text(String(downloadedRank))
                    }
                }
                if let uploadsRank = profile.uploadsRank {
                    HStack {
                        Text("Uploads:")
                        Spacer()
                        Text(String(uploadsRank))
                    }
                }
                if let requestsRank = profile.requestsRank {
                    HStack {
                        Text("Requests:")
                        Spacer()
                        Text(String(requestsRank))
                    }
                }
                if let bountyRank = profile.bountyRank {
                    HStack {
                        Text("Bounty:")
                        Spacer()
                        Text(String(bountyRank))
                    }
                }
                if let postsRank = profile.postsRank {
                    HStack {
                        Text("Posts:")
                        Spacer()
                        Text(String(postsRank))
                    }
                }
                if let artistsRank = profile.artistsRank {
                    HStack {
                        Text("Artists:")
                        Spacer()
                        Text(String(artistsRank))
                    }
                }
                if let overallRank = profile.overallRank {
                    HStack {
                        Text("Overall:")
                        Spacer()
                        Text(String(overallRank))
                    }
                }
            }
        }
    }
    
    static func shouldDisplay(_ profile: UserProfile) -> Bool {
        return profile.uploadedRank != nil && profile.downloadedRank != nil && profile.uploadsRank != nil && profile.requestsRank != nil && profile.bountyRank != nil && profile.postsRank != nil && profile.artistsRank != nil && profile.overallRank != nil
    }
}
