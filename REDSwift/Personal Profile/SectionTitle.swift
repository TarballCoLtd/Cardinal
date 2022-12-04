//
//  SectionTitle.swift
//  REDSwift
//
//  Created by Tarball on 12/3/22.
//

import SwiftUI

struct SectionTitle<Content: View>: View {
    @State var title: String
    var content: Content
    init(_ title: String, content: @escaping () -> Content) {
        self._title = State(initialValue: title)
        self.content = content()
    }
    var body: some View {
        VStack {
            HStack {
                Text(title.uppercased())
                    .font(.caption)
                    .foregroundColor(.gray)
                    .bold()
                Spacer()
            }
            content
        }
    }
}
