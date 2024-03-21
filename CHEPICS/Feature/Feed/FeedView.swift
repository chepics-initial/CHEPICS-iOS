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
    
    var body: some View {
        VStack {
            headerTab
                        
            switch viewModel.topicUIState {
            case .loading:
                LoadingView(showBackgroundColor: false)
                    .frame(maxHeight: .infinity)                
            case .success:
                listView
                
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
            ForEach(TabType.allCases, id: \.self) { type in
                Button {
                    viewModel.selectTab(type: type)
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
    
    private var listView: some View {
        ScrollView {
            LazyVStack {
                switch viewModel.selectedTab {
                case .topics:
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
                case .comments:
                    ForEach(0 ..< 20, id: \.self) { _ in
                        
                    }
                }
            }
        }
        .refreshable {
            Task { await viewModel.fetchTopics() }
        }
    }
}

#Preview {
    FeedView(viewModel: FeedViewModel(feedUseCase: FeedUseCase_Previews()))
}
