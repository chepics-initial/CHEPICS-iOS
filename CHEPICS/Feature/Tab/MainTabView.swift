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
    @StateObject private var feedRouter = NavigationRouter()
    @State private var myPageStack: NavigationPath = .init()
    
    var body: some View {
        TabView(selection: tabSelection) {
            NavigationStack(path: $feedRouter.items) {
                FeedView(viewModel: FeedViewModel(feedUseCase: DIFactory.feedUseCase()))
                    .environmentObject(viewModel)
            }
            .tag(Tab.feed)
            .tabItem {
                Image(activeTab == .feed ? .selectHome : .unselectHome)
            }
            .environmentObject(feedRouter)
            
            NavigationStack(path: $myPageStack) {
                MyPageTopView(viewModel: MyPageTopViewModel(myPageTopUseCase: DIFactory.myPageTopUseCase()))
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
                    if feedRouter.items.isEmpty {
                        viewModel.isTappedInFeed = true
                    } else {
                        feedRouter.items.removeAll()
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

@MainActor final class NavigationRouter: ObservableObject {
  @Published var items: [Item] = []
  
  enum Item: Hashable {
    case exploreTop
    case exploreResult(searchText: String)
    case profile(userId: String)
  }
}
