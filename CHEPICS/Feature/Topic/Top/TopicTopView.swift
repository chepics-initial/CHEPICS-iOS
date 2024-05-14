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
        .sheet(isPresented: $showSetList, content: {
            NavigationStack {
                EmptyView()
            }
        })
    }
}

#Preview {
    TopicTopView(viewModel: TopicTopViewModel(topic: mockTopic1))
}
