//
//  ConversationRequest.swift
//  REDSwift
//
//  Created by Tarball on 12/4/22.
//

import Foundation

extension RedactedAPI {
    public func requestConversation(_ id: Int) async throws -> Conversation {
        guard let url = URL(string: "https://redacted.ch/ajax.php?action=inbox&type=viewconv&id=\(id)") else { throw RedactedAPIError.urlParseError }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        #if DEBUG
        print(json as Any)
        #endif
        let decoder = JSONDecoder()
        return try Conversation(conversation: decoder.decode(RedactedConversation.self, from: data), requestJson: json)
    }
    
    internal struct RedactedConversation: Codable {
        var status: String
        var response: RedactedConversationResponse
    }
    
    internal struct RedactedConversationResponse: Codable {
        var convId: Int
        var subject: String
        var sticky: Bool
        var messages: [RedactedConversationMessage]
    }
    
    internal struct RedactedConversationMessage: Codable {
        var messageId: Int
        var senderId: Int
        var senderName: String
        var sentDate: String
        var bbBody: String
        var body: String
    }
}

public class ConversationMessage: Identifiable {
    public let messageId: Int
    public let senderId: Int
    public let senderName: String
    public let sentDate: Date?
    public let bbBody: String
    public let body: String
    public let id = UUID()
    internal init(_ message: RedactedAPI.RedactedConversationMessage) {
        messageId = message.messageId
        senderId = message.senderId
        senderName = message.senderName
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        sentDate = formatter.date(from: message.sentDate)
        bbBody = message.bbBody
        body = message.body
    }
}

public class Conversation {
    public let conversationId: Int
    public let subject: String
    public let sticky: Bool
    public let messages: [ConversationMessage]
    public var profiles: [Int: UserProfile]
    public let successful: Bool
    public let requestJson: [String: Any]?
    internal init(conversation: RedactedAPI.RedactedConversation, requestJson: [String: Any]?) {
        conversationId = conversation.response.convId
        subject = conversation.response.subject
        sticky = conversation.response.sticky
        var messages: [ConversationMessage] = []
        for message in conversation.response.messages {
            messages.append(ConversationMessage(message))
        }
        self.messages = messages
        profiles = [:]
        successful = conversation.status == "success"
        self.requestJson = requestJson
    }
}
