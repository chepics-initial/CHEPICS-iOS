//
//  ProfileView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/22.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    @EnvironmentObject var router: NavigationRouter
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: ProfileViewModel
    @State private var showEditView = false
    @State private var isTopicTapped = false
    @State private var isCommentTapped = false
    private let topicID = "topicID"
    private let commentID = "commentID"
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    UserIconView(url: viewModel.user.profileImageUrl, scale: .profile)
                    
                    Spacer()
                    
                    if viewModel.isCurrentUser {
                        Button {
                            showEditView = true
                        } label: {
                            Image(systemName: "pencil")
                                .foregroundStyle(.chepicsPrimary)
                        }
                        
                    } else if let isFollowing = viewModel.isFollowing {
                        Button {
                            Task { await viewModel.onTapFollowButton() }
                        } label: {
                            Text(isFollowing ? "フォロー中" : "フォローする")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(Color(.chepicsPrimary))
                                }
                        }
                        .disabled(!viewModel.isEnabled)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text(viewModel.user.fullname)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                    
                    Text("@\(viewModel.user.username)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                if let bio = viewModel.user.bio {
                    Text(bio)
                        .font(.caption)
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                        .multilineTextAlignment(.leading)
                }
                
                if let following = viewModel.user.following, let followers = viewModel.user.followers {
                    HStack {
                        HStack(spacing: 4) {
                            Text("\(following)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                            Text("フォロー")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        
                        HStack(spacing: 4) {
                            Text("\(followers)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                            Text("フォロワー")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            
            headerTab
            
            TabView(selection: $viewModel.selectedTab) {
                topicContentView
                    .tag(ProfileTabType.topics)
                
                commentContentView
                    .tag(ProfileTabType.comments)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .introspect(.tabView, on: .iOS(.v16, .v17)) { tabView in
                tabView.tabBar.isHidden = true
            }
        }
        .onAppear {
            Task { await viewModel.onAppear() }
        }
        .fullScreenCover(isPresented: $showEditView) {
            NavigationStack {
                EditProfileView(viewModel: EditProfileViewModel(user: viewModel.user))
            }
        }
    }
    
    private var headerTab: some View {
        HStack(spacing: 0) {
            ForEach(ProfileTabType.allCases, id: \.self) { type in
                Button {
                    if viewModel.selectedTab == type {
                        switch type {
                        case .topics:
                            isTopicTapped = true
                        case .comments:
                            isCommentTapped = true
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
                    Text("")
                        .id(topicID)
                    if let topics = viewModel.topics {
                        ForEach(topics) { topic in
                            Button {
                                router.items.append(.topicTop(topic: topic))
                            } label: {
                                TopicCell(topic: topic, onTapImage: { index in
                                    if let images = topic.images {
                                        mainTabViewModel.images = images.map({ $0.url })
                                        mainTabViewModel.pagerState = ImagePagerState(pageCount: images.count, initialIndex: index, pageSize: getRect().size)
                                        withAnimation {
                                            mainTabViewModel.showImageViewer = true
                                        }
                                    }
                                }, onTapUserInfo: { user in
                                    router.items.append(.profile(user: user))
                                })
                            }
                        }
                    }
                }
            }
            .onChange(of: isTopicTapped) { newValue in
                if newValue {
                    withAnimation {
                        reader.scrollTo(topicID)
                        isTopicTapped = false
                    }
                }
            }
        }
    }
    
    private var commentListView: some View {
        ScrollViewReader { reader in
            ScrollView {
                LazyVStack {
                    Text("")
                        .id(commentID)
                    if let comments = viewModel.comments {
                        ForEach(comments) { comment in
                            CommentCell(comment: comment, type: .comment, onTapImage: { index in
                                if let images = comment.images {
                                    mainTabViewModel.images = images.map({ $0.url })
                                    mainTabViewModel.pagerState = ImagePagerState(pageCount: images.count, initialIndex: index, pageSize: getRect().size)
                                    withAnimation {
                                        mainTabViewModel.showImageViewer = true
                                    }
                                }
                            }, onTapUserInfo: { user in
                                router.items.append(.profile(user: user))
                            }, onTapLikeButton: {
                                
                            }, onTapReplyButton: {
                                
                            })
                            .onTapGesture {
                                router.items.append(.comment(comment: comment))
                            }
                        }
                    }
                }
            }
            .onChange(of: isCommentTapped) { newValue in
                if newValue {
                    withAnimation {
                        reader.scrollTo(commentID)
                        isCommentTapped = false
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel(user: mockUser1, profileUseCase: ProfileUseCase_Previews()))
}
