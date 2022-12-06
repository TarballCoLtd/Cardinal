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
                if let results = searchResults {
                    results
                }
                Spacer()
            }
            .navigationTitle("Search")
        }
        .searchable(text: $search, prompt: "Search")
        .onSubmit(of: .search) {
            Task {
                print("poo??")
                switch selectionString {
                case selections[0]:
                    let result = try! await model.api!.requestTorrentSearchResults(term: search)
                    print("sus af")
                    searchResults = AnyView(TorrentResultsView(result))
                case selections[1]:
                    print("fart")
                case selections[2]:
                    print("fart")
                case selections[3]:
                    print("fart")
                default:
                    print("excuse me?")
                }
            }
        }
    }
}
