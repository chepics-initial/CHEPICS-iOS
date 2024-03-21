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
    @State private var showCreateTopicView = false
    
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
            
            Text("")
                .tabItem {
                    Image(systemName: "plus")
                }
                .tag(Tab.upload)
            
            NavigationStack(path: $myPageStack) {
                Text("Other page")
            }
            .tag(Tab.myPage)
            .tabItem {
                Image(systemName: activeTab == .myPage ? "person.fill" : "person")
            }
        }
        .overlay {
            if viewModel.showImageViewer {
                ImageView()
                    .environmentObject(viewModel)
            }
        }
        .fullScreenCover(isPresented: $showCreateTopicView, onDismiss: {
            tabSelection.wrappedValue = .feed
        }, content: {
            NavigationStack {
                CreateTopicView(viewModel: CreateTopicViewModel())
            }
        })
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
                case .upload:
                    break
                case .myPage:
                    myPageStack = .init()
                }
            }
            
            if newValue == .upload {
                showCreateTopicView = true
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
    case upload
    case myPage
}
