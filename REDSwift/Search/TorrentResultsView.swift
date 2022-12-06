//
//  TorrentResultsView.swift
//  REDSwift
//
//  Created by Tarball on 12/5/22.
//

import SwiftUI

struct TorrentResultsView: View {
    @State var results: TorrentSearchResult
    init(_ results: TorrentSearchResult) {
        self._results = State(initialValue: results)
    }
    var body: some View {
        List {
            ForEach(results.groups) { group in
                if group.torrents.count > 0 {
                    NavigationLink {
                        TorrentGroupView(group, requestSize: results.requestSize)
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
