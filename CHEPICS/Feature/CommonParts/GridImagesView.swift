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
    let index: Int
    let onTapImage: (String) -> Void
    
    var body: some View {
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
}

#Preview {
    GridImagesView(images: [mockTopicImage1].map({ $0.url }), index: 0, onTapImage: { _ in })
}
