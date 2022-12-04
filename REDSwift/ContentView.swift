//
//  ContentView.swift
//  REDSwift
//
//  Created by Tarball on 12/2/22.
//

import SwiftUI
import FloatingTabBar

struct ContentView: View {
    @EnvironmentObject var model: REDAppModel
    @State var viewIndex: Int = 0
    let items: [BottomBarItem] = [
        BottomBarItem(icon: "house", color: .iconColor),
        BottomBarItem(icon: "magnifyingglass", color: .iconColor),
        BottomBarItem(icon: "bell", color: .iconColor),
        BottomBarItem(icon: "person", color: .iconColor),
    ]
    let views: [AnyView] = [
        AnyView(Text("test 1")),
        AnyView(Text("test 2")),
        AnyView(Text("test 3")),
        AnyView(PersonalProfileView()),
    ]
    var body: some View {
        ZStack {
            views[viewIndex]
            VStack {
                Spacer()
                BottomBar(selectedIndex: $viewIndex, items: items)
                    .ignoresSafeArea(.all, edges: .bottom)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .frame(maxWidth: 200)
                    .padding(.vertical, 10)
            }
        }
    }
}
