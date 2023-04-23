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

class CardinalModel: ObservableObject {
    @AppStorage("apiKey") var redApiKey: String = ""
    @AppStorage("opsApiKey") var opsApiKey: String = ""
    @AppStorage("tracker") var tracker: GazelleTracker = .redacted
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
        if tracker == .redacted && redApiKey != "" {
            setAPIKey(redApiKey)
        } else if tracker == .orpheus && opsApiKey != "" {
            setAPIKey(opsApiKey)
        }
    }
    
    func setAPIKey(_ apiKey: String) {
        api = GazelleAPI(apiKey, tracker: tracker)
    }
    
    func getAPIKey() -> String {
        api?.apiKey ?? ""
    }
}
