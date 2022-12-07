//
//  TorrentSearchRequest.swift
//  REDSwift
//
//  Created by Tarball on 12/5/22.
//

import Foundation

extension RedactedAPI {
    public func requestTorrentSearchResults(term: String) async throws -> TorrentSearchResults {
        guard let url = URL(string: "https://redacted.ch/ajax.php?action=browse&searchstr=\(term.replacingOccurrences(of: " ", with: "%20"))") else { throw RedactedAPIError.urlParseError }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        #if DEBUG
        print(json as Any)
        #endif
        let decoder = JSONDecoder()
        return try TorrentSearchResults(results: decoder.decode(RedactedTorrentSearchResults.self, from: data), requestJson: json, requestSize: data.count)
    }
    
    internal struct RedactedTorrentSearchResults: Codable {
        var status: String
        var response: RedactedTorrentSearchResultsResponse
    }
    
    internal struct RedactedTorrentSearchResultsResponse: Codable {
        var currentPage: Int
        var pages: Int
        var results: [RedactedTorrentSearchResultsResponseResults]
    }
    
    internal struct RedactedTorrentSearchResultsResponseResults: Codable {
        var cover: String?
        var groupId: Int
        var groupName: String
        var artist: String?
        var tags: [String]
        var bookmarked: Bool?
        var vanityHouse: Bool?
        var groupYear: Int?
        var releaseType: String?
        var groupTime: String?
        var maxSize: Int?
        var totalSnatched: Int?
        var totalSeeders: Int?
        var totalLeechers: Int?
        var torrents: [RedactedTorrentSearchTorrent]?
    }
    
    internal struct RedactedTorrentSearchTorrent: Codable {
        var torrentId: Int
        var editionId: Int
        var artists: [RedactedTorrentSearchArtist]
        var remastered: Bool
        var remasterYear: Int
        var remasterCatalogueNumber: String
        var remasterTitle: String
        var media: String
        var encoding: String
        var format: String
        var hasLog: Bool
        var logScore: Int
        var hasCue: Bool
        var scene: Bool
        var vanityHouse: Bool
        var fileCount: Int
        var time: String
        var size: Int
        var snatches: Int
        var seeders: Int
        var leechers: Int
        var isFreeleech: Bool
        var isNeutralLeech: Bool
        var isFreeload: Bool
        var isPersonalFreeleech: Bool
        var canUseToken: Bool
    }
    
    internal struct RedactedTorrentSearchArtist: Codable {
        var id: Int
        var name: String
        var aliasid: Int
    }
}

public class TorrentGroup: Identifiable {
    public let id = UUID()
    let cover: String?
    let groupId: Int
    let groupName: String
    let artist: String?
    let tags: [String]
    let bookmarked: Bool?
    let vanityHouse: Bool?
    let groupYear: Int?
    let releaseType: String?
    let groupTime: Date?
    let maxSize: Int?
    let totalSnatched: Int?
    let totalSeeders: Int?
    let totalLeechers: Int?
    let torrents: [Torrent]
    init(_ group: RedactedAPI.RedactedTorrentSearchResultsResponseResults) {
        cover = group.cover
        groupId = group.groupId
        groupName = group.groupName
        artist = group.artist
        tags = group.tags
        bookmarked = group.bookmarked
        vanityHouse = group.vanityHouse
        groupYear = group.groupYear
        releaseType = group.releaseType
        groupTime = Date(timeIntervalSince1970: Double(group.groupTime ?? "0")!)
        maxSize = group.maxSize
        totalSnatched = group.totalSnatched
        totalSeeders = group.totalSeeders
        totalLeechers = group.totalLeechers
        var temp: [Torrent] = []
        if let torrents = group.torrents {
            for torrent in torrents {
                temp.append(Torrent(torrent))
            }
        }
        torrents = temp
    }
}

public class Artist: Identifiable {
    public let id = UUID()
    let artistId: Int
    let name: String
    let aliasId: Int
    init(_ artist: RedactedAPI.RedactedTorrentSearchArtist) {
        artistId = artist.id
        name = artist.name
        aliasId = artist.aliasid
    }
}

public class Torrent: Identifiable {
    public let id = UUID()
    let torrentId: Int
    let editionId: Int
    let artists: [Artist]
    let remastered: Bool
    let remasteredYear: Int
    let remasterCatalogueNumber: String
    let remasterTitle: String
    let media: String
    let encoding: String
    let format: String
    let hasLog: Bool
    let logScore: Int
    let hasCue: Bool
    let scene: Bool
    let vanityHouse: Bool
    let fileCount: Int
    let time: Date
    let size: Int
    let snatches: Int
    let seeders: Int
    let leechers: Int
    let isFreeleech: Bool
    let isNeutralLeech: Bool
    let isFreeload: Bool
    let isPersonalFreeleech: Bool
    let canUseToken: Bool
    init(_ torrent: RedactedAPI.RedactedTorrentSearchTorrent) {
        torrentId = torrent.torrentId
        editionId = torrent.editionId
        var temp: [Artist] = []
        for artist in torrent.artists {
            temp.append(Artist(artist))
        }
        artists = temp
        remastered = torrent.remastered
        remasteredYear = torrent.remasterYear
        remasterCatalogueNumber = torrent.remasterCatalogueNumber
        remasterTitle = torrent.remasterTitle
        media = torrent.media
        encoding = torrent.encoding == "24bit Lossless" ? "24-bit Lossless" : torrent.encoding
        format = torrent.format
        hasLog = torrent.hasLog
        logScore = torrent.logScore
        hasCue = torrent.hasCue
        scene = torrent.scene
        vanityHouse = torrent.vanityHouse
        fileCount = torrent.fileCount
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        time = formatter.date(from: torrent.time)!
        size = torrent.size
        snatches = torrent.snatches
        seeders = torrent.seeders
        leechers = torrent.leechers
        isFreeleech = torrent.isFreeleech
        isNeutralLeech = torrent.isNeutralLeech
        isFreeload = torrent.isFreeload
        isPersonalFreeleech = torrent.isPersonalFreeleech
        canUseToken = torrent.canUseToken
    }
}

public class TorrentSearchResults {
    let currentPage: Int
    let pages: Int
    var groups: [TorrentGroup]
    let requestJson: [String: Any]?
    let requestSize: Int
    let successful: Bool
    init(results: RedactedAPI.RedactedTorrentSearchResults, requestJson: [String: Any]?, requestSize: Int) {
        currentPage = results.response.currentPage
        pages = results.response.pages
        var temp: [TorrentGroup] = []
        for group in results.response.results {
            temp.append(TorrentGroup(group))
        }
        groups = temp
        successful = results.status == "success"
        self.requestJson = requestJson
        self.requestSize = requestSize
    }
}
