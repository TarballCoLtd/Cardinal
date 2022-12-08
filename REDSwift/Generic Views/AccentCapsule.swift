//
//  AccentCapsule.swift
//  REDSwift
//
//  Created by Tarball on 12/7/22.
//

import SwiftUI

struct AccentCapsule: View {
    let gradient = LinearGradient(gradient: Gradient(colors: [.accentColor, .cyan, .accentColor]), startPoint: .leading, endPoint: .trailing)
    @State var text: String
    init(_ text: String) {
        self._text = State(initialValue: text)
    }
    var body: some View {
        Text(text)
            .padding(.vertical, 5)
            .padding(.horizontal, 15)
            .overlay {
                Capsule()
                    .stroke(gradient, lineWidth: 1)
            }
    }
}
