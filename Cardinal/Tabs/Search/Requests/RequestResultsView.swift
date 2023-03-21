//
//  RequestResultsView.swift
//  REDSwift
//
//  Created by Tarball on 12/7/22.
//

import SwiftUI

struct RequestResultsView: View {
    @EnvironmentObject var model: REDAppModel
    @Binding var searching: Bool
    @Binding var search: String
    @State var erroredOut: Bool = false
    init(_ searching: Binding<Bool>, _ search: Binding<String>) {
        self._searching = searching
        self._search = search
    }
    let gradient = LinearGradient(gradient: Gradient(colors: [.accentColor, .cyan, .accentColor]), startPoint: .leading, endPoint: .trailing)
    var body: some View {
        RectangleOverlay {
            HStack {
                if let currentSearch = model.currentRequestSearch {
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
                                        model.currentRequestSearch = try await model.api!.requestRequestSearchResults(term: search, page: (currentSearch.currentPage ?? 0) - 1)
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
                                        model.currentRequestSearch = try await model.api!.requestRequestSearchResults(term: search, page: (currentSearch.currentPage ?? 0) + 1)
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
            ForEach(model.currentRequestSearch!.requests) { request in
                NavigationLink {
                    RequestView(request, requestSize: model.currentRequestSearch!.requestSize)
                } label: {
                    HStack {
                        Text(request.title.replacingOccurrences())
                        Spacer()
                        AccentCapsule(request.bounty.toRelevantDataUnit())
                    }
                }
            }
        }
    }
}
