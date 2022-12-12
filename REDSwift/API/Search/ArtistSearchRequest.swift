//
//  ArtistSearchRequest.swift
//  REDSwift
//
//  Created by Tarball on 12/6/22.
//

import Foundation

extension RedactedAPI {
    public func requestArtistSearchResults(term: String, page: Int) async throws -> TorrentSearchResults {
        guard let encodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { throw RedactedAPIError.urlParseError }
        guard let url = URL(string: "https://redacted.ch/ajax.php?action=browse&artistname=\(encodedTerm)&page=\(page)") else { throw RedactedAPIError.urlParseError }
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
}
