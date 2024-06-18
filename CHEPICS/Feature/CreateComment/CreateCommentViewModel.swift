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
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isCompleted = false
    @Published var showNetworkAlert = false
    @Published var showCommentRestrictionAlert = false
    @Published var showReplyRestrictionAlert = false
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
        isLoading = true
        var imageData = [Data]()
        for image in selectedImages {
            guard let data = image.jpegData(compressionQuality: 0.8) else {
                isLoading = false
                return
            }
            imageData.append(data)
        }
        var replyUserIds: [String]?
        if let replyFor {
            replyUserIds = [replyFor.user.id]
        }
        let result = await createCommentUseCase.createComment(
            parentId: parentId,
            topicId: topicId,
            setId: setId,
            comment: commentText,
            link: linkText,
            replyFor: replyUserIds,
            images: imageData
        )
        isLoading = false
        switch result {
        case .success:
            isCompleted = true
        case .failure(let error):
            if case .errorResponse(let errorResponse, _) = error {
                if errorResponse.errorCode == .INVALID_REFRESH_TOKEN {
                    return
                }
                if errorResponse.errorCode == .ERROR_SET_NOT_PICKED {
                    showCommentRestrictionAlert = true
                    return
                }
                if errorResponse.errorCode == .ERROR_TOPIC_NOT_PICKED {
                    showReplyRestrictionAlert = true
                    return
                }
            }
            showNetworkAlert = true
        }
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
    func createComment(parentId: String?, topicId: String, setId: String, comment: String, link: String?, replyFor: [String]?, images: [Data]?) async -> Result<Void, APIError> {
        .success(())
    }
}
