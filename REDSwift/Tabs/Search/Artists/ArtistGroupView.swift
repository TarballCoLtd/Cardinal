//
//  ArtistGroupView.swift
//  REDSwift
//
//  Created by Tarball on 12/7/22.
//

import SwiftUI

struct ArtistGroupView: View {
    @State var group: TorrentGroup
    @State var requestSize: Int
    @State var searchSizeAlert: Bool = false
    init(_ group: TorrentGroup, requestSize: Int) {
        self._group = State(initialValue: group)
        self._requestSize = State(initialValue: requestSize)
    }
    var body: some View {
        List {
            Section("\(group.artist ?? "Unknown Artist") - \(group.groupName)") {
                ForEach(group.torrents) { torrent in
                    NavigationLink {
                        ArtistTorrentView(group, torrent)
                    } label: {
                        Text(TorrentGroupView.release(torrent))
                        + Text("\n")
                        + Text(TorrentGroupView.encoding(torrent))
                        + Text("\n")
                        + Text(torrent.size.toRelevantDataUnit())
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(group.groupName)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Text(requestSize.toRelevantDataUnit())
                    .onTapGesture {
                        searchSizeAlert = true
                    }
                    .alert("Data used by this search:\n\(requestSize.toRelevantDataUnit())", isPresented: $searchSizeAlert) {
                        Button("OK") {}
                    }
            }
        }
    }
}
