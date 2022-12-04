//
//  UserProfileRequest.swift
//  REDSwift
//
//  Created by Tarball on 12/2/22.
//

import Foundation

extension RedactedAPI {
    public func requestUserProfile(user: String) async throws -> UserProfile {
        if let user = Int(user) {
            return try await requestUserProfile(user: user)
        }
        throw RedactedAPIError.requestError
    }
    
    public func requestUserProfile(user: Int) async throws -> UserProfile {
        guard let url = URL(string: "https://redacted.ch/ajax.php?action=user&id=\(user)") else { throw RedactedAPIError.urlParseError }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        #if DEBUG
        print(json as Any)
        #endif
        let decoder = JSONDecoder()
        return try UserProfile(profile: decoder.decode(RedactedUserProfile.self, from: data), id: user, requestJson: json)
    }

    internal struct RedactedUserProfile: Codable {
        var status: String
        var response: RedactedUserProfileResponse
    }

    internal struct RedactedUserProfileResponse: Codable {
        var username: String
        var avatar: String
        var isFriend: Bool
        var profileText: String
        var bbProfileText: String
        //var profileAlbum: RedactedProfileAlbum
        var stats: RedactedUserStats_UserProfile
        var ranks: RedactedUserRanks
        var personal: RedactedUserPersonalInfo
        var community: RedactedUserCommunityInfo
    }

    internal struct RedactedProfileAlbum: Codable {
        var id: String
        var name: String
        var review: String
    }

    internal struct RedactedUserStats_UserProfile: Codable {
        var joinedDate: String
        var lastAccess: String?
        var uploaded: Int?
        var downloaded: Int?
        var ratio: Float?
        var requiredRatio: Float
    }

    internal struct RedactedUserRanks: Codable {
        var uploaded: Int?
        var downloaded: Int?
        var uploads: Int?
        var requests: Int?
        var bounty: Int?
        var posts: Int?
        var artists: Int?
        var overall: Int?
    }

    internal struct RedactedUserPersonalInfo: Codable {
        // var class: String
        var paranoia: Int
        var paranoiaText: String
        var donor: Bool
        var warned: Bool
        var enabled: Bool
        var passkey: String
    }

    internal struct RedactedUserCommunityInfo: Codable {
        var posts: Int?
        var torrentComments: Int?
        var collagesStarted: Int?
        var collagesContrib: Int?
        var requestsFilled: Int?
        var requestsVoted: Int?
        var perfectFlacs: Int?
        var uploaded: Int?
        var groups: Int?
        var seeding: Int?
        var leeching: Int?
        var snatched: Int?
        var invited: Int?
    }

    public enum UserClass {
        case user
        case member
        case powerUser
        case elite
        case torrentMaster
        case powerTorrentMaster
        case eliteTorrentMaster
        case vip
        case staff
        case other
        static func getUserClass(userClass: String) -> Self {
            switch userClass {
            case "User":
                return .user
            case "Member":
                return .member
            case "Power User":
                return .powerUser
            case "Elite":
                return .elite
            case "Torrent Master":
                return .torrentMaster
            case "Power TM":
                return .powerTorrentMaster
            case "Elite TM":
                return .eliteTorrentMaster
            case "VIP":
                return .vip
            case "Forum Moderator":
                return .staff
            case "Moderator":
                return .staff
            case "Administrator":
                return .staff
            default:
                return .other
            }
        }
    }

    public class Profile {
        public let successful: Bool
        public let username: String
        public let id: Int
        public let uploaded: Int?
        public let downloaded: Int?
        public let ratio: Float?
        public let requiredRatio: Float?
        public let userClass: String
        public let requestJson: [String: Any]?
        internal init(_ successful: Bool, _ username: String, _ id: Int, _ uploaded: Int?, _ downloaded: Int?, _ ratio: Float?, _ requiredRatio: Float?, _ userClass: String, _ requestJson: [String: Any]?) {
            self.successful = successful
            self.username = username
            self.id = id
            self.uploaded = uploaded
            self.downloaded = downloaded
            self.ratio = ratio
            self.requiredRatio = requiredRatio
            self.userClass = userClass
            self.requestJson = requestJson
        }
    }

    public class UserProfile: Profile {
        public let avatar: String
        public let isFriend: Bool
        public let profileText: String
        public let bbProfileText: String
        // public let profileAlbum
        public let joinedDate: Date
        public let lastSeen: Date?
        public let uploadedRank: Int?
        public let downloadedRank: Int?
        public let uploadsRank: Int?
        public let requestsRank: Int?
        public let bountyRank: Int?
        public let postsRank: Int?
        public let artistsRank: Int?
        public let overallRank: Int?
        public let paranoia: Int
        public let paranoiaText: String
        public let donor: Bool
        public let warned: Bool
        public let enabled: Bool
        public let posts: Int?
        public let comments: Int?
        public let collagesStarted: Int?
        public let collagesContrib: Int?
        public let requestsFilled: Int?
        public let requestsVoted: Int?
        public let perfectFlacs: Int?
        public let uploadedTorrents: Int?
        public let uniqueUploadGroups: Int?
        public let seeding: Int?
        public let leeching: Int?
        public let snatched: Int?
        public let invited: Int?
        internal init(profile: RedactedUserProfile, id: Int, requestJson: [String: Any]?) { // implement grabbing the user class
            avatar = profile.response.avatar
            isFriend = profile.response.isFriend
            profileText = profile.response.profileText
            bbProfileText = profile.response.bbProfileText
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            joinedDate = formatter.date(from: profile.response.stats.joinedDate)!
            if let lastSeen = profile.response.stats.lastAccess {
                self.lastSeen = formatter.date(from: lastSeen)
            } else {
                self.lastSeen = nil
            }
            uploadedRank = profile.response.ranks.uploaded
            downloadedRank = profile.response.ranks.downloaded
            uploadsRank = profile.response.ranks.uploads
            requestsRank = profile.response.ranks.requests
            bountyRank = profile.response.ranks.bounty
            postsRank = profile.response.ranks.posts
            artistsRank = profile.response.ranks.artists
            overallRank = profile.response.ranks.overall
            paranoia = profile.response.personal.paranoia
            paranoiaText = profile.response.personal.paranoiaText
            donor = profile.response.personal.donor
            warned = profile.response.personal.warned
            enabled = profile.response.personal.enabled
            posts = profile.response.community.posts
            comments = profile.response.community.torrentComments
            collagesStarted = profile.response.community.collagesStarted
            collagesContrib = profile.response.community.collagesContrib
            requestsFilled = profile.response.community.requestsFilled
            requestsVoted = profile.response.community.requestsVoted
            perfectFlacs = profile.response.community.perfectFlacs
            uploadedTorrents = profile.response.community.uploaded
            uniqueUploadGroups = profile.response.community.groups
            seeding = profile.response.community.seeding
            leeching = profile.response.community.leeching
            snatched = profile.response.community.snatched
            invited = profile.response.community.invited
            super.init(profile.status == "success", profile.response.username, id, profile.response.stats.uploaded, profile.response.stats.downloaded, profile.response.stats.ratio, profile.response.stats.requiredRatio, "", requestJson)
        }
    }
}
