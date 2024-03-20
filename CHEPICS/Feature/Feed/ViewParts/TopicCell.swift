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
                
                if let screenSize = window?.screen.bounds, let images = topic.images {
                    imageView(size: screenSize, images: images.map({ $0.url }))
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
    
    @MainActor private func imageView(size: CGRect, images: [String]) -> some View {
        VStack(spacing: 8) {
            if images.count == 1 {
                KFImage(URL(string: images[0]))
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width - 32, height: (size.width - 40) / 2)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            if images.count == 2 {
                HStack(spacing: 8) {
                    KFImage(URL(string: images[0]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: (size.width - 40) / 2, height: (size.width - 40) / 2)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    KFImage(URL(string: images[1]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: (size.width - 40) / 2, height: (size.width - 40) / 2)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            
            if images.count == 3 {
                HStack(spacing: 8) {
                    KFImage(URL(string: images[0]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: (size.width - 40) / 2, height: (size.width - 40) / 2)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    KFImage(URL(string: images[1]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: (size.width - 40) / 2, height: (size.width - 40) / 2)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                KFImage(URL(string: images[2]))
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width - 32, height: (size.width - 40) / 2)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            if images.count == 4 {
                HStack(spacing: 8) {
                    KFImage(URL(string: images[0]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: (size.width - 40) / 2, height: (size.width - 40) / 2)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    KFImage(URL(string: images[1]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: (size.width - 40) / 2, height: (size.width - 40) / 2)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                HStack(spacing: 8) {
                    KFImage(URL(string: images[2]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: (size.width - 32) / 2, height: (size.width - 32) / 2)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    KFImage(URL(string: images[3]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: (size.width - 32) / 2, height: (size.width - 32) / 2)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }
}

#Preview {
    TopicCell(topic: mockTopic1)
}
