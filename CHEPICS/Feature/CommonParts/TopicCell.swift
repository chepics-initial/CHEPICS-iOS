//
//  TopicCell.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/19.
//

import SwiftUI
import Kingfisher

struct TopicCell: View {
    @Environment(\.colorScheme) var colorScheme
    let window = UIApplication.shared.connectedScenes.first as? UIWindowScene
    let topic: Topic
    let onTapImage: (String) -> Void
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(topic.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                            .padding(.vertical, 8)
                        
                        if let link = topic.link {
                            Text(.init("[\(link)](\(link))"))
                                .font(.caption)
                                .tint(.blue)
                        }
                    }
                    
                    Spacer()
                }
                
                if let images = topic.images {
                    let columns = Array(repeating: GridItem(.flexible()), count: 2)
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                        ForEach(images.map({ $0.url }).indices, id: \.self) { index in
                            GridImagesView(images: images.map({ $0.url }), index: index, onTapImage: onTapImage)
                        }
                    }
                }
                
                HStack(spacing: 16) {
                    HStack(spacing: 0) {
                        Image(.chart)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                        
                        Text(topic.votes.commaSeparateThreeDigits())
                            .font(.footnote)
                            .foregroundStyle(Color(.chepicsPrimary))
                    }
                    
                    if let userImageUrl = topic.user.profileImageUrl {
                        KFImage(URL(string: userImageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                            .clipShape(Circle())
                    }
                    
                    Text(topic.user.fullname)
                        .font(.caption)
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                    
                    Spacer()
                    
                    Text(topic.registerTime.timestampString())
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal, 16)
            
            Divider()
        }
    }
}

#Preview {
    TopicCell(topic: mockTopic1, onTapImage: { _ in })
}
