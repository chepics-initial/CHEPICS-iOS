//
//  ProfileView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/22.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: ProfileViewModel
    @State private var isTopicTapped = false
    @State private var isCommentTapped = false
    private let topicID = "topicID"
    private let commentID = "commentID"
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        KFImage(URL(string: mockTopicImage1.url))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("フォローする")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(Color(.chepicsPrimary))
                                }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("太郎")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                        
                        Text("@aabbcc")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    
                    Text("動物に関するトピックを投稿しています\nよろしく")
                        .font(.caption)
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        HStack(spacing: 4) {
                            Text("20")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                            Text("フォロー")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        
                        HStack(spacing: 4) {
                            Text("20")
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
                .padding(.horizontal)
                
                headerTab
                
                TabView(selection: $viewModel.selectedTab) {
                    topicContentView
                        .tag(ProfileTabType.topics)
                    
                    commentContentView
                        .tag(ProfileTabType.comments)
                }
                .introspect(.tabView, on: .iOS(.v16, .v17)) { tabView in
                    tabView.tabBar.isHidden = true
                }
            }
        }
        .onAppear {
            // TODO: - 何を呼び出すかは通信が確定次第変更
            Task {
                switch viewModel.selectedTab {
                case .topics:
                    await viewModel.fetchTopics()
                case .comments:
                    await viewModel.fetchComments()
                }
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
                        viewModel.selectTab(type: type)
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
    ProfileView(viewModel: ProfileViewModel(profileUseCase: ProfileUseCase_Previews()))
}
