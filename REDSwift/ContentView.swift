//
//  ContentView.swift
//  REDSwift
//
//  Created by Tarball on 12/2/22.
//

import SwiftUI
import FloatingTabBar

struct ContentView: View {
    @State var viewIndex: Int = 0
    let items: [BottomBarItem] = [
        BottomBarItem(icon: "house", color: .iconColor),
        BottomBarItem(icon: "bell", color: .iconColor),
        BottomBarItem(icon: "magnifyingglass", color: .iconColor),
        BottomBarItem(icon: "person", color: .iconColor),
    ]
    let views: [some View] = [
        Text("test"),
        Text("test 2"),
        Text("test 3"),
        Text("test 4"),
    ]
    var body: some View {
        ZStack {
            views[viewIndex]
            VStack {
                Spacer()
                BottomBar(selectedIndex: $viewIndex, items: items)
                    .cornerRadius(20)
                    .shadow(color: .darkTextColorMain.opacity(0.1), radius: 10, x: 10, y: 5)
                    .padding(.horizontal, 80)
                    .padding(.bottom, -10)
            }
        }
    }
}
