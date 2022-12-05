//
//  SearchView.swift
//  REDSwift
//
//  Created by Tarball on 12/5/22.
//

import SwiftUI

struct SearchView: View {
    @State var search: String = ""
    var body: some View {
        NavigationView {
            VStack {
                Text("im GAY and i PISS and SHIT all over the place")
                Spacer()
            }
        }
        .searchable(text: $search, prompt: "Search")
    }
}
