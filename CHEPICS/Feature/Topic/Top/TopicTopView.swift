//
//  TopicTopView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/14.
//

import SwiftUI

struct TopicTopView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: TopicTopViewModel
    @State private var showSetList = false
    
    var body: some View {
        VStack {
            switch viewModel.viewStatus {
            case .top:
                topContentView
            case .detail:
                detailContentView
            }
        }
        .onAppear {
            Task { await viewModel.onAppear() }
        }
        .sheet(isPresented: $showSetList, content: {
            NavigationStack {
                TopicSetListView(viewModel: TopicSetListViewModel(topicId: viewModel.topic.id)) { set in
                    Task { await viewModel.selectSet(set: set) }
                }
            }
        })
    }
    
    var topContentView: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("topic")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.chepicsPrimary)
                    
                    Text(viewModel.topic.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                    
                    if let description = viewModel.topic.description {
                        Text(description)
                            .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                    }
                    
                    if let link = viewModel.topic.link {
                        Text(.init("[\(link)](\(link))"))
                            .font(.caption)
                            .tint(.blue)
                    }
                    
                    if let images = viewModel.topic.images {
                        GridImagesView(images: images.map({ $0.url }), onTapImage: { index in
                            mainTabViewModel.images = images.map({ $0.url })
                            mainTabViewModel.pagerState = ImagePagerState(pageCount: images.count, initialIndex: index, pageSize: getRect().size)
                            withAnimation {
                                mainTabViewModel.showImageViewer = true
                            }
                        }, type: .topic)
                    }
                    
                    HStack(spacing: 16) {
                        HStack(spacing: 8) {
                            Image(.orangePeople)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                            
                            Text(viewModel.topic.votes.commaSeparateThreeDigits())
                                .font(.footnote)
                                .foregroundStyle(Color(.chepicsPrimary))
                        }
                        
                        Button {
                            router.items.append(.profile(userId: viewModel.topic.user.id))
                        } label: {
                            UserIconView(url: viewModel.topic.user.profileImageUrl, scale: .topic)
                            
                            Text(viewModel.topic.user.fullname)
                                .font(.caption)
                                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                        }
                        
                        Spacer()
                        
                        Text(viewModel.topic.registerTime.timestampString())
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal, 16)
                
                VStack(spacing: 16) {
                    Divider()
                    
                    Text("set")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                    
                    Text("あなたの意見をセットしてください")
                    
                    Button {
                        showSetList = true
                    } label: {
                        Text("セット一覧を見る")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue)
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(style: StrokeStyle())
                                    .foregroundStyle(.blue)
                            }
                    }
                }
                .padding(.vertical)
            }
        }
    }
    
    var detailContentView: some View {
        VStack(alignment: .leading) {
            ScrollView {
                detailHeaderView
            }
            
            Divider()            
        }
    }
    
    var detailHeaderView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("topic")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.chepicsPrimary)
                .padding(.horizontal, 16)
            
            VStack {
                HStack {
                    Image(.orangePeople)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                    
                    Text("\(viewModel.topic.votes)人が参加中")
                        .font(.footnote)
                        .foregroundStyle(.chepicsPrimary)
                    
                    Spacer()
                }
                
                Text(viewModel.topic.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if let link = viewModel.topic.link {
                    Text(.init("[\(link)](\(link))"))
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                        .tint(.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                if let images = viewModel.topic.images {
                    GridImagesView(images: images.map({ $0.url }), onTapImage: { index in
                        mainTabViewModel.images = images.map({ $0.url })
                        mainTabViewModel.pagerState = ImagePagerState(pageCount: images.count, initialIndex: index, pageSize: getRect().size)
                        withAnimation {
                            mainTabViewModel.showImageViewer = true
                        }
                    }, type: .comment)
                }
                
                HStack(spacing: 16) {
                    Button {
                        router.items.append(.profile(userId: viewModel.topic.user.id))
                    } label: {
                        UserIconView(url: viewModel.topic.user.profileImageUrl, scale: .topic)
                        
                        Text(viewModel.topic.user.fullname)
                            .font(.caption)
                            .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                    }
                    
                    
                    Spacer()
                    
                    Text(viewModel.topic.registerTime.timestampString())
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
                
                HStack(spacing: 4) {
                    Spacer()
                    
                    Text("トピックの詳細を見る")
                        .font(.footnote)
                    
                    Image(systemName: "chevron.forward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 8, height: 8)
                }
                .foregroundStyle(.gray)
            }
            .padding(16)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(style: StrokeStyle())
                    .foregroundStyle(.chepicsPrimary)
            }
            .padding(16)
        }
    }
}

#Preview {
    TopicTopView(viewModel: TopicTopViewModel(topic: mockTopic1, topicTopUseCase: TopicTopUseCase_Previews()))
}
