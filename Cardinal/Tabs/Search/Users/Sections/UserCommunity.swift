//
//  UserCommunity.swift
//  REDSwift
//
//  Created by Tarball on 12/6/22.
//

import SwiftUI
import GazelleKit

struct UserCommunity: View {
    @State var profile: UserProfile
    init(_ profile: UserProfile) {
        self._profile = State(initialValue: profile)
    }
    var body: some View {
        RectangleOverlay {
            VStack {
                Group { // why the hell is there a limit on how many views there can be in a ViewBuilder closure
                    if let posts = profile.posts {
                        HStack {
                            Text("Forum posts:")
                            Spacer()
                            Text(String(posts))
                        }
                    }
                    if let groupVotes = profile.groupVotes {
                        HStack {
                            Text("Group votes:")
                            Spacer()
                            Text(String(groupVotes))
                        }
                    }
                    if let comments = profile.comments {
                        HStack {
                            Text("Torrent comments:")
                            Spacer()
                            Text(String(comments))
                        }
                    }
                    if let artistComments = profile.artistComments {
                        HStack {
                            Text("Artist comments:")
                            Spacer()
                            Text(String(artistComments))
                        }
                    }
                    if let collageComments = profile.collageComments {
                        HStack {
                            Text("Collage comments:")
                            Spacer()
                            Text(String(collageComments))
                        }
                    }
                    if let requestComments = profile.requestComments {
                        HStack {
                            Text("Request comments:")
                            Spacer()
                            Text(String(requestComments))
                        }
                    }
                    if let collagesStarted = profile.collagesStarted {
                        HStack {
                            Text("Collages started:")
                            Spacer()
                            Text(String(collagesStarted))
                        }
                    }
                    if let collagesContrib = profile.collagesContrib {
                        HStack {
                            Text("Collages contributed to:")
                            Spacer()
                            Text(String(collagesContrib))
                        }
                    }
                    if let requestsFilled = profile.requestsFilled {
                        HStack {
                            Text("Requests filled:")
                            Spacer()
                            Text(String(requestsFilled))
                        }
                    }
                    if let requestsVoted = profile.requestsVoted {
                        HStack {
                            Text("Requests voted:")
                            Spacer()
                            Text(String(requestsVoted))
                        }
                    }
                }
                Group {
                    if let uploadedTorrents = profile.uploadedTorrents {
                        HStack {
                            Text("Uploaded:")
                            Spacer()
                            Text(String(uploadedTorrents))
                        }
                    }
                    if let uniqueUploadGroups = profile.uniqueUploadGroups {
                        HStack {
                            Text("Unique groups:")
                            Spacer()
                            Text(String(uniqueUploadGroups))
                        }
                    }
                    if let perfectFlacs = profile.perfectFlacs {
                        HStack {
                            Text("\"Perfect\" FLACs:")
                            Spacer()
                            Text(String(perfectFlacs))
                        }
                    }
                    if let invited = profile.invited {
                        HStack {
                            Text("Invited:")
                            Spacer()
                            Text(String(invited))
                        }
                    }
                }
            }
        }
    }
    static func shouldDisplay(_ profile: UserProfile) -> Bool {
        return profile.posts != nil && profile.groupVotes != nil && profile.comments != nil && profile.artistComments != nil && profile.collageComments != nil && profile.requestComments != nil && profile.collagesStarted != nil && profile.collagesContrib != nil && profile.requestsFilled != nil && profile.requestsVoted != nil && profile.uploadedTorrents != nil && profile.uniqueUploadGroups != nil && profile.perfectFlacs != nil && profile.invited != nil
    }
}
