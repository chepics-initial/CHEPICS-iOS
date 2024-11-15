//
//  TopicCell.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/19.
//

import SwiftUI

struct TopicCell: View {
    @Environment(\.colorScheme) var colorScheme
    let topic: Topic
    let onTapImage: (Int) -> Void
    let onTapUserInfo: (User) -> Void
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(topic.title)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                            .padding(.vertical, 8)
                        
                        if let link = topic.link {
                            Text(.init("[\(link)](\(link))"))
                                .font(.caption)
                                .tint(.blue)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    
                    Spacer()
                }
                
                if let images = topic.images {
                    GridImagesView(images: images.map({ $0.url }), onTapImage: onTapImage, type: .topic)
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
                        onTapUserInfo(topic.user)
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
            
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    TopicCell(topic: mockTopic1, onTapImage: { _ in }, onTapUserInfo: { _ in })
}
