//
//  SetCommentDetailViewModel.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/22.
//

import Foundation

@MainActor final class SetCommentDetailViewModel: ObservableObject {
    @Published private(set) var set: PickSet
    @Published private(set) var comment: Comment
    @Published private(set) var replies: [Comment]?
    @Published private(set) var uiState: UIState = .loading
    @Published var showLikeCommentFailureAlert = false
    @Published var showLikeReplyFailureAlert = false
    @Published private(set) var footerStatus: FooterStatus = .loadingStopped
    private var isInitialAppear = true
    private var offset = 0
    private let setCommentDetailUseCase: any SetCommentDetailUseCase
    
    init(set: PickSet, comment: Comment, setCommentDetailUseCase: some SetCommentDetailUseCase) {
        self.set = set
        self.comment = comment
        self.setCommentDetailUseCase = setCommentDetailUseCase
    }
    
    func onAppear() async {
        await fetchSet()
        await fetchComment()
        if isInitialAppear || uiState == .failure {
            isInitialAppear = false
            await fetchReplies()
        }
    }
    
    func onTapLikeButton(comment: Comment) async {
        switch await setCommentDetailUseCase.like(setId: comment.setId, commentId: comment.id) {
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
                
                if errorResponse.errorCode == .ERROR_TOPIC_NOT_PICKED {
                    showLikeReplyFailureAlert = true
                    return
                }
            }
        }
    }
    
    func onAppearFooterView() async {
        guard footerStatus == .loadingStopped || footerStatus == .failure else { return }
        footerStatus = .loadingStarted
        switch await setCommentDetailUseCase.fetchReplies(commentId: comment.id, offset: offset) {
        case .success(let additionalReplies):
            for additionalReply in additionalReplies {
                if let index = replies?.firstIndex(where: { $0.id == additionalReply.id }) {
                    replies?[index] = additionalReply
                } else {
                    replies?.append(additionalReply)
                }
            }
            if additionalReplies.count < Constants.arrayLimit {
                footerStatus = .allFetched
                offset = 0
                return
            }
            footerStatus = .loadingStopped
            offset += Constants.arrayLimit
        case .failure:
            footerStatus = .failure
        }
    }
    
    private func fetchSet() async {
        switch await setCommentDetailUseCase.fetchSet(setId: set.id) {
        case .success(let pickset):
            set = pickset
        case .failure:
            return
        }
    }
    
    private func fetchComment() async {
        switch await setCommentDetailUseCase.fetchComment(commentId: comment.id) {
        case .success(let comment):
            self.comment = comment
        case .failure:
            return
        }
    }
    
    private func fetchReplies() async {
        switch await setCommentDetailUseCase.fetchReplies(commentId: comment.id, offset: nil) {
        case .success(let replies):
            self.replies = replies
            footerStatus = replies.count < Constants.arrayLimit ? .allFetched : .loadingStopped
            uiState = .success
            offset = Constants.arrayLimit
        case .failure:
            uiState = .failure
        }
    }
}

final class SetCommenDetailUseCase_Previews: SetCommentDetailUseCase {
    func fetchSet(setId: String) async -> Result<PickSet, APIError> {
        .success(mockSet1)
    }
    
    func fetchComment(commentId: String) async -> Result<Comment, APIError> {
        .success(mockComment1)
    }
    
    func fetchReplies(commentId: String, offset: Int?) async -> Result<[Comment], APIError> {
        .success([])
    }
    
    func like(setId: String, commentId: String) async -> Result<LikeResponse, APIError> {
        .success(mockLikeResponse)
    }
}
