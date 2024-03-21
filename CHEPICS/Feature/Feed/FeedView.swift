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
                        
            listView
            
            Spacer()
        }
        .onAppear {
            Task { await viewModel.onAppear() }
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
    }
}

#Preview {
    FeedView(viewModel: FeedViewModel(feedUseCase: FeedUseCase_Previews()))
}
