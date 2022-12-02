//
//  RedactedAPI.swift
//  REDSwift
//
//  Created by Tarball on 12/2/22.
//

import Foundation

enum RedactedAPIError: Error {
    case urlParseError
    case requestError
    case networkError
}

struct RedactedUserProfile: Codable {
    var status: String
    var response: RedactedUserProfileResponse
}

struct RedactedUserProfileResponse: Codable {
    var username: String
    var avatar: String
    var isFriend: Bool
    var profileText: String
    var bbProfileText: String
    var profileAlbum: RedactedProfileAlbum
    var stats: RedactedUserStats
    var ranks: RedactedUserRanks
    var personal: RedactedUserPersonalInfo
    var community: RedactedUserCommunityInfo
}

struct RedactedProfileAlbum: Codable {
    var id: String
    var name: String
    var review: String
}

struct RedactedUserStats: Codable {
    var joinedDate: String
    var lastAccess: String
    var uploaded: Int64
    var downloaded: Int64
    var ratio: Float
    var requiredRatio: Float
}

struct RedactedUserRanks: Codable {
    var uploaded: Int
    var downloaded: Int
    var uploads: Int
    var requests: Int
    var bounty: Int
    var posts: Int
    var artists: Int
    var overall: Int
}

struct RedactedUserPersonalInfo: Codable {
    // var class: String
    var paranoia: Int
    var paranoiaText: String
    var donor: Bool
    var warned: Bool
    var enabled: Bool
    var passkey: String
}

struct RedactedUserCommunityInfo: Codable {
    var posts: Int
    var torrentComments: Int
    var collagesStarted: Int
    var collagesContrib: Int
    var requestsFilled: Int
    var requestsVoted: Int
    var perfectFlacs: Int
    var uploaded: Int
    var groups: Int
    var seeding: Int
    var leeching: Int
    var snatched: Int
    var invited: Int
}

func requestUserProfile(user: String, apiKey: String) async throws -> RedactedUserProfile {
    guard let url = URL(string: "https://redacted.ch/ajax.php?action=user&id=\(user)") else { throw RedactedAPIError.urlParseError }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue(apiKey, forHTTPHeaderField: "Authorization")
    let (data, _) = try await URLSession.shared.data(for: request)
    let decoder = JSONDecoder()
    print(data.description)
    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
    print(json)
    return try decoder.decode(RedactedUserProfile.self, from: data)
}
