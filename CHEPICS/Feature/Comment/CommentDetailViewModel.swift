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
    @Published var showReplyRestriction = false
    @Published private(set) var footerStatus: FooterStatus = .loadingStopped
    @Published var showLikeCommentFailureAlert = false
    @Published var showLikeReplyFailureAlert = false
    @Published private(set) var replyFor: Comment? {
        didSet {
            showCreateReplyView = true
        }
    }
    private var isInitialAppear = true
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
        
        if isInitialAppear || uiState == .failure {
            isInitialAppear = false
            switch await commentDetailUseCase.fetchReplies(commentId: comment.id, offset: nil) {
            case .success(let replies):
                self.replies = replies
                if replies.count < Constants.arrayLimit {
                    footerStatus = .allFetched
                } else {
                    footerStatus = .loadingStopped
                }
                uiState = .success
            case .failure:
                uiState = .failure
            }
        }
    }
    
    func onAppearFooterView() async {
        guard footerStatus == .loadingStopped || footerStatus == .failure else { return }
        footerStatus = .loadingStarted
        switch await commentDetailUseCase.fetchReplies(commentId: comment.id, offset: replies?.count) {
        case .success(let additionalReplies):
            for additionalReply in additionalReplies {
                if let index = self.replies?.firstIndex(where: { $0.id == additionalReply.id }) {
                    self.replies?[index] = additionalReply
                } else {
                    self.replies?.append(additionalReply)
                }
            }
            if additionalReplies.count < Constants.arrayLimit {
                footerStatus = .allFetched
            } else {
                footerStatus = .loadingStopped
            }
        case .failure:
            footerStatus = .failure
        }
    }
    
    func onTapLikeButton(comment: Comment) async {
        switch await commentDetailUseCase.like(setId: comment.setId, commentId: comment.id) {
        case .success(let response):
            if self.comment.id == response.commentId {
                self.comment.votes = response.count
                self.comment.isLiked = response.isLiked
                return
            }
            if let index = replies?.firstIndex(where: { $0.id == response.commentId }) {
                replies?[index].votes = response.count
                replies?[index].isLiked = response.isLiked
            }
        case .failure(let error):
            if case .errorResponse(let errorResponse, _) = error {
                if errorResponse.errorCode == .ERROR_SET_NOT_PICKED {
                    showLikeCommentFailureAlert = true
                    return
                }
                
                if errorResponse.errorCode == .ERROR_SET_NOT_PICKED {
                    showLikeReplyFailureAlert = true
                    return
                }
            }
        }
    }
    
    func onTapReplyButton(replyFor: Comment?) async {
        switch await commentDetailUseCase.isPickedSet(topicId: comment.topicId) {
        case .success(let isPicked):
            if isPicked {
                self.replyFor = replyFor
                return
            }
            
            showReplyRestriction = true
        case .failure:
            return
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
    
    func isPickedSet(topicId: String) async -> Result<Bool, APIError> {
        .success(true)
    }
    
    func like(setId: String, commentId: String) async -> Result<LikeResponse, APIError> {
        .success(mockLikeResponse)
    }
}
