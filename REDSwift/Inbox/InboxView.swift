//
//  InboxView.swift
//  REDSwift
//
//  Created by Tarball on 12/4/22.
//

import SwiftUI

struct InboxView: View {
    @EnvironmentObject var model: REDAppModel
    var body: some View {
        if model.inbox != nil {
            NavigationView {
                List {
                    ForEach(model.inbox!.conversations) { conversation in
                        NavigationLink {
                            ConversationView(conversation.conversationId)
                        } label: {
                            ConversationPreview(conversation)
                        }
                    }
                }
                .navigationTitle("Inbox")
                .refreshable {
                    model.inbox = try! await model.api!.requestInbox(page: 1, type: .inbox)
                }
            }
            .onAppear {
                if let conversation = model.inbox!.conversations.first {
                    model.unreadConversations = conversation.unread
                }
            }
        } else if model.api != nil {
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
                    model.inbox = try! await model.api!.requestInbox(page: 1, type: .inbox)
                }
            }
        } else {
            VStack {
                Text("API Key Not Set")
                    .font(.title)
                Text("Your API key can be set in settings.")
            }
        }
    }
}
