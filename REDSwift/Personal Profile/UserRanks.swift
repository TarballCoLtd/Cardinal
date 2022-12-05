//
//  UserRanks.swift
//  REDSwift
//
//  Created by Tarball on 12/3/22.
//

import SwiftUI

struct UserRanks: View {
    @EnvironmentObject var model: REDAppModel
    var body: some View {
        RectangleOverlay {
            VStack {
                HStack {
                    Text("Uploaded:")
                    Spacer()
                    Text(String(model.personalProfile!.uploadedRank!))
                }
                HStack {
                    Text("Downloaded:")
                    Spacer()
                    Text(String(model.personalProfile!.downloadedRank!))
                }
                HStack {
                    Text("Uploads:")
                    Spacer()
                    Text(String(model.personalProfile!.uploadsRank!))
                }
                HStack {
                    Text("Requests:")
                    Spacer()
                    Text(String(model.personalProfile!.requestsRank!))
                }
                HStack {
                    Text("Bounty:")
                    Spacer()
                    Text(String(model.personalProfile!.bountyRank!))
                }
                HStack {
                    Text("Posts:")
                    Spacer()
                    Text(String(model.personalProfile!.postsRank!))
                }
                HStack {
                    Text("Artists:")
                    Spacer()
                    Text(String(model.personalProfile!.artistsRank!))
                }
                HStack {
                    Text("Overall:")
                    Spacer()
                    Text(String(model.personalProfile!.overallRank!))
                }
            }
        }
    }
}
