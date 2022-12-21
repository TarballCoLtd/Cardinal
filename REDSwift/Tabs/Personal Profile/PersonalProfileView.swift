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
    @AppStorage("apiKey") var apiKey: String = ""
    @State var erroredOut: Bool = false
    var body: some View { // the padding in this whole thing makes me :cringeharold:
        if model.personalProfile != nil {
            RefreshableScrollView {
                VStack {
                    HStack {
                        Spacer()
                        Text(model.personalProfile!.username)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.red)
                        if model.personalProfile!.donor {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 20)
                                .foregroundColor(.red)
                        }
                        if model.personalProfile!.warned {
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 20)
                                .foregroundColor(.red)
                        }
                        Spacer()
                    }
                    .padding(.bottom, -5)
                    HStack {
                        Spacer()
                        Text("(\(model.personalProfile!.userClass))")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.top, -5)
                    Divider()
                }
                .padding(.horizontal, 20)
                HStack {
                    Spacer()
                    if let pfp = model.pfp {
                        pfp
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(.top, 10)
                        
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(maxWidth: 50)
                    }
                    Spacer()
                }
                SectionTitle("Statistics") {
                    PersonalStats()
                }
                .padding(10)
                SectionTitle("Percentile Rankings") {
                    PersonalRanks()
                }
                .padding(10)
                SectionTitle("Personal") {
                    PersonalInfo()
                }
                .padding(10)
                SectionTitle("Community") {
                    PersonalCommunity()
                }
                .padding(10)
                Spacer()
            } onRefresh: {
                do {
                    let profile = try await model.api.requestPersonalProfile()
                    model.personalProfile = try await model.api.requestUserProfile(user: profile.id)
                    model.pfp = try await model.api.requestProfilePicture(model.personalProfile!.avatar)
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
            .onAppear { // this is dumb but for some reason when i use `.task(_:)`, it shits itself
                Task {
                    do {
                        let profile = try await model.api.requestPersonalProfile()
                        model.personalProfile = try await model.api.requestUserProfile(user: profile.id)
                        model.pfp = try await model.api.requestProfilePicture(model.personalProfile!.avatar)
                    } catch {
                        erroredOut = true
                    }
                }
            }
        } else if erroredOut {
            RequestError {
                do {
                    let profile = try await model.api.requestPersonalProfile()
                    model.personalProfile = try await model.api.requestUserProfile(user: profile.id)
                    model.pfp = try await model.api.requestProfilePicture(model.personalProfile!.avatar)
                } catch {
                    erroredOut = true
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
