//
//  CommentDetailViewModel.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/11.
//

import SwiftUI
import PhotosUI

@MainActor final class CommentDetailViewModel: ObservableObject {
    @Published private(set) var comment: Comment
    @Published private(set) var isLoading = false
    @Published var commentText: String = ""
    @Published var selectedImages: [UIImage] = []
    @Published var selectedItems: [PhotosPickerItem] = [] {
        didSet {
            Task {
                selectedImages = []
                
                for item in selectedItems {
                    guard let data = try? await item.loadTransferable(type: Data.self) else { return }
                    guard let image = UIImage(data: data) else { return }
                    selectedImages.append(image)
                }
            }
        }
    }
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    func onTapSubmitButton() async {
        isLoading = true
        
    }
}
