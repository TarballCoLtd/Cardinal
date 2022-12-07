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
    @State var tabBarItems: [BottomBarItem] = [
        BottomBarItem(icon: "house", color: .iconColor),
        BottomBarItem(icon: "magnifyingglass", color: .iconColor),
        BottomBarItem(icon: "envelope", color: .iconColor),
        BottomBarItem(icon: "person", color: .iconColor),
    ]
    var body: some View {
        ZStack {
            switch viewIndex { // this switch block. that's the joke. (sobbing profusely)
            case 0:
                Text("test 1")
                    .onAppear {
                        tabBarItems[0] = BottomBarItem(icon: "house.fill", color: .iconColor)
                        tabBarItems[1] = BottomBarItem(icon: "magnifyingglass", color: .iconColor)
                        tabBarItems[2] = BottomBarItem(icon: model.unreadConversations ? "envelope.badge" : "envelope", color: .iconColor)
                        tabBarItems[3] = BottomBarItem(icon: "person", color: .iconColor)
                    }
            case 1:
                SearchView() // magnifying glass isn't fillable
                    .onAppear {
                        tabBarItems[0] = BottomBarItem(icon: "house", color: .iconColor)
                        tabBarItems[1] = BottomBarItem(icon: "magnifyingglass", color: .iconColor)
                        tabBarItems[2] = BottomBarItem(icon: model.unreadConversations ? "envelope.badge" : "envelope", color: .iconColor)
                        tabBarItems[3] = BottomBarItem(icon: "person", color: .iconColor)
                    }
            case 2:
                InboxView()
                    .onAppear {
                        tabBarItems[0] = BottomBarItem(icon: "house", color: .iconColor)
                        tabBarItems[1] = BottomBarItem(icon: "magnifyingglass", color: .iconColor)
                        tabBarItems[2] = BottomBarItem(icon: model.unreadConversations ? "envelope.badge.fill" : "envelope.fill", color: .iconColor)
                        tabBarItems[3] = BottomBarItem(icon: "person", color: .iconColor)
                    }
            case 3:
                PersonalProfileView()
                    .onAppear {
                        tabBarItems[0] = BottomBarItem(icon: "house", color: .iconColor)
                        tabBarItems[1] = BottomBarItem(icon: "magnifyingglass", color: .iconColor)
                        tabBarItems[2] = BottomBarItem(icon: model.unreadConversations ? "envelope.badge" : "envelope", color: .iconColor)
                        tabBarItems[3] = BottomBarItem(icon: "person.fill", color: .iconColor)
                    }
            default:
                VStack {
                    Text("You should not be seeing this!")
                        .font(.title)
                    Text("Report this bug to the developer.")
                }
            }
            VStack {
                Spacer()
                BottomBar(selectedIndex: $viewIndex, items: $tabBarItems)
                    .ignoresSafeArea(.all, edges: .bottom)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .frame(maxWidth: 300)
                    .padding(.vertical, 10)
            }
        }
    }
}
