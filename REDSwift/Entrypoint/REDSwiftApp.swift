//
//  REDSwiftApp.swift
//  REDSwift
//
//  Created by Tarball on 12/2/22.
//

import SwiftUI

@main
struct REDSwiftApp: App {
    @StateObject var model = REDAppModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
