//
//  UserResultsView.swift
//  REDSwift
//
//  Created by Tarball on 12/6/22.
//

import SwiftUI

struct UserResultsView: View {
    @EnvironmentObject var model: REDAppModel
    @Binding var searching: Bool
    @Binding var search: String
    init(_ searching: Binding<Bool>, _ search: Binding<String>) {
        self._searching = searching
        self._search = search
    }
    var body: some View {
        RectangleOverlay {
            HStack {
                if let currentSearch = model.currentUserSearch {
                    if (currentSearch.currentPage ?? 0) > 1 {
                        Image(systemName: "arrowtriangle.left.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.accentColor)
                            .frame(maxWidth: 20)
                            .padding(.horizontal, 10)
                            .onTapGesture {
                                Task {
                                    searching = true
                                    model.currentUserSearch = try! await model.api.requestUserSearchResults(term: search, page: (currentSearch.currentPage ?? 0) - 1)
                                    searching = false
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
                                    searching = true
                                    model.currentUserSearch = try! await model.api.requestUserSearchResults(term: search, page: (currentSearch.currentPage ?? 0) + 1)
                                    searching = false
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
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        List {
            ForEach(model.currentUserSearch!.results) { result in
                NavigationLink {
                    UserProfileView(result)
                } label: {
                    HStack {
                        Text(result.username)
                        Spacer()
                        AccentCapsule(result.class)
                    }
                }
            }
        }
    }
}
