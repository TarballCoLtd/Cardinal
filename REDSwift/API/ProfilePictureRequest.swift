//
//  ProfilePictureRequest.swift
//  REDSwift
//
//  Created by Tarball on 12/4/22.
//

import Foundation
import SwiftUI
import UIKit

extension RedactedAPI {
    public func requestProfilePicture(_ link: String) async throws -> Image? {
        guard let url = URL(string: link) else { throw RedactedAPIError.urlParseError }
        let (data, _) = try await URLSession.shared.data(from: url)
        let image = UIImage(data: data)
        guard let image = image else { return nil }
        return Image(uiImage: image)
    }
}
