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
    
    private let setCommentUseCase: any SetCommentUseCase
    
    init(set: PickSet, setCommentUseCase: some SetCommentUseCase) {
        self.set = set
        self.setCommentUseCase = setCommentUseCase
    }
    
    func onAppear() async {
        await fetchSet()
        await fetchComments()
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
                
                if errorResponse.errorCode == .ERROR_SET_NOT_PICKED {
                    showLikeReplyFailureAlert = true
                    return
                }
            }
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
            uiState = .success
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
