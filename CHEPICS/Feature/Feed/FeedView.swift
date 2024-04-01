//
//  FeedView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/04.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    @StateObject var viewModel: FeedViewModel
    @Environment(\.colorScheme) var colorScheme
    let topID = "topID"
    
    var body: some View {
        VStack {
            headerTab
                        
            switch viewModel.topicUIState {
            case .loading:
                LoadingView(showBackgroundColor: false)
                    .frame(maxHeight: .infinity)                
            case .success:
                TabView(selection: $viewModel.selectedTab) {
                    topicListView
                        .tag(FeedTabType.topics)
                    
                    Text("comments")
                        .tag(FeedTabType.comments)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                Spacer()
            case .failure:
                Text("投稿の取得に失敗しました。インターネット環境を確認して、もう一度お試しください。")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                
                Spacer()
            }
        }
        .onAppear {
            Task { await viewModel.fetchTopics() }
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
                            break
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
    
    private var topicListView: some View {
        ScrollViewReader { reader in
            ScrollView {
                LazyVStack {
                    EmptyView()
                        .id(topID)
                    if let topics = viewModel.topics {
                        ForEach(topics) { topic in
                            TopicCell(topic: topic) { image in
                                if let images = topic.images {
                                    mainTabViewModel.images = images.map({ $0.url })
                                    mainTabViewModel.selectedImage = image
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
                if newValue {
                    withAnimation {
                        reader.scrollTo(topID)
                        mainTabViewModel.isTappedInFeed = false
                    }
                }
            }
            .refreshable {
                Task { await viewModel.fetchTopics() }
            }
        }
    }
}

#Preview {
    FeedView(viewModel: FeedViewModel(feedUseCase: FeedUseCase_Previews()))
}
