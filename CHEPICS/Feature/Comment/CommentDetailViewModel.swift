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
    @Published private(set) var uiState: UIState = .loading
    @Published private(set) var replies: [Comment]?
    @Published var showCreateReplyView = false
    @Published var replyFor: Comment? {
        didSet {
            showCreateReplyView = true
        }
    }
    
    private let commentDetailUseCase: any CommentDetailUseCase
    
    init(comment: Comment, commentDetailUseCase: some CommentDetailUseCase) {
        self.comment = comment
        self.commentDetailUseCase = commentDetailUseCase
    }
    
    func onAppear() async {
        switch await commentDetailUseCase.fetchComment(id: comment.id) {
        case .success(let comment):
            self.comment = comment
        case .failure:
            break
        }
        
        switch await commentDetailUseCase.fetchReplies(commentId: comment.id, offset: nil) {
        case .success(let replies):
            self.replies = replies
            uiState = .success
        case .failure:
            uiState = .failure
        }
    }
}

final class CommentDetailUseCase_Previews: CommentDetailUseCase {
    func fetchComment(id: String) async -> Result<Comment, APIError> {
        .success(mockComment1)
    }
    
    func fetchReplies(commentId: String, offset: Int?) async -> Result<[Comment], APIError> {
        .success([])
    }
}
