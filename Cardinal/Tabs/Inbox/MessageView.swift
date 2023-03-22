//
//  MessageView.swift
//  REDSwift
//
//  Created by Tarball on 12/5/22.
//

import SwiftUI
import GazelleKit

struct MessageView: View {
    let message: ConversationMessage
    @State var html: String?
    init(_ message: ConversationMessage) {
        self.message = message
        self.html = nil
    }
    var body: some View {
        VStack {
            HStack {
                Text(message.senderName)
                    .bold()
                    .foregroundColor(.red)
                Spacer()
            }
            HStack {
                Text(html ?? "")
                    .onAppear { // shits itself for some reason unless i do this bullshit (im going insane)
                        Task {
                            html = message.body.htmlToString()
                        }
                    }
                Spacer()
            }
        }
    }
}

extension String {
    func htmlToString() -> String? {
        return try? NSAttributedString(data: self.data(using: .utf8)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil).string
    }
}
