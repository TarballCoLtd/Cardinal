//
//  SearchView.swift
//  REDSwift
//
//  Created by Tarball on 12/5/22.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var model: CardinalModel
    @State var search: String = ""
    @State var currentTerm: String = ""
    @State var searching: Bool = false
    @State var erroredOut: Bool = false
    let selections: [String] = [
        "Torrents",
        "Artists",
        "Requests",
        "Users",
    ]
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $model.selectionString) {
                    ForEach(selections, id: \.self) { selection in
                        Text(selection)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 15)
                if model.getAPIKey() == "" {
                    VStack {
                        Spacer()
                        Text("API Key Not Set")
                            .font(.title)
                        Text("Your API key can be set in settings.")
                        Spacer()
                    }
                } else if searching {
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
                } else if erroredOut {
                    RequestError {
                        performSearch()
                    }
                } else {
                    switch model.selectionString {
                    case selections[0]:
                        if model.currentTorrentSearch != nil {
                            TorrentResultsView($searching, $currentTerm)
                        }
                    case selections[1]:
                        if model.currentArtistSearch != nil {
                            ArtistResultsView($searching, $currentTerm)
                        }
                    case selections[2]:
                        if model.currentRequestSearch != nil {
                            RequestResultsView($searching, $currentTerm)
                        }
                    case selections[3]:
                        if model.currentUserSearch != nil {
                            UserResultsView($searching, $currentTerm)
                        }
                    default:
                        VStack {
                            Spacer()
                            Text("You should not be seeing this!")
                                .font(.title)
                            Spacer()
                                .frame(maxHeight: 20)
                            Text("Report this bug to the developer.")
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .multilineTextAlignment(.center)
                    }
                }
                Spacer()
            }
            .navigationTitle("Search")
        }
        .searchable(text: $search, prompt: "Search")
        .onSubmit(of: .search) {
            performSearch()
        }
    }
    func performSearch() {
        Task {
            do {
                if model.getAPIKey() != "" && !searching {
                    searching = true
                    currentTerm = search
                    switch model.selectionString {
                    case selections[0]:
                        model.currentTorrentSearch = try await model.api!.requestTorrentSearchResults(term: search, page: 1)
                        model.currentTorrentSearch!.groups.sort {
                            ($0.artist ?? "").caseInsensitiveCompare(search) == .orderedSame && ($1.artist ?? "").caseInsensitiveCompare(search) != .orderedSame
                        }
                        searching = false
                    case selections[1]:
                        model.currentArtistSearch = try await model.api!.requestArtistSearchResults(term: search, page: 1)
                        model.currentArtistSearch!.groups.sort {
                            ($0.artist ?? "").caseInsensitiveCompare(search) == .orderedSame && ($1.artist ?? "").caseInsensitiveCompare(search) != .orderedSame
                        }
                        searching = false
                    case selections[2]:
                        model.currentRequestSearch = try await model.api!.requestRequestSearchResults(term: search, page: 1)
                        searching = false
                    case selections[3]:
                        model.currentUserSearch = try await model.api!.requestUserSearchResults(term: search, page: 1)
                        searching = false
                    default:
                        print("excuse me?")
                        searching = false
                    }
                }
            } catch {
                #if DEBUG
                print(error)
                #endif
                erroredOut = true
                searching = false
            }
        }
    }
}
