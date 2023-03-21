//
//  TorrentView.swift
//  REDSwift
//
//  Created by Tarball on 12/6/22.
//

import SwiftUI
import GazelleKit

struct TorrentView: View {
    @EnvironmentObject var model: REDAppModel
    @State var group: TorrentGroup
    @State var torrent: Torrent
    @State var searchSizeAlert: Bool = false
    init(_ group: TorrentGroup, _ torrent: Torrent) {
        self._group = State(initialValue: group)
        self._torrent = State(initialValue: torrent)
    }
    var body: some View {
        List {
            Group {
                SectionTitle(torrent.artists.count == 1 ? "Artist" : "Artists") {
                    HStack {
                        Text(TorrentView.artists(torrent.artists))
                        Spacer()
                    }
                }
                SectionTitle("Group Name") {
                    HStack {
                        Text(group.groupName)
                        Spacer()
                    }
                }
                SectionTitle("Media") {
                    HStack {
                        Text(torrent.media)
                        Spacer()
                    }
                }
                if torrent.media == "CD" && torrent.format == "FLAC" {
                    SectionTitle("Log Score") {
                        HStack {
                            Text("\(torrent.logScore)%")
                            Spacer()
                        }
                    }
                    SectionTitle("Has Cuesheet?") {
                        HStack {
                            Text(torrent.hasCue ? "Yes" : "No")
                            Spacer()
                        }
                    }
                }
                if torrent.scene {
                    SectionTitle("Scene?") {
                        HStack {
                            Text("Yes")
                            Spacer()
                        }
                    }
                }
                SectionTitle("Codec/Container") {
                    HStack {
                        Text(torrent.format)
                        Spacer()
                    }
                }
                SectionTitle(torrent.format == "FLAC" ? "Bit Depth" : "Bitrate") {
                    HStack {
                        Text(TorrentView.quality(torrent))
                        Spacer()
                    }
                }
                if torrent.remastered && torrent.remasterTitle != "" {
                    SectionTitle("Remaster") {
                        HStack {
                            Text("\(torrent.remasterTitle)\nRemastered \(String(torrent.remasteredYear))")
                            Spacer()
                        }
                    }
                }
                SectionTitle("File Count") {
                    HStack {
                        Text(String(torrent.fileCount))
                        Spacer()
                    }
                }
                SectionTitle("Created") {
                    HStack {
                        Text(torrent.time.timeAgo)
                        Spacer()
                    }
                }
            }
            Group {
                SectionTitle("Size") {
                    HStack {
                        Text(torrent.size.toRelevantDataUnit())
                        Spacer()
                    }
                }
                SectionTitle("Snatches") {
                    HStack {
                        Text(String(torrent.snatches))
                        Spacer()
                    }
                }
                SectionTitle("Seeders") {
                    HStack {
                        Text(String(torrent.seeders))
                        Spacer()
                    }
                }
                SectionTitle("Leechers") {
                    HStack {
                        Text(String(torrent.leechers))
                        Spacer()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(group.groupName)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Text(model.currentTorrentSearch!.requestSize.toRelevantDataUnit())
                    .onTapGesture {
                        searchSizeAlert = true
                    }
                    .alert("Data used by this search:\n\(model.currentTorrentSearch!.requestSize.toRelevantDataUnit())", isPresented: $searchSizeAlert) {
                        Button("OK") {}
                    }
            }
        }
    }
    static func artists(_ artists: [Artist]) -> String {
        var ret: String = ""
        var iterations: Int = 0
        for artist in artists {
            if iterations == artists.count - 1 {
                ret += artist.name
            } else {
                ret += "\(artist.name)\n"
            }
            iterations += 1
        }
        return ret
    }
    static func quality(_ torrent: Torrent) -> String {
        if torrent.encoding == "Lossless" {
            return "16-bit"
        }
        if torrent.encoding == "24-bit Lossless" {
            return "24-bit"
        }
        return torrent.encoding
    }
}

extension Date {
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
