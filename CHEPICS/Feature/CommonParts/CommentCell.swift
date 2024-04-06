//
//  CommentCell.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/01.
//

import SwiftUI
import Kingfisher

struct CommentCell: View {
    @Environment(\.colorScheme) var colorScheme
    let comment: Comment
    let onTapImage: (Int) -> Void
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 8) {
                if let userImageUrl = comment.user.profileImageUrl {
                    KFImage(URL(string: userImageUrl))
                        .resizable()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32)
                        .clipShape(Circle())
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(comment.user.fullname)
                            .font(.headline)
                            .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                        
                        Text("@\(comment.user.username)")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                        
                        Spacer()
                        
                        Text(comment.registerTime.timestampString())
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: 4, height: 24)
                            .foregroundStyle(.chepicsPrimary)
                        
                        Text("猫が可愛い")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.chepicsPrimary)
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
                        
                        Image(systemName: "heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        
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
    }
}

#Preview {
    CommentCell(comment: mockComment2, onTapImage: { _ in })
}
