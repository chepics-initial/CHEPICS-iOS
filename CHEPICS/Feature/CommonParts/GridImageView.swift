//
//  GridImageView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/21.
//

import SwiftUI
import Kingfisher

struct GridImageView: View {
    let images: [String]
    let index: Int
    let onTapImage: (String) -> Void
    
    var body: some View {
        Button {
            onTapImage(images[index])
        } label: {
            KFImage(URL(string: images[index]))
                .resizable()
                .scaledToFill()
                .frame(width: getWidth(index: index, imageCount: images.count), height: getHeight())
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    private func getHeight() -> CGFloat {
        (getRect().width - 40) / 2
    }
    
    private func getWidth(index: Int, imageCount: Int) -> CGFloat {
        if imageCount % 2 == 0 {
            return getHeight()
        }
        
        if index == imageCount - 1 {
            return getRect().width - 32
        }
        
        return getHeight()
    }
}

#Preview {
    GridImageView(images: [mockTopicImage1].map({ $0.url }), index: 0, onTapImage: { _ in })
}
