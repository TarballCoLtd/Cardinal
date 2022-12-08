//
//  RequestSearchRequest.swift
//  REDSwift
//
//  Created by Tarball on 12/7/22.
//

import Foundation

extension RedactedAPI {
    public func requestRequestSearchResults(term: String) async throws -> RequestSearchResults {
        guard let encodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { throw RedactedAPIError.urlParseError }
        guard let url = URL(string: "https://redacted.ch/ajax.php?action=requests&search=\(encodedTerm)") else { throw RedactedAPIError.urlParseError }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        #if DEBUG
        print(json as Any)
        #endif
        let decoder = JSONDecoder()
        return try RequestSearchResults(results: decoder.decode(RedactedRequestSearch.self, from: data), requestJson: json, requestSize: data.count)
    }
    
    internal struct RedactedRequestSearch: Codable {
        var status: String
        var response: RedactedRequestSearchResponse
    }
    
    internal struct RedactedRequestSearchResponse: Codable {
        var currentPage: Int?
        var pages: Int?
        var results: [RedactedRequestSearchResult]
    }
    
    internal struct RedactedRequestSearchResult: Codable {
        var requestId: Int
        var requestorId: Int
        var requestorName: String
        var timeAdded: String
        var lastVote: String
        var voteCount: Int
        var bounty: Int
        var categoryId: Int
        var categoryName: String
        var artists: [[RedactedRequestSearchArtist]]
        var title: String
        var year: Int
        var image: String
        var description: String
        var catalogueNumber: String
        var releaseType: String?
        var bitrateList: [String]
        var formatList: [String]
        var mediaList: [String]
        var logCue: String
        var isFilled: Bool
        var fillerId: Int
        var fillerName: String
        var torrentId: Int
        var timeFilled: String
    }
    
    internal struct RedactedRequestSearchArtist: Codable {
        //var id: Int
        var name: String
    }
}

public class Request: Identifiable {
    public let id = UUID()
    public let requestId: Int
    public let requestorId: Int
    public let requestorName: String
    public let timeAdded: Date
    public let lastVote: String
    public let voteCount: Int
    public let bounty: Int
    public let categoryId: Int
    public let categoryName: String
    public let artists: [Artist]
    public let title: String
    public let year: Int
    public let image: String
    public let description: String
    public let catalogueNumber: String
    public let releaseType: String?
    public let bitrateList: [String]
    public let formatList: [String]
    public let mediaList: [String]
    public let logCue: String
    public let isFilled: Bool
    public let fillerId: Int
    public let fillerName: String
    public let torrentId: Int
    public let timeFilled: Date?
    init(_ request: RedactedAPI.RedactedRequestSearchResult) {
        requestId = request.requestId
        requestorId = request.requestorId
        requestorName = request.requestorName
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timeAdded = formatter.date(from: request.timeAdded)!
        lastVote = request.lastVote
        voteCount = request.voteCount
        bounty = request.bounty
        categoryId = request.categoryId
        categoryName = request.categoryName
        var temp: [Artist] = []
        for array in request.artists {
            for artist in array {
                temp.append(Artist(artist))
            }
        }
        artists = temp
        title = request.title
        year = request.year
        image = request.image
        description = request.description
        catalogueNumber = request.catalogueNumber
        releaseType = request.releaseType
        bitrateList = request.bitrateList
        formatList = request.formatList
        mediaList = request.mediaList
        logCue = request.logCue
        isFilled = request.isFilled
        fillerId = request.fillerId
        fillerName = request.fillerName
        torrentId = request.torrentId
        timeFilled = formatter.date(from: request.timeFilled)
    }
}

public class RequestSearchResults {
    public let currentPage: Int?
    public let pages: Int?
    public let requests: [Request]
    public let successful: Bool
    public let requestJson: [String: Any]?
    public let requestSize: Int
    init(results: RedactedAPI.RedactedRequestSearch, requestJson: [String: Any]?, requestSize: Int) {
        currentPage = results.response.currentPage
        pages = results.response.pages
        var temp: [Request] = []
        for request in results.response.results {
            temp.append(Request(request))
        }
        requests = temp
        successful = results.status == "success"
        self.requestJson = requestJson
        self.requestSize = requestSize
    }
}
