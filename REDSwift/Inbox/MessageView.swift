//
//  MessageView.swift
//  REDSwift
//
//  Created by Tarball on 12/4/22.
//

import SwiftUI
import WebKit

struct MessageView: View {
    @State var message: String
    @State var size: CGSize = .zero
    
    init(_ message: String) {
        self._message = State(initialValue: message)
    }
    
    var body: some View {
        HTMLView(message, size: $size)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: size.height, maxHeight: .infinity)
    }
}

struct HTMLView: UIViewRepresentable {
    let content: String
    @Binding var size: CGSize
    private let view = WKWebView()
    var observer: NSKeyValueObservation?
    
    init(_ content: String, size: Binding<CGSize>) {
        self.content = content
        self._size = size
    }
    
    func makeUIView(context: Context) -> WKWebView {
        view.scrollView.isScrollEnabled = false
        view.navigationDelegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(content, baseURL: nil)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: HTMLView
        var observer: NSKeyValueObservation?
        
        init(parent: HTMLView) {
            self.parent = parent
            observer = parent.view.scrollView.observe(\.contentSize, options: [.new], changeHandler: { (object, change) in
                parent.size = change.newValue ?? .zero
            })
        }
    }
}

/*
extension StringProtocol {
    func htmlToAttributedString() throws -> AttributedString {
        try AttributedString(
            NSAttributedString(
                data: Data(utf8),
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        )
    }
}

extension Text {
    init(html: String) {
        do {
            try self.init(html.htmlToAttributedString())
        } catch {
            self.init("Error rendering HTML text. Report bug to developer.")
        }
    }
}
*/
