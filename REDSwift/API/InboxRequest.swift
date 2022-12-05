//
//  InboxRequest.swift
//  REDSwift
//
//  Created by Tarball on 12/4/22.
//

import Foundation

extension RedactedAPI {
    public func requestInbox(page: Int, type: Mailbox) async throws -> Inbox {
        guard let url = URL(string: "https://redacted.ch/ajax.php?action=inbox&page=\(page)&type=\(type.description)&sort=unread") else { throw RedactedAPIError.urlParseError }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        #if DEBUG
        print(json as Any)
        #endif
        let decoder = JSONDecoder()
        return try Inbox(inbox: decoder.decode(RedactedInbox.self, from: data), requestJson: json)
    }
    
    public func requestInbox(page: Int, type: Mailbox, search: String, searchType: SearchType) async throws -> Inbox {
        guard let url = URL(string: "https://redacted.ch/ajax.php?action=inbox&page=\(page)&type=\(type.description)&sort=unread&search=\(search)&searchtype=\(searchType.description)") else { throw RedactedAPIError.urlParseError }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        #if DEBUG
        print(json as Any)
        #endif
        let decoder = JSONDecoder()
        return try Inbox(inbox: decoder.decode(RedactedInbox.self, from: data), requestJson: json)
    }
    
    internal struct RedactedInbox: Codable {
        var status: String
        var response: RedactedInboxResponse
    }
    
    internal struct RedactedInboxResponse: Codable {
        var currentPage: Int
        var pages: Int
        var messages: [RedactedInboxMessage]
    }
    
    internal struct RedactedInboxMessage: Codable {
        var convId: Int
        var subject: String
        var unread: Bool
        var sticky: Bool
        var forwardedId: Int
        var forwardedName: String
        var senderId: Int
        var username: String
        var donor: Bool
        var warned: Bool
        var enabled: Bool
        var date: String
    }
}

public enum Mailbox: CustomStringConvertible {
    case inbox
    case outbox
    public var description: String {
        switch self {
        case .inbox: return "inbox"
        case .outbox: return "sentbox"
        }
    }
}

public enum SearchType: CustomStringConvertible {
    case subject
    case message
    case user
    public var description: String {
        switch self {
        case .subject: return "subject"
        case .message: return "message"
        case .user: return "user"
        }
    }
}

public class InboxConversation: Identifiable, ObservableObject {
    public let id = UUID()
    public let conversationId: Int
    public let subject: String
    public let unread: Bool
    public let sticky: Bool
    public let forwardedId: Int
    public let forwardedName: String
    public let senderId: Int
    public let username: String
    public let donor: Bool
    public let warned: Bool
    public let enabled: Bool
    public let date: String
    internal init(_ message: RedactedAPI.RedactedInboxMessage) {
        conversationId = message.convId
        subject = message.subject
        unread = message.unread
        sticky = message.sticky
        forwardedId = message.forwardedId
        forwardedName = message.forwardedName
        senderId = message.senderId
        username = message.username
        donor = message.donor
        warned = message.warned
        enabled = message.enabled
        date = message.date
    }
}
                
public class Inbox {
    public let currentPage: Int
    public let pages: Int
    public let conversations: [InboxConversation]
    public let successful: Bool
    public let requestJson: [String: Any]?
    internal init(inbox: RedactedAPI.RedactedInbox, requestJson: [String: Any]?) {
        currentPage = inbox.response.currentPage
        pages = inbox.response.pages
        successful = inbox.status == "success"
        self.requestJson = requestJson
        
        var conversations: [InboxConversation] = []
        for conversation in inbox.response.messages {
            conversations.append(InboxConversation(conversation))
        }
        self.conversations = conversations
    }
}
