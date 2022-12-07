//
//  NotificationsRequest.swift
//  REDSwift
//
//  Created by Tarball on 12/3/22.
//

import Foundation

extension RedactedAPI {
    public func requestNotifications(page: Int) async throws -> Notifications {
        guard let url = URL(string: "https://redacted.ch/ajax.php?action=notifications&page=\(page)") else { throw RedactedAPIError.urlParseError }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        #if DEBUG
        print(json as Any)
        #endif
        let decoder = JSONDecoder()
        return try Notifications(notifications: decoder.decode(RedactedNotifications_Notifications.self, from: data), requestJson: json)
    }
    
    internal struct RedactedNotifications_Notifications: Codable {
        var status: String
        var response: RedactedNotificationsResponse
    }
    
    internal struct RedactedNotificationsResponse: Codable {
        var currentPages: Int
        var pages: Int
        var numNew: Int
        var results: [RedactedAPI.RedactedNotification]
    }
    
    internal struct RedactedNotification: Codable {
        var torrentId: Int
        var groupId: Int
        var groupName: String
        var groupCategoryId: Int
        var torrentTags: String
        var size: Int
        var fileCount: Int
        var format: String
        var encoding: String
        var media: String
        var scene: Bool
        var groupYear: Int
        var remasterYear: Int
        var remasterTitle: String
        var snatched: Int
        var seeders: Int
        var leechers: Int
        var notificationTime: String
        var hasLog: Bool
        var hasCue: Bool
        var logScore: Int
        var freeTorrent: Bool
        var isNeutralleech: Bool
        var isFreeload: Bool
        var logInDb: Bool
        var unread: Bool
    }
}

public class Notifications {
    let successful: Bool
    let currentPage: Int
    let pages: Int
    let newNotifications: Int
    let notifications: [RedactedNotification]
    internal init(notifications: RedactedAPI.RedactedNotifications_Notifications, requestJson: [String: Any]?) {
        successful = notifications.status == "success"
        currentPage = notifications.response.currentPages
        pages = notifications.response.pages
        newNotifications = notifications.response.numNew
        var temp: [RedactedNotification] = []
        for notification in notifications.response.results {
            temp.append(RedactedNotification(notification))
        }
        self.notifications = temp
    }
}

public class RedactedNotification {
    let torrentId: Int
    let groupId: Int
    let groupName: String
    let groupCategoryId: Int
    let torrentTags: String
    let size: Int
    let fileCount: Int
    let format: String
    let encoding: String
    let media: String
    let scene: Bool
    let groupYear: Int
    let remasterYear: Int
    let remasterTitle: String
    let snatched: Int
    let seeders: Int
    let leechers: Int
    let notificationTime: String
    let hasLog: Bool
    let hasCue: Bool
    let logScore: Int
    let freeTorrent: Bool
    let isNeutralLeech: Bool
    let isFreeload: Bool
    let logInDb: Bool
    let unread: Bool
    internal init(_ notification: RedactedAPI.RedactedNotification) {
        torrentId = notification.torrentId
        groupId = notification.groupId
        groupName = notification.groupName
        groupCategoryId = notification.groupCategoryId
        torrentTags = notification.torrentTags
        size = notification.size
        fileCount = notification.fileCount
        format = notification.format
        encoding = notification.format
        media = notification.media
        scene = notification.scene
        groupYear = notification.groupYear
        remasterYear = notification.remasterYear
        remasterTitle = notification.remasterTitle
        snatched = notification.snatched
        seeders = notification.seeders
        leechers = notification.leechers
        notificationTime = notification.notificationTime
        hasLog = notification.hasLog
        hasCue = notification.hasCue
        logScore = notification.logScore
        freeTorrent = notification.freeTorrent
        isNeutralLeech = notification.isNeutralleech
        isFreeload = notification.isFreeload
        logInDb = notification.logInDb
        unread = notification.unread
    }
}
