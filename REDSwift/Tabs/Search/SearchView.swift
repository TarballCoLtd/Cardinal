//
//  SearchView.swift
//  REDSwift
//
//  Created by Tarball on 12/5/22.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var model: REDAppModel
    @State var search: String = ""
    @State var searching: Bool = false
    @State var selectionString: String = "Torrents"
    let selections: [String] = [
        "Torrents",
        "Artists",
        "Requests",
        "Users",
    ]
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $selectionString) {
                    ForEach(selections, id: \.self) { selection in
                        Text(selection)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 15)
                if searching {
                    VStack {
                        Spacer()
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding(.horizontal, 2)
                            Text("Searching...")
                        }
                        Spacer()
                    }
                } else  {
                    switch selectionString {
                    case selections[0]:
                        if model.currentTorrentSearch != nil {
                            TorrentResultsView()
                        }
                    case selections[1]:
                        if model.currentArtistSearch != nil {
                            ArtistResultsView()
                        }
                    case selections[2]:
                        if model.currentRequestSearch != nil {
                            RequestResultsView()
                        }
                    case selections[3]:
                        if model.currentUserSearch != nil {
                            UserResultsView()
                        }
                    default:
                        VStack {
                            Text("You should not be seeing this!")
                                .font(.title)
                            Text("Report this bug to the developer.")
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("Search")
        }
        .searchable(text: $search, prompt: "Search")
        .onSubmit(of: .search) {
            Task {
                searching = true
                switch selectionString {
                case selections[0]:
                    model.currentTorrentSearch = try! await model.api!.requestTorrentSearchResults(term: search)
                    model.currentTorrentSearch!.groups.sort {
                        ($0.artist ?? "").caseInsensitiveCompare(search) == .orderedSame && ($1.artist ?? "").caseInsensitiveCompare(search) != .orderedSame
                    }
                    searching = false
                case selections[1]:
                    model.currentArtistSearch = try! await model.api!.requestArtistSearchResults(term: search)
                    model.currentArtistSearch!.groups.sort {
                        ($0.artist ?? "").caseInsensitiveCompare(search) == .orderedSame && ($1.artist ?? "").caseInsensitiveCompare(search) != .orderedSame
                    }
                    searching = false
                case selections[2]:
                    model.currentRequestSearch = try! await model.api!.requestRequestSearchResults(term: search)
                    searching = false
                case selections[3]:
                    model.currentUserSearch = try! await model.api!.requestUserSearchResults(term: search)
                    searching = false
                default:
                    print("excuse me?")
                    searching = false
                }
            }
        }
    }
}
