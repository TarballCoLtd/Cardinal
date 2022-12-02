//
//  ContentView.swift
//  REDSwift
//
//  Created by Tarball on 12/2/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button("do shit") {
            Task {
                try! await print(requestUserProfile(user: "57367", apiKey: "3647f30f.64d21b5659bdc5fed8ee1ebc658b65b6").response)
            }
        }
    }
}
