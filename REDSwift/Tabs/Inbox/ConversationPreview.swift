//
//  MessagePreview.swift
//  REDSwift
//
//  Created by Tarball on 12/4/22.
//

import SwiftUI

struct ConversationPreview: View {
    @StateObject var message: InboxConversation
    init(_ message: InboxConversation) {
        self._message = StateObject(wrappedValue: message)
    }
    var body: some View {
        HStack {
            Circle()
                .foregroundColor(.accentColor.opacity(message.unread ? 1.0 : 0.0))
                .frame(maxWidth: 10)
                .padding(5)
            Text(message.subject)
                .bold()
            Spacer()
        }
    }
}
