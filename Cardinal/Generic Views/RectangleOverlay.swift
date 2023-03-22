//
//  RectangleOverlay.swift
//  REDSwift
//
//  Created by Tarball on 12/3/22.
//

import SwiftUI

struct RectangleOverlay<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    var content: Content
    init(content: @escaping () -> Content) {
        self.content = content()
    }
    var body: some View {
        content
            .padding(10)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(colorScheme == .dark ? .white : .black, lineWidth: 2)
            }
    }
}
