//
//  MessageView.swift
//  REDSwift
//
//  Created by Tarball on 12/4/22.
//

import SwiftUI

struct ConversationView: View {
    @EnvironmentObject var model: CardinalModel
    @State var erroredOut: Bool = false
    var conversationId: Int
    init(_ conversationId: Int) {
        self.conversationId = conversationId
    }
    var body: some View {
        if let conversation = model.conversations[conversationId] {
            List {
                SectionTitle("Subject") {
                    HStack {
                        Text(conversation.subject.replacingOccurrences())
                            .bold()
                        Spacer()
                    }
                }
                ForEach(conversation.messages) { message in
                    MessageView(message)
                }
            }
            .refreshable {
                do {
                    model.conversations[conversationId] = try await model.api!.requestConversation(conversationId)
                } catch {
                    erroredOut = true
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Conversation")
                }
            }
        } else if erroredOut {
            RequestError {
                do {
                    model.conversations[conversationId] = try await model.api!.requestConversation(conversationId)
                } catch {
                    erroredOut = true
                }
            }
        } else {
            VStack {
                Spacer()
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.horizontal, 2)
                    Text("Loading...")
                }
                Spacer()
            }
            .onAppear { // this is dumb but for some reason when i use `.task(_:)`, it shits itself
                Task {
                    do {
                        model.conversations[conversationId] = try await model.api!.requestConversation(conversationId)
                    } catch {
                        erroredOut = true
                    }
                }
            }
        }
    }
}

extension String {
    func replacingOccurrences() -> String {
        return replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#39;", with: "'")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&amp;", with: "&")
    }
}
