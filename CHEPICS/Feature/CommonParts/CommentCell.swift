//
//  CommentCell.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/01.
//

import SwiftUI

enum CommentType {
    case comment
    case detail
    case reply
    case set
    case setDetail
    case topicCommentDetail
}

struct CommentCell: View {
    @Environment(\.colorScheme) var colorScheme
    let comment: Comment
    let type: CommentType
    let onTapImage: (Int) -> Void
    let onTapUserInfo: (User) -> Void
    let onTapLikeButton: () -> Void
    let onTapReplyButton: () -> Void
    let onTapTopicTitle: () -> Void
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 8) {
                UserIconView(url: comment.user.profileImageUrl, scale: .comment)
                    .onTapGesture {
                        onTapUserInfo(comment.user)
                    }
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Button {
                            onTapUserInfo(comment.user)
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
                    case .comment, .detail:
                        Button {
                            onTapTopicTitle()
                        } label: {
                            HStack {
                                RoundedRectangle(cornerRadius: 2)
                                    .frame(width: 4, height: 24)
                                    .foregroundStyle(.chepicsPrimary)
                                
                                Text(comment.topic)
                                    .font(.system(size: 16, weight: .semibold))
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(.chepicsPrimary)
                            }
                        }

                    case .reply, .set, .setDetail, .topicCommentDetail:
                        EmptyView()
                    }
                    
                    if let replyFor = comment.replyFor?.first, type == .reply {
                        HStack {
                            Image(systemName: "arrowshape.turn.up.left.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                            
                            Text(replyFor.fullname)
                                .font(.footnote)
                        }
                        .foregroundStyle(.chepicsPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
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
                        if let replyCount = comment.replyCount {
                            switch type {
                            case .comment, .reply, .set:
                                if replyCount == 1 {
                                    Text("1 reply")
                                        .foregroundStyle(.chepicsPrimary)
                                } else if replyCount > 1 {
                                    Text("\(replyCount) replies")
                                        .foregroundStyle(.chepicsPrimary)
                                }
                            case .detail, .setDetail, .topicCommentDetail:
                                EmptyView()
                            }
                        }
                        Spacer()
                        
                        switch type {
                        case .comment, .set, .setDetail:
                            EmptyView()
                        case .detail, .reply, .topicCommentDetail:
                            Button {
                                onTapReplyButton()
                            } label: {
                                Image(systemName: "bubble.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(.gray)
                            }
                            .padding(.trailing, 8)
                        }
                        
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
    CommentCell(comment: mockComment2, type: .comment, onTapImage: { _ in }, onTapUserInfo: { _ in }, onTapLikeButton: {}, onTapReplyButton: {}, onTapTopicTitle: {})
}
