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
                    }
                    .frame(maxWidth: .infinity)
                    .introspect(.textField, on: .iOS(.v16, .v17
                                                    )) { textField in
                        textField.enablesReturnKeyAutomatically = true
                    }
            }, onTapBackButton: {
                dismiss()
            }, onTapDeleteButton: {
                viewModel.onTapDeleteButton()
            })
            
            headerTab
            
            TabView(selection: $viewModel.selectedTab) {
                topicContentView
                    .tag(SearchTabType.topics)
                
                commentContentView
                    .tag(SearchTabType.comments)
                
                userContentView
                    .tag(SearchTabType.users)
            }
            .introspect(.tabView, on: .iOS(.v16, .v17)) { tabView in
                tabView.tabBar.isHidden = true
            }
        }
        .onAppear {
            Task { await viewModel.onAppear() }
        }
        .navigationBarBackButtonHidden()
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
                    topicListView(topics: topics)
                } else {
                    emptyResultView(text: "関連するトピックが見つかりませんでした。")
                }
            case .failure:
                errorMessageView
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
                    commentListView(comments: comments)
                } else {
                    emptyResultView(text: "関連するコメントが見つかりませんでした。")
                }
            case .failure:
                errorMessageView
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
                    userListView(users: users)
                } else {
                    emptyResultView(text: "関連するユーザーが見つかりませんでした。")
                }
            case .failure:
                errorMessageView
            }
        }
    }
    
    private var errorMessageView: some View {
        VStack {
            Text("通信に失敗しました。インターネット環境を確認して、もう一度お試しください。")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(16)
            
            Spacer()
        }
    }
    
    private func emptyResultView(text: String) -> some View {
        VStack {
            Text(text)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(16)
            
            Spacer()
        }
    }
    
    private func topicListView(topics: [Topic]) -> some View {
        ScrollViewReader { reader in
            ScrollView {
                LazyVStack {
                    ForEach(topics) { topic in
                        TopicCell(topic: topic) { index in
                            if let images = topic.images {
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
            .refreshable {
                Task { await viewModel.fetchTopics() }
            }
        }
    }
    
    private func commentListView(comments: [Comment]) -> some View {
        ScrollViewReader { reader in
            ScrollView {
                LazyVStack {
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
    }
    
    private func userListView(users: [User]) -> some View {
        ScrollViewReader { reader in
            ScrollView {
                LazyVStack {
                    ForEach(users) { user in
                        UserCell(user: user)
                    }
                }
            }
        }
    }
}

#Preview {
    ExploreResultView(viewModel: ExploreResultViewModel(searchText: "", exploreResultUseCase: ExploreResultUseCase_Previews()))
}
