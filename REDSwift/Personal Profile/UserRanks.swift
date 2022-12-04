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
                    Text("Downloaded")
                    Spacer()
                    Text(String(model.personalProfile!.downloadedRank!))
                }
                HStack {
                    Text("Uploads")
                    Spacer()
                    Text(String(model.personalProfile!.uploadsRank!))
                }
            }
        }
    }
}
