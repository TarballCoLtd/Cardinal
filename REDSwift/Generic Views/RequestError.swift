//
//  RequestError.swift
//  REDSwift
//
//  Created by Tarball on 12/20/22.
//

import SwiftUI

struct RequestError: View {
    var onRefresh: () async -> Void

    init(onRefresh: @escaping () async -> Void) {
        self.onRefresh = onRefresh
    }
    
    init() {
        self.onRefresh = {}
    }

    var body: some View { // TODO: add error SF symbol of some sort
        RefreshableScrollView {
            HStack {
                Spacer()
                VStack {
                    Text("Error occurred")
                        .font(.title)
                    Text("while fetching")
                        .font(.title)
                    Spacer()
                        .frame(maxHeight: 20)
                    Text("Pull to refresh.")
                }
                Spacer()
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
        } onRefresh: {
            await onRefresh()
        }
    }
}
