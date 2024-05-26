//
//  CreateCommentViewModel.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/26.
//

import SwiftUI
import PhotosUI

@MainActor final class CreateCommentViewModel: ObservableObject {
    @Published var commentText = ""
    @Published var linkText = ""
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
    @Published private(set) var selectedImages: [UIImage] = []
    
    var isActive: Bool {
        isValidInput(commentText) || commentText.count <= Constants.commentCount && (linkText.isEmpty || isValidUrl(linkText))
    }
    
    private(set) var replyFor: Comment?
    let type: CreateCommentType
    
    private let topicId: String
    private let setId: String
    private let parentId: String?
    
    private let createCommentUseCase: any CreateCommentUseCase
    
    init(topicId: String, setId: String, parentId: String?, type: CreateCommentType, replyFor: Comment?, createCommentUseCase: some CreateCommentUseCase) {
        self.topicId = topicId
        self.setId = setId
        self.parentId = parentId
        self.type = type
        self.replyFor = replyFor
        self.createCommentUseCase = createCommentUseCase
    }
    
    func onTapSubmitButton() async {
        
    }
}

enum CreateCommentType {
    case comment
    case reply
    
    var placeholder: String {
        switch self {
        case .comment:
            "コメントを入力"
        case .reply:
            "リプライを入力"
        }
    }
    
    var navigationTitle: String {
        switch self {
        case .comment:
            "コメントを作成"
        case .reply:
            "リプライを作成"
        }
    }
}

final class CreateCommentUseCase_Previews: CreateCommentUseCase {
    
}
