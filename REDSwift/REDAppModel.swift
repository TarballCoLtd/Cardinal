//
//  REDAppModel.swift
//  REDSwift
//
//  Created by Tarball on 12/3/22.
//

import Foundation

class REDAppModel: ObservableObject {
    @Published var api: RedactedAPI?
    @Published var personalProfile: UserProfile?
    @Published var announcements: [Announcement]?
    @Published var notifications: Notifications?
    init(_ apiKey: String) {
        api = RedactedAPI(apiKey)
        personalProfile = nil
        announcements = nil
        notifications = nil
    }
    init() {
        api = nil
        personalProfile = nil
        announcements = nil
        notifications = nil
        #if DEBUG
        api = RedactedAPI("3647f30f.64d21b5659bdc5fed8ee1ebc658b65b6")
        #endif
    }
}
