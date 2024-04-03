//
//  MainTabView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/19.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = MainTabViewModel()
    @State private var activeTab: Tab = .feed
    @State private var feedStack: NavigationPath = .init()
    @State private var myPageStack: NavigationPath = .init()
    
    var body: some View {
        TabView(selection: tabSelection) {
            NavigationStack(path: $feedStack) {
                FeedView(viewModel: FeedViewModel(feedUseCase: DIFactory.feedUseCase()))
                    .environmentObject(viewModel)
            }
            .tag(Tab.feed)
            .tabItem {
                Image(systemName: activeTab == .feed ? "house.fill" : "house")
            }
            
            NavigationStack(path: $myPageStack) {
                ProfileView(viewModel: ProfileViewModel(profileUseCase: DIFactory.profileUseCase()))
            }
            .tag(Tab.myPage)
            .tabItem {
                Image(systemName: activeTab == .myPage ? "person.fill" : "person")
            }
        }
        .overlay {
            if viewModel.showImageViewer {
                ImageView(onDismiss: {
                    withAnimation {
                        viewModel.showImageViewer = false
                    }
                })
                    .environmentObject(viewModel)
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
                        viewModel.isTappedInFeed = true
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
