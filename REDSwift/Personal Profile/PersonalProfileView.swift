//
//  PersonalProfileView.swift
//  REDSwift
//
//  Created by Tarball on 12/3/22.
//

import SwiftUI

struct PersonalProfileView: View {
    @EnvironmentObject var model: REDAppModel
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if model.personalProfile != nil {
            RefreshableScrollView {
                VStack {
                    HStack {
                        Text(model.personalProfile!.username)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.red)
                        Text("(\(model.personalProfile!.userClass))")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.top, 10)
                    Divider()
                }
                .padding(.horizontal, 20)
                SectionTitle("Stats") {
                    UserStats()
                }
                .padding(10)
                SectionTitle("Ranks (Percentile)") {
                    UserRanks()
                }
                .padding(10)
                Spacer()
            } onRefresh: {
                let profile = try! await model.api!.requestPersonalProfile()
                model.personalProfile = try! await model.api!.requestUserProfile(user: profile.id)
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
            .task {
                let profile = try! await model.api!.requestPersonalProfile()
                model.personalProfile = try! await model.api!.requestUserProfile(user: profile.id)
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

struct RefreshableScrollView<Content: View>: View { // natively refreshable ScrollViews were introduced in iOS 16, i am supporting iOS 15
    @ViewBuilder var content: Content
    var onRefresh: () async -> Void

    init(@ViewBuilder content: @escaping () -> Content, onRefresh: @escaping () async -> Void) {
        self.content = content()
        self.onRefresh = onRefresh
    }

    var body: some View {
        List {
            content
                .listRowSeparatorTint(.clear)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(.plain)
        .refreshable {
            await onRefresh()
        }
    }
}
