//
//  TorrentResultsView.swift
//  REDSwift
//
//  Created by Tarball on 12/5/22.
//

import SwiftUI

struct TorrentResultsView: View {
    @EnvironmentObject var model: CardinalModel
    @Binding var searching: Bool
    @Binding var search: String
    @State var erroredOut: Bool = false
    init(_ searching: Binding<Bool>, _ search: Binding<String>) {
        self._searching = searching
        self._search = search
    }
    var body: some View {
        RectangleOverlay {
            HStack {
                if let currentSearch = model.currentTorrentSearch {
                    if (currentSearch.currentPage ?? 0) > 1 {
                        Image(systemName: "arrowtriangle.left.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.accentColor)
                            .frame(maxWidth: 20)
                            .padding(.horizontal, 10)
                            .onTapGesture {
                                Task {
                                    do {
                                        searching = true
                                        model.currentTorrentSearch = try await model.api!.requestTorrentSearchResults(term: search, page: (currentSearch.currentPage ?? 0) - 1)
                                        model.currentTorrentSearch!.groups.sort {
                                            ($0.artist ?? "").caseInsensitiveCompare(search) == .orderedSame && ($1.artist ?? "").caseInsensitiveCompare(search) != .orderedSame
                                        }
                                        searching = false
                                    } catch {
                                        erroredOut = true
                                        searching = false
                                    }
                                }
                            }
                    } else {
                        Image(systemName: "arrowtriangle.left.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .frame(maxWidth: 20)
                            .padding(.horizontal, 10)
                    }
                    Spacer()
                    Text("Page \(currentSearch.currentPage ?? 0) of \(currentSearch.pages ?? 0)")
                    Spacer()
                    if (currentSearch.currentPage ?? 0) < (currentSearch.pages ?? 0) {
                        Image(systemName: "arrowtriangle.right.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.accentColor)
                            .frame(maxWidth: 20)
                            .padding(.horizontal, 10)
                            .onTapGesture {
                                Task {
                                    do {
                                        searching = true
                                        model.currentTorrentSearch = try await model.api!.requestTorrentSearchResults(term: search, page: (currentSearch.currentPage ?? 0) + 1)
                                        model.currentTorrentSearch!.groups.sort {
                                            ($0.artist ?? "").caseInsensitiveCompare(search) == .orderedSame && ($1.artist ?? "").caseInsensitiveCompare(search) != .orderedSame
                                        }
                                        searching = false
                                    } catch {
                                        erroredOut = true
                                        searching = false
                                    }
                                }
                            }
                    } else {
                        Image(systemName: "arrowtriangle.right.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .frame(maxWidth: 20)
                            .padding(.horizontal, 10)
                    }
                } else if erroredOut {
                    RequestError()
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        List {
            ForEach(model.currentTorrentSearch!.groups) { group in
                if group.torrents.count > 0 {
                    NavigationLink {
                        TorrentGroupView(group, requestSize: model.currentTorrentSearch!.requestSize)
                    } label: {
                        Text(group.artist ?? "Unknown Artist")
                        + Text("\n")
                        + Text("\(group.groupName) (\(String(group.groupYear ?? -1)))")
                    }
                }
            }
            if model.currentTorrentSearch!.groups.count == 0 {
                Text("No Results")
            }
        }
    }
}
