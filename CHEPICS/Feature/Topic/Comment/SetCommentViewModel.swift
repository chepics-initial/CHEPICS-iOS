//
//  SetCommentViewModel.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/22.
//

import Foundation

@MainActor final class SetCommentViewModel: ObservableObject {
    @Published private(set) var set: PickSet
    @Published private(set) var comments: [Comment]?
    @Published private(set) var uiState: UIState = .loading
    @Published var showLikeCommentFailureAlert = false
    @Published var showLikeReplyFailureAlert = false
    @Published private(set) var footerStatus: FooterStatus = .loadingStopped
    private var isInitialAppear = true
    private var offset = 0
    private let setCommentUseCase: any SetCommentUseCase
    
    init(set: PickSet, setCommentUseCase: some SetCommentUseCase) {
        self.set = set
        self.setCommentUseCase = setCommentUseCase
    }
    
    func onAppear() async {
        await fetchSet()
        if isInitialAppear || uiState == .failure {
            isInitialAppear = false
            await fetchComments()
        }
    }
    
    func onTapLikeButton(comment: Comment) async {
        switch await setCommentUseCase.like(setId: comment.setId, commentId: comment.id) {
        case .success(let response):
            if let index = comments?.firstIndex(where: { $0.id == response.commentId }) {
                comments?[index].votes = response.count
                comments?[index].isLiked = response.isLiked
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
        switch await setCommentUseCase.fetchComments(setId: set.id, offset: offset) {
        case .success(let additionalComments):
            for additionalComment in additionalComments {
                if let index = comments?.firstIndex(where: { $0.id == additionalComment.id }) {
                    comments?[index] = additionalComment
                } else {
                    comments?.append(additionalComment)
                }
            }
            if additionalComments.count < Constants.arrayLimit {
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
        switch await setCommentUseCase.fetchSet(setId: set.id) {
        case .success(let pickSet):
            set = pickSet
        case .failure:
            return
        }
    }
    
    private func fetchComments() async {
        switch await setCommentUseCase.fetchComments(setId: set.id, offset: nil) {
        case .success(let comments):
            self.comments = comments
            footerStatus = comments.count < Constants.arrayLimit ? .allFetched : .loadingStopped
            uiState = .success
            offset = Constants.arrayLimit
        case .failure:
            uiState = .failure
        }
    }
}

final class SetCommentUseCase_Previews: SetCommentUseCase {
    func fetchSet(setId: String) async -> Result<PickSet, APIError> {
        .success(mockSet1)
    }
    
    func fetchComments(setId: String, offset: Int?) async -> Result<[Comment], APIError> {
        .success([])
    }
    
    func like(setId: String, commentId: String) async -> Result<LikeResponse, APIError> {
        .success(mockLikeResponse)
    }
}
