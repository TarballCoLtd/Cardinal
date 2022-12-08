//
//  HomeView.swift
//  REDSwift
//
//  Created by Tarball on 12/7/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var model: REDAppModel
    var body: some View {
        if model.announcements != nil {
            NavigationView {
                List {
                    ForEach(model.announcements!.announcements) { announcement in
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
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        SettingsView()
                    }
                    ToolbarItem(placement: .principal) {
                        Text("Home")
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.headline)
                    }
                }
            }
        } else if model.api != nil {
            VStack {
                Spacer()
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.horizontal, 2)
                    Text("Loading...")
                }
                Spacer()
            }
            .onAppear {
                Task { // this is dumb but for some reason when i use `.task(_:)`, it shits itself
                    model.announcements = try! await model.api!.requestAnnouncements(perPage: 100)
                    model.announcements!.announcements.reverse()
                    //model.announcements!.announcements = [model.announcements!.announcements.first!]
                }
            }
        } else {
            VStack {
                Text("API Key Not Set")
                    .font(.title)
                Text("Your API key can be set in settings.")
            }
        }
    }
}
