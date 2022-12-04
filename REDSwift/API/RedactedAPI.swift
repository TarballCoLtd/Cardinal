//
//  RedactedAPI.swift
//  REDSwift
//
//  Created by Tarball on 12/3/22.
//

import Foundation
import SwiftUI

public class RedactedAPI: ObservableObject {
    @Published public var apiKey: String
    public init(_ apiKey: String) {
        self.apiKey = apiKey
    }
}

public enum RedactedAPIError: Error {
    case urlParseError
    case requestError
    case networkError
}
