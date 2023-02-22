//
//  REDAppModel.swift
//  REDSwift
//
//  Created by Tarball on 12/3/22.
//

import Foundation
import SwiftUI
import FloatingTabBar
import GazelleKit

class REDAppModel: ObservableObject {
    @AppStorage("apiKey") var apiKey: String = ""
    @Published var api: GazelleAPI?
    @Published var personalProfile: UserProfile?
    @Published var announcements: Announcements?
    @Published var parsedAnnouncements: [Int: String] = [:]
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
    @Published var currentRequestSearch: RequestSearchResults?
    @Published var selectionString: String = "Torrents"
    
    init() {
        if apiKey != "" {
            setAPIKey(apiKey)
        }
    }
    
    func setAPIKey(_ apiKey: String) {
        api = GazelleAPI(apiKey)
    }
}
