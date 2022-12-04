//
//  PersonalProfileRequest.swift
//  REDSwift
//
//  Created by Tarball on 12/2/22.
//

import Foundation

extension RedactedAPI {
    public func requestPersonalProfile() async throws -> PersonalProfile {
        guard let url = URL(string: "https://redacted.ch/ajax.php?action=index") else { throw RedactedAPIError.urlParseError }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        #if DEBUG
        print(json as Any)
        #endif
        let decoder = JSONDecoder()
        return try PersonalProfile(profile: decoder.decode(RedactedPersonalProfile.self, from: data), requestJson: json)
    }

    internal struct RedactedPersonalProfile: Codable {
        var status: String
        var response: RedactedPersonalProfileResponse
    }

    internal struct RedactedPersonalProfileResponse: Codable {
        var username: String
        var id: Int
        var authkey: String
        var passkey: String
        var api_version: String
        var notifications: RedactedNotifications_PersonalProfile
        var userstats: RedactedUserStats_PersonalProfile
    }

    internal struct RedactedUserStats_PersonalProfile: Codable {
        var uploaded: Int
        var downloaded: Int
        var ratio: Float
        var requiredratio: Float
        var `class`: String
    }

    internal struct RedactedNotifications_PersonalProfile: Codable {
        var messages: Int
        var notifications: Int
        var newAnnouncement: Bool
        var newBlog: Bool
        var newSubscriptions: Bool // TODO: add this to redacted wiki once promoted to elite
    }
}

public class PersonalProfile: Profile {
    public let authKey: String
    public let passkey: String
    public let apiVersion: String
    public let messages: Int
    public let notifications: Int
    public let newAnnouncement: Bool
    public let newBlog: Bool
    public let newSubscriptions: Bool
    internal init(profile: RedactedAPI.RedactedPersonalProfile, requestJson: [String: Any]?) {
        authKey = profile.response.authkey
        passkey = profile.response.passkey
        apiVersion = profile.response.api_version
        messages = profile.response.notifications.messages
        notifications = profile.response.notifications.notifications
        newAnnouncement = profile.response.notifications.newAnnouncement
        newBlog = profile.response.notifications.newBlog
        newSubscriptions = profile.response.notifications.newSubscriptions
        super.init(profile.status == "success", profile.response.username, profile.response.id, profile.response.userstats.uploaded, profile.response.userstats.downloaded, profile.response.userstats.ratio, profile.response.userstats.requiredratio, profile.response.userstats.class, requestJson)
    }
}
