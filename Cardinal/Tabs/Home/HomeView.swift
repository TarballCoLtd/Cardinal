//
//  HomeView.swift
//  REDSwift
//
//  Created by Tarball on 12/7/22.
//

import SwiftUI
import WhatsNewKit
import GazelleKit

struct HomeView: View {
    @EnvironmentObject var model: CardinalModel
    @AppStorage("apiKey") var redApiKey: String = ""
    @AppStorage("opsApiKey") var opsApiKey: String = ""
    @AppStorage("tracker") var tracker: GazelleTracker = .redacted
    @AppStorage("atsDisabledWarningShown") var atsDisabledWarningShown: Bool = false
    @State var refreshing: Bool = false
    @State var atsDisabledWarningSheetPresented: Bool = false
    @State var erroredOut: Bool = false
    var body: some View {
        NavigationView {
            Group {
                if let announcements = model.announcements {
                    VStack { // this VStack has no purpose other than to trigger a SwiftUI bug that makes the List collapsible only if its embedded in a VStack
                        List {
                            if !announcements.containsNullAnnouncements() && announcements.announcements.count > 0 {
                                Section("Announcements") {
                                    ForEach(announcements.announcements) { announcement in
                                        NavigationLink {
                                            AnnouncementView(announcement)
                                        } label: {
                                            Text(announcement.title ?? "")
                                                .font(.caption)
                                                //.foregroundColor(.gray)
                                                .bold()
                                        }
                                    }
                                }
                            }
                            if announcements.blogPosts.count > 0 {
                                Section("Blog Posts") {
                                    ForEach (announcements.blogPosts) { post in
                                        NavigationLink {
                                            BlogPostView(post)
                                        } label: {
                                            Text(post.title)
                                                .font(.caption)
                                                .bold()
                                        }
                                    }
                                }
                            }
                        }
                        .refreshable(action: refresh)
                    }
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Home")
                                .fixedSize(horizontal: true, vertical: false)
                                .font(.headline)
                        }
                    }
                    #if ATS_DISABLED
                    .onAppear {
                        if !atsDisabledWarningShown {
                            atsDisabledWarningShown = true
                            atsDisabledWarningSheetPresented = true
                        }
                    }
                    .sheet(isPresented: $atsDisabledWarningSheetPresented) {
                        ATSDisabledSheet()
                    }
                    #endif
                } else if erroredOut {
                    RequestError {
                        do {
                            model.announcements = nil
                            model.announcements = try await model.api!.requestAnnouncements(perPage: 100)
                        } catch {
                            erroredOut = true
                        }
                    }
                } else if model.getAPIKey() != "" {
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
                            do {
                                model.announcements = nil
                                model.announcements = try await model.api!.requestAnnouncements(perPage: 100)
                            } catch {
                                #if DEBUG
                                print(error)
                                #endif
                                erroredOut = true
                            }
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                            .resizable()
                            .scaledToFit()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Group {
                        if refreshing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Menu(HomeView.getShortenedTrackerName(tracker)) {
                                Button("Redacted (RED)", action: selectRedacted)
                                Button("Orpheus (OPS)", action: selectOrpheus)
                            }
                        }
                    }
                    .onChange(of: tracker) { _ in
                        Task {
                            refreshing = true
                            await refresh()
                            refreshing = false
                        }
                    }
                }
            }
            #if DEBUG
            .onAppear {
                print("DEBUG: current tracker is \(tracker.rawValue)")
                print("DEBUG: api key is \(model.getAPIKey())")
            }
            #endif
        }
    }
    
    @Sendable
    func refresh() async {
        do {
            model.announcements = try await model.api!.requestAnnouncements(perPage: 100)
        } catch {
            erroredOut = true
        }
    }
    
    func selectRedacted() {
        tracker = .redacted
        model.setAPIKey(redApiKey)
    }
    
    func selectOrpheus() {
        tracker = .orpheus
        model.setAPIKey(opsApiKey)
    }
}
