//
//  UserResultsView.swift
//  REDSwift
//
//  Created by Tarball on 12/6/22.
//

import SwiftUI

struct UserResultsView: View {
    @EnvironmentObject var model: REDAppModel
    var body: some View {
        List {
            ForEach(model.currentUserSearch!.results) { result in
                NavigationLink {
                    UserProfileView(result)
                } label: {
                    Text(result.username)
                }
            }
        }
    }
}
