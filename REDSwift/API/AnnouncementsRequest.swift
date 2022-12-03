//
//  AnnouncementsRequest.swift
//  REDSwift
//
//  Created by Tarball on 12/2/22.
//

import Foundation

func requestAnnouncements(perPage: Int, apiKey: String) async throws -> [Announcement] {
    guard let url = URL(string: "https://redacted.ch/ajax.php?action=announcements&perpage=\(perPage)&order_by=title") else { throw RedactedAPIError.urlParseError }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue(apiKey, forHTTPHeaderField: "Authorization")
    let (data, _) = try await URLSession.shared.data(for: request)
    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
    #if DEBUG
    print(data)
    print(json as Any)
    #endif
    let decoder = JSONDecoder()
    let announcements = try decoder.decode(RedactedAnnouncements.self, from: data)
    var ret: [Announcement] = []
    for announcement in announcements.response.announcements {
        ret.append(Announcement(announcement: announcement))
    }
    return ret
}

internal struct RedactedAnnouncements: Codable {
    var status: String
    var response: RedactedAnnouncementsResponse
}

internal struct RedactedAnnouncementsResponse: Codable {
    var announcements: [RedactedAnnouncement]
}

internal struct RedactedAnnouncement: Codable {
    var newsId: Int
    var title: String
    var bbBody: String
    var body: String
    var newsTime: String
}

class Announcement {
    var id: Int
    var title: String
    var bbBody: String
    var body: String
    var time: Date?
    internal init(announcement: RedactedAnnouncement) {
        id = announcement.newsId
        title = announcement.title
        bbBody = announcement.bbBody
        body = announcement.body
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        time = formatter.date(from: announcement.newsTime)
    }
}
