//
//  BlogPostView.swift
//  Cardinal
//
//  Created by Tarball on 4/23/23.
//

import SwiftUI
import GazelleKit

struct BlogPostView: View {
    @EnvironmentObject var model: CardinalModel
    @State var post: BlogPost
    init(_ post: BlogPost) {
        self._post = State(initialValue: post)
    }
    var body: some View {
        List {
            Section(post.title) {
                if let time = post.time {
                    SectionTitle("Posted") {
                        HStack {
                            Text(time.timeAgo)
                            Spacer()
                        }
                    }
                }
                if let parsed = model.parsedAnnouncements[post.blogId] {
                    Text(parsed)
                } else {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    }
                    .onAppear {
                        Task {
                            model.parsedAnnouncements[post.blogId] = post.body.htmlToString()
                        }
                    }
                }
            }
        }
    }
}
