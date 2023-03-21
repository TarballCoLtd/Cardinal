//
//  REDSwiftApp.swift
//  REDSwift
//
//  Created by Tarball on 12/2/22.
//

import SwiftUI

@main
struct CardinalApp: App {
    @StateObject var model = CardinalModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
