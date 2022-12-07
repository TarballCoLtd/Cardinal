//
//  REDAppModel.swift
//  REDSwift
//
//  Created by Tarball on 12/3/22.
//

import Foundation
import SwiftUI
import FloatingTabBar

class REDAppModel: ObservableObject {
    @Published var api: RedactedAPI?
    @Published var personalProfile: UserProfile?
    @Published var announcements: [Announcement]?
    @Published var notifications: Notifications?
    @Published var inbox: Inbox?
    @Published var pfp: Image?
    @Published var conversations: [Int: Conversation] = [:]
    @Published var fetchingConversations: Bool = false
    @Published var fetchingPersonalProfile: Bool = false
    @Published var unreadConversations: Bool = false
    @Published var currentTorrentSearch: TorrentSearchResults?
    @Published var currentArtistSearch: TorrentSearchResults?
    @Published var currentUserSearch: UserSearchResults?
    init(_ apiKey: String) {
        api = RedactedAPI(apiKey)
    }
    init() {
        #if DEBUG
        api = RedactedAPI("3647f30f.64d21b5659bdc5fed8ee1ebc658b65b6")
        #endif
    }
}
