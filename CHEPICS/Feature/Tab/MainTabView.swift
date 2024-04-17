//
//  MainTabView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/19.
//

import SwiftUI
import SwiftUIIntrospect

struct MainTabView: View {
    @StateObject private var viewModel = MainTabViewModel()
    @State private var activeTab: Tab = .feed
    @State private var feedStack: NavigationPath = .init()
    @State private var myPageStack: NavigationPath = .init()
    
    var body: some View {
        VStack(spacing: 0) {
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
            .introspect(.tabView, on: .iOS(.v16, .v17)) { tabView in
                tabView.tabBar.isHidden = true
            }
            
            CustomTabBar()
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
    
    @ViewBuilder
    private func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) {
                TabItem(
                    tab: $0,
                    activeTab: tabSelection)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

struct TabItem: View {
    var tab: Tab
    @Binding var activeTab: Tab
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: activeTab == tab ? tab.selectedImage : tab.unselectedImage)
                .font(.title2)
                .foregroundStyle(activeTab == tab ? .chepicsPrimary : .gray.opacity(0.4))
                .frame(width: 40, height: 40)
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            activeTab = tab
        }
    }
}

#Preview {
    MainTabView()
}

enum Tab: CaseIterable {
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
