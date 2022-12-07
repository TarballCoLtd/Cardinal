//
//  ArtistResultsView.swift
//  REDSwift
//
//  Created by Tarball on 12/6/22.
//

import SwiftUI

struct ArtistResultsView: View {
    @EnvironmentObject var model: REDAppModel
    var body: some View {
        List {
            ForEach(model.currentArtistSearch!.groups) { group in
                if group.torrents.count > 0 {
                    NavigationLink {
                        TorrentGroupView(group, requestSize: model.currentArtistSearch!.requestSize)
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
