//
//  UserSearchRequest.swift
//  REDSwift
//
//  Created by Tarball on 12/6/22.
//

import Foundation

extension RedactedAPI {
    public func requestUserSearchResults(term: String, page: Int) async throws -> UserSearchResults {
        guard let encodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { throw RedactedAPIError.urlParseError }
        guard let url = URL(string: "https://redacted.ch/ajax.php?action=usersearch&search=\(encodedTerm)&page=\(page)") else { throw RedactedAPIError.urlParseError }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        #if DEBUG
        print(json as Any)
        #endif
        let decoder = JSONDecoder()
        return try UserSearchResults(results: decoder.decode(RedactedUserSearch.self, from: data), requestJson: json, requestSize: data.count)
    }
    
    internal struct RedactedUserSearch: Codable {
        var status: String
        var response: RedactedUserSearchResponse
    }
    
    internal struct RedactedUserSearchResponse: Codable {
        var currentPage: Int?
        var pages: Int?
        var results: [RedactedUserSearchResult]
    }
    
    internal struct RedactedUserSearchResult: Codable {
        var userId: Int
        var username: String
        var donor: Bool
        var warned: Bool
        var enabled: Bool
        var `class`: String
    }
}

public class UserSearchResult: Identifiable {
    public let id = UUID()
    let userId: Int
    let username: String
    let donor: Bool?
    let warned: Bool?
    let enabled: Bool
    let `class`: String
    init(_ result: RedactedAPI.RedactedUserSearchResult) {
        userId = result.userId
        username = result.username
        donor = result.donor
        warned = result.warned
        enabled = result.enabled
        `class` = result.class
    }
}

public class UserSearchResults {
    let currentPage: Int?
    let pages: Int?
    var results: [UserSearchResult]
    let successful: Bool
    let requestJson: [String: Any]?
    let requestSize: Int
    init(results: RedactedAPI.RedactedUserSearch, requestJson: [String: Any]?, requestSize: Int) {
        currentPage = results.response.currentPage
        pages = results.response.pages
        var temp: [UserSearchResult] = []
        for result in results.response.results {
            temp.append(UserSearchResult(result))
        }
        self.results = temp
        successful = results.status == "success"
        self.requestJson = requestJson
        self.requestSize = requestSize
    }
}
