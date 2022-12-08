//
//  RequestResultsView.swift
//  REDSwift
//
//  Created by Tarball on 12/7/22.
//

import SwiftUI

struct RequestResultsView: View {
    @EnvironmentObject var model: REDAppModel
    let gradient = LinearGradient(gradient: Gradient(colors: [.accentColor, .cyan, .accentColor]), startPoint: .leading, endPoint: .trailing)
    var body: some View {
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
