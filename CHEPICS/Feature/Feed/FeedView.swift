//
//  FeedView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/04.
//

import SwiftUI
import SwiftUIIntrospect

struct FeedView: View {
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    @EnvironmentObject var feedRouter: NavigationRouter
    @StateObject var viewModel: FeedViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showCreateTopicView = false
    private let topicID = "topicID"
    private let commentID = "commentID"
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                headerTab
                
                TabView(selection: $viewModel.selectedTab) {
                    topicContentView
                        .tag(FeedTabType.topics)
                    
                    commentContentView
                        .tag(FeedTabType.comments)
                }
                .introspect(.tabView, on: .iOS(.v16, .v17)) { tabView in
                    tabView.tabBar.isHidden = true
                }
            }
            
            Button(action: {
                showCreateTopicView = true
            }, label: {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(Circle())
            })
            .padding(.bottom, 16)
            .padding(.trailing, 16)
        }
        .onAppear {
            Task {
                switch viewModel.selectedTab {
                case .topics:
                    await viewModel.fetchTopics()
                case .comments:
                    await viewModel.fetchComments()
                }
            }
        }
        .onDisappear {
            viewModel.onDisappear()
        }
        .fullScreenCover(isPresented: $showCreateTopicView, content: {
            NavigationStack {
                CreateTopicView(viewModel: CreateTopicViewModel(createTopicUseCase: DIFactory.createTopicUseCase()))
            }
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    feedRouter.items.append(.exploreTop)
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.gray)
                        .padding(8)
                        .background {
                            Circle()
                                .foregroundStyle(Color(uiColor: .lightGray).opacity(0.5))
                        }
                })
            }
        }
        .navigationDestination(for: NavigationRouter.Item.self) { value in
            switch value {
            case .exploreTop:
                ExploreTopView(viewModel: ExploreTopViewModel())
            case .exploreResult(searchText: let searchText):
                ExploreResultView(viewModel: ExploreResultViewModel(searchText: searchText, exploreResultUseCase: DIFactory.exploreResultUseCase()))
                    .environmentObject(mainTabViewModel)
            case .profile(userId: let userId):
                ProfileView(viewModel: ProfileViewModel(userId: userId, profileUseCase: DIFactory.profileUseCase()))
            }
        }
    }
    
    private var headerTab: some View {
        HStack(spacing: 0) {
            ForEach(FeedTabType.allCases, id: \.self) { type in
                Button {
                    if viewModel.selectedTab == type {
                        switch viewModel.selectedTab {
                        case .topics:
                            if viewModel.topicUIState != .success {
                                Task { await viewModel.fetchTopics() }
                            } else {
                                mainTabViewModel.isTappedInFeed = true
                            }
                        case .comments:
                            if viewModel.commentUIState != .success {
                                Task { await viewModel.fetchComments() }
                            } else {
                                mainTabViewModel.isTappedInFeed = true
                            }
                        }
                    } else {
                        withAnimation {
                            viewModel.selectTab(type: type)
                        }
                    }
                } label: {
                    VStack {
                        Text(type.title)
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Rectangle()
                            .frame(height: 2)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(viewModel.selectedTab == type ? Color.getDefaultColor(for: colorScheme) : .gray)
                }
                
            }
        }
    }
    
    private var topicContentView: some View {
        VStack {
            switch viewModel.topicUIState {
            case .loading:
                LoadingView(showBackgroundColor: false)
                    .frame(maxHeight: .infinity)
            case .success:
                topicListView
            case .failure:
                Text("投稿の取得に失敗しました。インターネット環境を確認して、もう一度お試しください。")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                
                Spacer()
            }
        }
    }
    
    private var commentContentView: some View {
        VStack {
            switch viewModel.commentUIState {
            case .loading:
                LoadingView(showBackgroundColor: false)
                    .frame(maxHeight: .infinity)
            case .success:
                commentListView
            case .failure:
                Text("投稿の取得に失敗しました。インターネット環境を確認して、もう一度お試しください。")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                
                Spacer()
            }
        }
    }
    
    private var topicListView: some View {
        ScrollViewReader { reader in
            ScrollView {
                LazyVStack {
                    EmptyView()
                        .id(topicID)
                    if let topics = viewModel.topics {
                        ForEach(topics) { topic in
                            TopicCell(topic: topic, onTapImage: { index in
                                if let images = topic.images {
                                    mainTabViewModel.images = images.map({ $0.url })
                                    mainTabViewModel.pagerState = ImagePagerState(pageCount: images.count, initialIndex: index, pageSize: getRect().size)
                                    withAnimation {
                                        mainTabViewModel.showImageViewer = true
                                    }
                                }
                            }, onTapUserInfo: { id in
                                feedRouter.items.append(.profile(userId: id))
                            })
                        }
                    }
                }
            }
            .onChange(of: mainTabViewModel.isTappedInFeed) { newValue in
                if newValue && viewModel.selectedTab == .topics {
                    withAnimation {
                        reader.scrollTo(topicID)
                        mainTabViewModel.isTappedInFeed = false
                    }
                }
            }
            .refreshable {
                Task { await viewModel.fetchTopics() }
            }
        }
    }
    
    private var commentListView: some View {
        ScrollViewReader { reader in
            ScrollView {
                LazyVStack {
                    EmptyView()
                        .id(commentID)
                    
                    if let comments = viewModel.comments {
                        ForEach(comments) { comment in
                            CommentCell(comment: comment) { index in
                                if let images = comment.images {
                                    mainTabViewModel.images = images.map({ $0.url })
                                    mainTabViewModel.pagerState = ImagePagerState(pageCount: images.count, initialIndex: index, pageSize: getRect().size)
                                    withAnimation {
                                        mainTabViewModel.showImageViewer = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .onChange(of: mainTabViewModel.isTappedInFeed) { newValue in
                if newValue && viewModel.selectedTab == .comments {
                    withAnimation {
                        reader.scrollTo(commentID)
                        mainTabViewModel.isTappedInFeed = false
                    }
                }
            }
            .refreshable {
                Task { await viewModel.fetchComments() }
            }
        }
    }
}

#Preview {
    FeedView(viewModel: FeedViewModel(feedUseCase: FeedUseCase_Previews()))
}
