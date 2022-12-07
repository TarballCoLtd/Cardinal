//
//  TorrentResultsView.swift
//  REDSwift
//
//  Created by Tarball on 12/5/22.
//

import SwiftUI

struct TorrentResultsView: View {
    @EnvironmentObject var model: REDAppModel
    var body: some View {
        List {
            ForEach(model.currentTorrentSearch!.groups) { group in
                if group.torrents.count > 0 {
                    NavigationLink {
                        TorrentGroupView(group, requestSize: model.currentTorrentSearch!.requestSize)
                    } label: {
                        Text(group.artist ?? "Unknown Artist")
                        + Text("\n")
                        + Text("\(group.groupName) (\(String(group.groupYear ?? -1)))")
                    }
                }
            }
        }
    }
}
