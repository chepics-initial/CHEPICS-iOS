//
//  GridImagesView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/21.
//

import SwiftUI

struct GridImagesView: View {
    let images: [String]
    let onTapImage: (Int) -> Void
    let type: ContentType
    
    var body: some View {
        let gridImages = images.count % 2 == 1 ? images.dropLast() : images
        let columns = Array(repeating: GridItem(.flexible()), count: 2)
        
        VStack(spacing: 8) {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                ForEach(gridImages.indices, id: \.self) { index in
                    GridImageItemView(url: images[index]) {
                        onTapImage(index)
                    }
                }
            }
            
            if images.count % 2 == 1 {
                Button {
                    onTapImage(images.count - 1)
                } label: {
                    AsyncImage(url: URL(string: images[images.count - 1])) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: getHeight(type))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(maxWidth: .infinity)
                            .frame(height: getHeight(type))
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
    }
    
    private func getHeight(_ type: ContentType) -> CGFloat {
        switch type {
        case .topic:
            // トピックは横のpaddingが16＆画像の間隔が8という仮定のもとでこの16+8+16=40というマイナスをしている
            return (getRect().width - 40) / 2
        case .comment:
            // コメントは横のpaddingが16＆アイコン画像の横幅が32＆HStackのspacingが8＆画像の間隔が8という仮定のもとでこの16+32+8+8+16=80というマイナスをしている
            return (getRect().width - 80) / 2
        }
    }
}

private struct GridImageItemView: View {
    let url: String
    let onTapImage: () -> Void
    
    var body: some View {
        Button {
            onTapImage()
        } label: {
            Color.clear
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    AsyncImage(url: URL(string: url)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

enum ContentType {
    case topic
    case comment
}

#Preview {
    GridImagesView(images: [mockTopicImage1].map({ $0.url }), onTapImage: { _ in }, type: .topic)
}
