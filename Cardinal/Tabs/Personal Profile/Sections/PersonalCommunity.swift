//
//  UserCommunity.swift
//  REDSwift
//
//  Created by Tarball on 12/4/22.
//

import SwiftUI

struct PersonalCommunity: View {
    @EnvironmentObject var model: CardinalModel
    var body: some View {
        RectangleOverlay {
            VStack {
                Group { // why the hell is there a limit on how many views there can be in a ViewBuilder closure
                    HStack {
                        Text("Forum posts:")
                        Spacer()
                        Text(String(model.personalProfile!.posts!))
                    }
                    HStack {
                        Text("Group votes:")
                        Spacer()
                        Text(String(model.personalProfile!.groupVotes!))
                    }
                    HStack {
                        Text("Torrent comments:")
                        Spacer()
                        Text(String(model.personalProfile!.comments!))
                    }
                    HStack {
                        Text("Artist comments:")
                        Spacer()
                        Text(String(model.personalProfile!.artistComments!))
                    }
                    HStack {
                        Text("Collage comments:")
                        Spacer()
                        Text(String(model.personalProfile!.collageComments!))
                    }
                    HStack {
                        Text("Request comments:")
                        Spacer()
                        Text(String(model.personalProfile!.requestComments!))
                    }
                    HStack {
                        Text("Collages started:")
                        Spacer()
                        Text(String(model.personalProfile!.collagesStarted!))
                    }
                    HStack {
                        Text("Collages contributed to:")
                        Spacer()
                        Text(String(model.personalProfile!.collagesContrib!))
                    }
                    HStack {
                        Text("Requests filled:")
                        Spacer()
                        Text(String(model.personalProfile!.requestsFilled!))
                    }
                    HStack {
                        Text("Requests voted:")
                        Spacer()
                        Text(String(model.personalProfile!.requestsVoted!))
                    }
                }
                Group {
                    HStack {
                        Text("Uploaded:")
                        Spacer()
                        Text(String(model.personalProfile!.uploadedTorrents!))
                    }
                    HStack {
                        Text("Unique groups:")
                        Spacer()
                        Text(String(model.personalProfile!.uniqueUploadGroups!))
                    }
                    
                    HStack {
                        Text("\"Perfect\" FLACs:")
                        Spacer()
                        Text(String(model.personalProfile!.perfectFlacs!))
                    }
                    HStack {
                        Text("Invited:")
                        Spacer()
                        Text(String(model.personalProfile!.invited!))
                    }
                }
            }
        }
    }
}
