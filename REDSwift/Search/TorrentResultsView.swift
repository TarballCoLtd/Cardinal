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
        Text("yee")
    }
}
