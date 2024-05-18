//
//  CommentCell.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/01.
//

import SwiftUI
import Kingfisher

enum CommentType {
    case comment
    case detail
    case reply
    case set
}

struct CommentCell: View {
    @Environment(\.colorScheme) var colorScheme
    let comment: Comment
    let type: CommentType
    let onTapImage: (Int) -> Void
    let onTapUserInfo: (String) -> Void
    let onTapLikeButton: () -> Void
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 8) {
                UserIconView(url: comment.user.profileImageUrl, scale: .comment)
                    .onTapGesture {
                        onTapUserInfo(comment.user.id)
                    }
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Button {
                            onTapUserInfo(comment.user.id)
                        } label: {
                            HStack {
                                Text(comment.user.fullname)
                                    .font(.headline)
                                    .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                                
                                Text("@\(comment.user.username)")
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                            }
                        }

                        
                        Spacer()
                        
                        Text(comment.registerTime.timestampString())
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                    
                    switch type {
                    case .comment:
                        HStack {
                            RoundedRectangle(cornerRadius: 2)
                                .frame(width: 4, height: 24)
                                .foregroundStyle(.chepicsPrimary)
                            
                            Text("猫が可愛い")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.chepicsPrimary)
                        }
                    case .detail, .reply, .set:
                        EmptyView()
                    }
                    
                    Text(comment.comment)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                    
                    if let link = comment.link {
                        Text(.init("[\(link)](\(link))"))
                            .font(.caption)
                            .tint(.blue)
                    }
                    
                    if let images = comment.images {
                        GridImagesView(images: images.map({ $0.url }), onTapImage: onTapImage, type: .comment)
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            onTapLikeButton()
                        } label: {
                            Image(systemName: comment.isLiked ? "heart.fill" : "heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(comment.isLiked ? .red : Color.getDefaultColor(for: colorScheme))
                        }

                        
                        Text("\(comment.votes)")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .padding(16)
            
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .foregroundStyle(.gray)
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    CommentCell(comment: mockComment2, type: .comment, onTapImage: { _ in }, onTapUserInfo: { _ in }, onTapLikeButton: {})
}
