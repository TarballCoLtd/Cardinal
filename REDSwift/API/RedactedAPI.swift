//
//  RedactedAPI.swift
//  REDSwift
//
//  Created by Tarball on 12/3/22.
//

import Foundation
import SwiftUI

public class RedactedAPI: ObservableObject {
    @AppStorage("apiKey") var apiKey: String = ""
}

public enum RedactedAPIError: Error {
    case urlParseError
    case requestError
    case networkError
}
