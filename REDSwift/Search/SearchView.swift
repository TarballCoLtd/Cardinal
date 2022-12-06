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
    @State var searchResults: AnyView?
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
                } else if let results = searchResults {
                    results
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
                    let result = try! await model.api!.requestTorrentSearchResults(term: search)
                    searchResults = AnyView(TorrentResultsView(result))
                    searching = false
                case selections[1]:
                    searching = false
                case selections[2]:
                    searching = false
                case selections[3]:
                    searching = false
                default:
                    print("excuse me?")
                    searching = false
                }
            }
        }
    }
}
