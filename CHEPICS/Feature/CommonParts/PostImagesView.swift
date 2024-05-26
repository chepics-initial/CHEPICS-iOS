//
//  PostImagesView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/26.
//

import SwiftUI
import PhotosUI

struct PostImagesView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedItems: [PhotosPickerItem]
    let images: [UIImage]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("画像")
                .font(.headline)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(images, id: \.self) { image in
                        PhotosPicker(
                            selection: $selectedItems,
                            maxSelectionCount: 4,
                            selectionBehavior: .ordered,
                            matching: .images
                        ) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(style: StrokeStyle())
                                        .foregroundStyle(.gray)
                                }
                        }
                    }
                    
                    if images.count < Constants.imageCount {
                        PhotosPicker(
                            selection: $selectedItems,
                            maxSelectionCount: 4,
                            selectionBehavior: .ordered,
                            matching: .images
                        ) {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32)
                                .foregroundStyle(.gray)
                                .padding()
                                .frame(width: 120, height: 120)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(style: StrokeStyle())
                                        .foregroundStyle(.gray)
                                }
                        }
                    }
                }
                .padding(1)
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    PostImagesView(selectedItems: .constant([]), images: [])
}
