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
                Image(systemName: "house")
            }
            
            NavigationStack(path: $myPageStack) {
                ProfileView(viewModel: ProfileViewModel(profileUseCase: DIFactory.profileUseCase()))
                    .environmentObject(viewModel)
            }
            .tag(Tab.myPage)
            .tabItem {
                Image(systemName: "person")
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
