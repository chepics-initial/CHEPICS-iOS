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
    @StateObject private var myPageRouter = NavigationRouter()
    
    var body: some View {
        TabView(selection: tabSelection) {
            NavigationStack(path: $feedRouter.items) {
                FeedView(viewModel: FeedViewModel(feedUseCase: DIFactory.feedUseCase()))
            }
            .tag(Tab.feed)
            .tabItem {
                Image(activeTab == .feed ? .selectHome : .unselectHome)
            }
            .environmentObject(viewModel)
            .environmentObject(feedRouter)
            
            NavigationStack(path: $myPageRouter.items) {
                MyPageTopView(viewModel: MyPageTopViewModel(myPageTopUseCase: DIFactory.myPageTopUseCase()))
            }
            .tag(Tab.myPage)
            .tabItem {
                Image(activeTab == .myPage ? .selectPerson : .unselectPerson)
            }
            .environmentObject(viewModel)
            .environmentObject(myPageRouter)
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
                    myPageRouter.items.removeAll()
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
        var identifier: UUID {
            return UUID()
        }
        
        public func hash(into hasher: inout Hasher) {
            return hasher.combine(identifier)
        }
        
        public static func == (lhs: Item, rhs: Item) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        
        case exploreTop
        case exploreResult(searchText: String)
        case profile(user: User)
        case myPageTopicList
        case comment(commentId: String, comment: Comment?)
        case topicTop(topic: Topic)
        case topicDetail(topic: Topic)
    }
}
