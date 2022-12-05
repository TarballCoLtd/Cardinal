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
    @AppStorage("house") var house: String?
    @AppStorage("magnifyingglass") var magnifyingGlass: String?
    @AppStorage("envelope") var envelope: String?
    @AppStorage("person") var person: String?
    @State var viewIndex: Int
    @State var items: [BottomBarItem]
    @State var views: [AnyView]
    init() {
        viewIndex = 0
        views = [
            AnyView(Text("test 1")),
            AnyView(Text("test 2")),
            AnyView(Text("test 3")),
            AnyView(PersonalProfileView()),
        ]
        items = [
            BottomBarItem(icon: house ?? "house", color: .iconColor),
            BottomBarItem(icon: magnifyingGlass ?? "magnifyingglass", color: .iconColor),
            BottomBarItem(icon: envelope ?? "envelope", color: .iconColor),
            BottomBarItem(icon: person ?? "person", color: .iconColor),
        ]
    }
    var body: some View {
        ZStack {
            views[viewIndex]
            VStack {
                Spacer()
                BottomBar(selectedIndex: $viewIndex, items: items)
                    .ignoresSafeArea(.all, edges: .bottom)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .frame(maxWidth: 300)
                    .padding(.vertical, 10)
            }
        }
    }
}
