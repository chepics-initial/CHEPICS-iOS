//
//  ExploreResultView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/18.
//

import SwiftUI
import SwiftUIIntrospect

struct ExploreResultView: View {
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    @EnvironmentObject var router: NavigationRouter
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool
    @StateObject var viewModel: ExploreResultViewModel
    private let topicID = "topicID"
    private let commentID = "commentID"
    private let userID = "userID"
    
    var body: some View {
        VStack(spacing: 16) {
            SearchTextField(searchText: $viewModel.searchText, textField: {
                TextField("検索", text: $viewModel.searchText)
                    .focused($isFocused)
                    .submitLabel(.search)
                    .onSubmit {
                        router.items.append(.exploreResult(searchText: viewModel.searchText))
                        viewModel.searchText = viewModel.initialSearchText
                    }
                    .frame(maxWidth: .infinity)
                    .introspect(.textField, on: .iOS(.v16, .v17
                                                    )) { textField in
                        textField.enablesReturnKeyAutomatically = true
                    }
            }, onTapBackButton: {
                if isFocused {
                    viewModel.searchText = viewModel.initialSearchText
                    isFocused = false
                } else {
                    dismiss()
                }
            }, onTapDeleteButton: {
                viewModel.onTapDeleteButton()
            })
            
            if isFocused {
                if !viewModel.searchText.isEmpty {
                    searchView
                }
                
                Spacer()
            } else {
                headerTab
                
                TabView(selection: $viewModel.selectedTab) {
                    topicContentView
                        .tag(SearchTabType.topics)
                    
                    commentContentView
                        .tag(SearchTabType.comments)
                    
                    userContentView
                        .tag(SearchTabType.users)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .introspect(.tabView, on: .iOS(.v16, .v17)) { tabView in
                    tabView.tabBar.isHidden = true
                }
            }
        }
        .modifier(ToastModifier(showToast: $viewModel.showLikeCommentFailureAlert, text: "選択していないセットのコメントにはいいねをすることができません"))
        .modifier(ToastModifier(showToast: $viewModel.showLikeCommentFailureAlert, text: "参加していないトピックの返信にはいいねをすることができません"))
        .onAppear {
            Task { await viewModel.onAppear() }
        }
        .navigationBarBackButtonHidden()
    }
    
    private var searchView: some View {
        VStack {
            Button {
                router.items.append(.exploreResult(searchText: viewModel.searchText))
                viewModel.searchText = viewModel.initialSearchText
            } label: {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.chepicsPrimary)
                    
                    Text(viewModel.searchText)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                    
                    Text("を検索")
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            
            Divider()
        }
    }
    
    private var headerTab: some View {
        HStack(spacing: 0) {
            ForEach(SearchTabType.allCases, id: \.self) { type in
                Button {
                    if viewModel.selectedTab != type {
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
                if let topics = viewModel.topics, !topics.isEmpty {
                    TopicListView(topics: topics, onTapCell: { topic in
                        router.items.append(.topicTop(topic: topic))
                    }, onTapImage: { topic, index in
                        if let images = topic.images {
                            mainTabViewModel.images = images.map({ $0.url })
                            mainTabViewModel.pagerState = ImagePagerState(pageCount: images.count, initialIndex: index, pageSize: getRect().size)
                            withAnimation {
                                mainTabViewModel.showImageViewer = true
                            }
                        }
                    }, onTapUserInfo: { user in
                        router.items.append(.profile(user: user))
                    }, refresh: {
                        Task { await viewModel.fetchTopics() }
                    })
                } else {
                    EmptyResultView(text: "関連するトピックが見つかりませんでした。")
                }
            case .failure:
                ScrollView {
                    ErrorView()
                }
                .refreshable {
                    Task { await viewModel.fetchTopics() }
                }
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
                if let comments = viewModel.comments, !comments.isEmpty {
                    CommentListView(comments: comments, onTapCell: { comment in
                        router.items.append(.comment(comment: comment))
                    }, onTapImage: { comment, index in
                        if let images = comment.images {
                            mainTabViewModel.images = images.map({ $0.url })
                            mainTabViewModel.pagerState = ImagePagerState(pageCount: images.count, initialIndex: index, pageSize: getRect().size)
                            withAnimation {
                                mainTabViewModel.showImageViewer = true
                            }
                        }
                    }, onTapUserInfo: { user in
                        router.items.append(.profile(user: user))
                    }, onTapLikeButton: { comment in
                        Task { await viewModel.onTapLikeButton(comment: comment) }
                    })
                } else {
                    EmptyResultView(text: "関連するコメントが見つかりませんでした。")
                }
            case .failure:
                ScrollView {
                    ErrorView()
                }
                .refreshable {
                    Task { await viewModel.fetchComments() }
                }
            }
        }
    }
    
    private var userContentView: some View {
        VStack {
            switch viewModel.userUIState {
            case .loading:
                LoadingView(showBackgroundColor: false)
                    .frame(maxHeight: .infinity)
            case .success:
                if let users = viewModel.users, !users.isEmpty {
                    UserListView(users: users) { user in
                        router.items.append(.profile(user: user))
                    }
                } else {
                    EmptyResultView(text: "関連するユーザーが見つかりませんでした。")
                }
            case .failure:
                ScrollView {
                    ErrorView()
                }
                .refreshable {
                    Task { await viewModel.fetchUsers() }
                }
            }
        }
    }
}

private struct EmptyResultView: View {
    let text: String
    
    var body: some View {
        VStack {
            Text(text)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(16)
            
            Spacer()
        }
    }
}

private struct TopicListView: View {
    let topics: [Topic]
    let onTapCell: (Topic) -> Void
    let onTapImage: (Topic, Int) -> Void
    let onTapUserInfo: (User) -> Void
    let refresh: () -> Void
    
    var body: some View {
        ScrollViewReader { reader in
            ScrollView {
                LazyVStack {
                    ForEach(topics) { topic in
                        Button {
                            onTapCell(topic)
                        } label: {
                            TopicCell(topic: topic, onTapImage: { index in
                                onTapImage(topic, index)
                            }, onTapUserInfo: { user in
                                onTapUserInfo(user)
                            })
                        }
                    }
                }
            }
            .refreshable {
                refresh()
            }
        }
    }
}

private struct CommentListView: View {
    let comments: [Comment]
    let onTapCell: (Comment) -> Void
    let onTapImage: (Comment, Int) -> Void
    let onTapUserInfo: (User) -> Void
    let onTapLikeButton: (Comment) -> Void
    
    var body: some View {
        ScrollViewReader { reader in
            ScrollView {
                LazyVStack {
                    ForEach(comments) { comment in
                        CommentCell(comment: comment, type: .comment, onTapImage: { index in
                            onTapImage(comment, index)
                        }, onTapUserInfo: { user in
                            onTapUserInfo(user)
                        }, onTapLikeButton: {
                            onTapLikeButton(comment)
                        }, onTapReplyButton: {
                            
                        })
                        .onTapGesture {
                            onTapCell(comment)
                        }
                    }
                }
            }
        }
    }
}

private struct UserListView: View {
    let users: [User]
    let onTapCell: (User) -> Void
    
    var body: some View {
        ScrollViewReader { reader in
            ScrollView {
                LazyVStack {
                    ForEach(users) { user in
                        Button {
                            onTapCell(user)
                        } label: {
                            UserCell(user: user)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ExploreResultView(viewModel: ExploreResultViewModel(searchText: "", exploreResultUseCase: ExploreResultUseCase_Previews()))
}
