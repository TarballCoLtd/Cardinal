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
    @State var color: Color
    @State var shouldUppercase: Bool
    init(_ title: String, content: @escaping () -> Content) {
        self._title = State(initialValue: title)
        self.content = content()
        self._color = State(initialValue: .gray)
        self._shouldUppercase = State(initialValue: true)
    }
    init(_ title: String, _ color: Color, shouldUppercase: Bool, content: @escaping () -> Content) {
        self._title = State(initialValue: title)
        self.content = content()
        self._color = State(initialValue: color)
        self._shouldUppercase = State(initialValue: shouldUppercase)
    }
    var body: some View {
        VStack {
            HStack {
                Text(shouldUppercase ? title.uppercased() : title)
                    .font(.caption)
                    .foregroundColor(color)
                    .bold()
                Spacer()
            }
            content
        }
    }
}
