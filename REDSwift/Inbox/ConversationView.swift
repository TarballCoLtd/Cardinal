//
//  MessageView.swift
//  REDSwift
//
//  Created by Tarball on 12/4/22.
//

import SwiftUI

struct ConversationView: View {
    @EnvironmentObject var model: REDAppModel
    var conversationId: Int
    init(_ conversationId: Int) {
        self.conversationId = conversationId
    }
    var body: some View {
        if let conversation = model.conversations[conversationId] {
            List {
                SectionTitle("Subject") {
                    HStack {
                        Text(conversation.subject)
                            .bold()
                        Spacer()
                    }
                }
                ForEach(conversation.messages) { message in
                    MessageView(message)
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
                    model.conversations[conversationId] = try! await model.api!.requestConversation(conversationId)
                }
            }
        }
    }
}
