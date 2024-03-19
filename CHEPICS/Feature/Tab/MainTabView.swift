//
//  MainTabView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/19.
//

import SwiftUI

struct MainTabView: View {
    @State private var activeTab: Tab = .feed
    @State private var feedStack: NavigationPath = .init()
    @State private var myPageStack: NavigationPath = .init()
    
    var body: some View {
        TabView(selection: tabSelection) {
            NavigationStack(path: $feedStack) {
                FeedView(viewModel: FeedViewModel())
            }
            .tag(Tab.feed)
            .tabItem {
                Image(systemName: activeTab == .feed ? "house.fill" : "house")
            }
            
            NavigationStack(path: $myPageStack) {
                Text("Other page")
            }
            .tag(Tab.myPage)
            .tabItem {
                Image(systemName: activeTab == .myPage ? "person.fill" : "person")
            }
        }
        .tint(Color(.chepicsPrimary))
    }
    
    private var tabSelection: Binding<Tab> {
        return .init {
            return activeTab
        } set: { newValue in
            if newValue == activeTab {
                switch newValue {
                case .feed:
                    if feedStack != .init() {
                        feedStack = .init()
                    } else {
                        // TODO: - すでにrootの場合
                    }
                case .myPage:
                    myPageStack = .init()
                }
            }
            activeTab = newValue
        }

    }
}

#Preview {
    MainTabView()
}

enum Tab {
    case feed
    case myPage
}
