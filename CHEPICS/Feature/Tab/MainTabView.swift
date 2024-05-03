//
//  MainTabView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/19.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var viewModel: MainTabViewModel
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
                Image(activeTab == .feed ? .selectHome : .unselectHome)
            }
            
            NavigationStack(path: $myPageStack) {
                ProfileView(viewModel: ProfileViewModel(userId: viewModel.userId, profileUseCase: DIFactory.profileUseCase(), tokenUseCase: DIFactory.tokenUseCase()))
                    .environmentObject(viewModel)
            }
            .tag(Tab.myPage)
            .tabItem {
                Image(activeTab == .myPage ? .selectPerson : .unselectPerson)
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
                    if feedStack.isEmpty {
                        viewModel.isTappedInFeed = true
                    } else {
                        feedStack = .init()
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
    MainTabView(viewModel: MainTabViewModel(mainTabUseCase: MainTabUseCase_Previews()))
}

enum Tab {
    case feed
    case myPage
    
    var selectedImage: String {
        switch self {
        case .feed:
            "house.fill"
        case .myPage:
            "person.fill"
        }
    }
    
    var unselectedImage: String {
        switch self {
        case .feed:
            "house"
        case .myPage:
            "person"
        }
    }
}
