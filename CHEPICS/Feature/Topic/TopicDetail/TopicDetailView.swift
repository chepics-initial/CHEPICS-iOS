//
//  TopicDetailView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/19.
//

import SwiftUI

struct TopicDetailView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    @Environment(\.colorScheme) var colorScheme
    let topic: Topic
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(topic.title)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                                .padding(.vertical, 8)
                            
                            if let description = topic.description {
                                Text(description)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            if let link = topic.link {
                                Text(.init("[\(link)](\(link))"))
                                    .font(.caption)
                                    .tint(.blue)
                            }
                        }
                        
                        Spacer()
                    }
                    
                    if let images = topic.images {
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
                            
                            Text(topic.votes.commaSeparateThreeDigits())
                                .font(.footnote)
                                .foregroundStyle(Color(.chepicsPrimary))
                        }
                        
                        Button {
                            router.items.append(.profile(user: topic.user))
                        } label: {
                            UserIconView(url: topic.user.profileImageUrl, scale: .topic)
                            
                            Text(topic.user.fullname)
                                .font(.caption)
                                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                        }

                        
                        Spacer()
                        
                        Text(topic.registerTime.timestampString())
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    TopicDetailView(topic: mockTopic1)
}
