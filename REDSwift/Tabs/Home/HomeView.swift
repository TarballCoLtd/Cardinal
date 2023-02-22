//
//  HomeView.swift
//  REDSwift
//
//  Created by Tarball on 12/7/22.
//

import SwiftUI
import WhatsNewKit

struct HomeView: View {
    @EnvironmentObject var model: REDAppModel
    @AppStorage("apiKey") var apiKey: String = ""
    @AppStorage("atsDisabledWarningShown") var atsDisabledWarningShown: Bool = false
    @State var atsDisabledWarningSheetPresented: Bool = false
    @State var erroredOut: Bool = false
    var body: some View {
        NavigationView {
            Group {
                if model.announcements != nil {
                    VStack { // this VStack has no purpose other than to trigger a SwiftUI bug that makes the List collapsible only if its embedded in a VStack
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
                        .refreshable {
                            do {
                                model.announcements = try await model.api!.requestAnnouncements(perPage: 100)
                                model.announcements!.announcements.reverse()
                            } catch {
                                erroredOut = true
                            }
                        }
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
                            model.announcements!.announcements.reverse()
                        } catch {
                            erroredOut = true
                        }
                    }
                } else if apiKey != "" {
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
                                model.announcements!.announcements.reverse()
                            } catch {
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
            }
        }
    }
}
