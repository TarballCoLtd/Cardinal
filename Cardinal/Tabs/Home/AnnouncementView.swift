//
//  AnnouncementView.swift
//  Cardinal
//
//  Created by Tarball on 3/21/23.
//

import SwiftUI
import GazelleKit

struct AnnouncementView: View {
    @EnvironmentObject var model: CardinalModel
    @State var announcement: Announcement
    init(_ announcement: Announcement) {
        self._announcement = State(initialValue: announcement)
    }
    var body: some View {
        List {
            Section(announcement.title) {
                if let time = announcement.time {
                    SectionTitle("Posted") {
                        HStack {
                            Text(time.timeAgo)
                            Spacer()
                        }
                    }
                }
                if let parsed = model.parsedAnnouncements[announcement.announcementId] {
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
                            model.parsedAnnouncements[announcement.announcementId] = announcement.body.htmlToString()
                        }
                    }
                }
            }
        }
    }
}
