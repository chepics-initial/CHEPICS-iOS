//
//  GridImagesView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/21.
//

import SwiftUI
import Kingfisher

struct GridImagesView: View {
    let images: [String]
    let onTapImage: (String) -> Void
    let type: ContentType
    
    var body: some View {
        let gridImages = images.count % 2 == 1 ? images.dropLast() : images
        let columns = Array(repeating: GridItem(.flexible()), count: 2)
        
        VStack(spacing: 8) {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                ForEach(gridImages.indices, id: \.self) { index in
                    imageView(index: index)
                }
            }
            
            if images.count % 2 == 1 {
                Button {
                    onTapImage(images[images.count - 1])
                } label: {
                    KFImage(URL(string: images[images.count - 1]))
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: getHeight(type))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }
    
    private func imageView(index: Int) -> some View {
        Button {
            onTapImage(images[index])
        } label: {
            Color.clear
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    KFImage(URL(string: images[index]))
                        .resizable()
                        .scaledToFill()
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    private func getHeight(_ type: ContentType) -> CGFloat {
        (getRect().width - 40) / 2
    }
}

enum ContentType {
    case topic
    case comment
}

#Preview {
    GridImagesView(images: [mockTopicImage1].map({ $0.url }), onTapImage: { _ in }, type: .topic)
}
