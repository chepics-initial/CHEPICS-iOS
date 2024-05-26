//
//  CommentMaker.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/18.
//

import SwiftUI
import PhotosUI

struct CommentMaker: View {
    @Binding var text: String
    @Binding var selectedImages: [UIImage]
    @Binding var selectedItems: [PhotosPickerItem]
    let type: CreateCommentType
    let onTapSubmitButton: () -> Void
    
    var body: some View {
        VStack {
            Divider()
            
            CustomHeightTextEditor(text: $text, placeholder: type.placeholder, minHeight: 44, maxHeight: getRect().height * 0.2)
            
            HStack {
                if selectedImages.isEmpty {
                    PhotosPicker(
                        selection: $selectedItems,
                        maxSelectionCount: 4,
                        selectionBehavior: .ordered,
                        matching: .images
                    ) {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                            .foregroundStyle(.chepicsPrimary)
                    }
                } else {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(selectedImages, id: \.self) { image in
                                PhotosPicker(
                                    selection: $selectedItems,
                                    maxSelectionCount: 4,
                                    selectionBehavior: .ordered,
                                    matching: .images
                                ) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(style: StrokeStyle())
                                                .foregroundStyle(.gray)
                                        }
                                }
                            }
                            
                            if selectedImages.count < Constants.imageCount {
                                PhotosPicker(
                                    selection: $selectedItems,
                                    maxSelectionCount: 4,
                                    selectionBehavior: .ordered,
                                    matching: .images
                                ) {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24)
                                        .foregroundStyle(.gray)
                                        .padding()
                                        .frame(width: 80, height: 80)
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
                
                Spacer()
                
                Button {
                    onTapSubmitButton()
                } label: {
                    Image(.paperplane)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16)
                        .padding()
                        .background {
                            Circle()
                                .foregroundStyle(.chepicsPrimary)
                        }
                }

            }
            .padding(.vertical, 4)
            .padding(.horizontal)
        }
    }
}

struct CustomHeightTextEditor: View {

    @Binding var text: String
    @State var textHeight: CGFloat = 0

    var placeholder: String
    var minHeight: CGFloat
    var maxHeight: CGFloat

    //TextEditorの高さを保持するプロパティ
    var textEditorHeight: CGFloat {
        if textHeight < minHeight {
            return minHeight
        }

        if textHeight > maxHeight {
            return maxHeight
        }

        return textHeight
    }

    var body: some View {
        ZStack {
            Color.gray.opacity(0.4)

            ZStack {
                //Placeholder
                if text.isEmpty {
                    HStack {
                        Text(placeholder)
                            .font(.system(size: 16))
                            .foregroundStyle(.gray)
                            .padding(.leading, 4)
                        Spacer()
                    }
                }

                CustomTextView(text: $text, height: $textHeight)
            }
            .padding(4)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .frame(height: textEditorHeight) //← ここで高さを反映
        .padding(.horizontal)
    }
}

#Preview {
    CommentMaker(text: .constant(""), selectedImages: .constant([]), selectedItems: .constant([]), type: .comment, onTapSubmitButton: {})
}
