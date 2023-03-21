//
//  TorrentGroupView.swift
//  REDSwift
//
//  Created by Tarball on 12/6/22.
//

import SwiftUI
import GazelleKit

struct TorrentGroupView: View {
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
                        TorrentView(group, torrent)
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
    static func release(_ torrent: Torrent) -> String {
        var ret: String = ""
        ret += "\(torrent.remasteredYear) - "
        if torrent.remasterCatalogueNumber != "" {
            ret += "\(torrent.remasterCatalogueNumber) / "
        }
        ret += torrent.media
        return ret
    }
    static func encoding(_ torrent: Torrent) -> LocalizedStringKey {
        var ret: String = "\(torrent.format) / \(torrent.encoding)"
        if torrent.isFreeload {
            ret += " / **Freeload!**"
        }
        if torrent.isFreeleech {
            ret += " / **Freeleech!**"
        }
        if torrent.isNeutralLeech {
            ret += " / **Neutral Leech!**"
        }
        if torrent.isPersonalFreeleech {
            ret += " / **Personal Freeleech!**"
        }
        return LocalizedStringKey(ret)
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
