//
//  TopicTopViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/14.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor final class TopicTopViewModel: ObservableObject {
    @Published private(set) var topic: Topic?
    @Published private(set) var viewStatus: TopicViewStatus = .loading
    @Published private(set) var selectedSet: PickSet?
    @Published private(set) var uiState: UIState = .loading
    @Published private(set) var comments: [Comment]?
    @Published private(set) var footerStatus: FooterStatus = .loadingStopped
    @Published var showLikeFailureAlert = false
    private var isInitialAppear = true
    private var offset = 0
    private let topicTopUseCase: any TopicTopUseCase
    let topicId: String
    
    init(topicId: String, topic: Topic?, topicTopUseCase: some TopicTopUseCase) {
        self.topicId = topicId
        self.topic = topic
        self.topicTopUseCase = topicTopUseCase
    }
    
    func onAppear() async {
        if isInitialAppear || viewStatus == .failure {
            isInitialAppear = false
            switch await topicTopUseCase.fetchPickedSet(topicId: topicId) {
            case .success(let pickSet):
                if let pickSet {
                    await selectSet(set: pickSet)
                } else {
                    await fetchTopic()
                    if topic == nil {
                        viewStatus = .failure
                        return
                    }
                    viewStatus = .top
                }
            case .failure:
                viewStatus = .failure
            }
        }
    }
    
    private func fetchTopic() async {
        switch await topicTopUseCase.fetchTopic(topicId: topicId) {
        case .success(let topic):
            self.topic = topic
        case .failure:
            return
        }
    }
    
    func selectSet(set: PickSet) async {
        await fetchTopic()
        if topic != nil {
            selectedSet = set
            viewStatus = .detail
            uiState = .loading
            switch await topicTopUseCase.fetchSetComments(setId: set.id, offset: nil) {
            case .success(let comments):
                self.comments = comments
                footerStatus = comments.count < Constants.arrayLimit ? .allFetched : .loadingStopped
                uiState = .success
                offset = Constants.arrayLimit
            case .failure:
                uiState = .failure
            }
        } else {
            viewStatus = .failure
        }
    }
    
    func onTapLikeButton(comment: Comment) async {
        switch await topicTopUseCase.like(setId: comment.setId, commentId: comment.id) {
        case .success(let response):
            if let index = comments?.firstIndex(where: { $0.id == response.commentId }) {
                comments?[index].votes = response.count
                comments?[index].isLiked = response.isLiked
            }
        case .failure(let error):
            if case .errorResponse(let errorResponse, _) = error, errorResponse.errorCode == .ERROR_SET_NOT_PICKED {
                showLikeFailureAlert = true
            }
        }
    }
    
    func onAppearFooterView() async {
        guard footerStatus == .loadingStopped || footerStatus == .failure, let selectedSet else { return }
        footerStatus = .loadingStarted
        switch await topicTopUseCase.fetchSetComments(setId: selectedSet.id, offset: offset) {
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
    
    func createCommentCompletion() async {
        switch await topicTopUseCase.fetchPickedSet(topicId: topicId) {
        case .success(let pickSet):
            if let pickSet {
                selectedSet = pickSet
                switch await topicTopUseCase.fetchSetComments(setId: pickSet.id, offset: nil) {
                case .success(let comments):
                    self.comments = comments
                    footerStatus = comments.count < Constants.arrayLimit ? .allFetched : .loadingStopped
                    uiState = .success
                case .failure:
                    return
                }
            }
        case .failure:
            return
        }
    }
}

enum TopicViewStatus {
    case loading
    case failure
    case top
    case detail
}

final class TopicTopUseCase_Previews: TopicTopUseCase {
    func fetchTopic(topicId: String) async -> Result<Topic, APIError> {
        .success(mockTopic1)
    }
    
    func fetchSetComments(setId: String, offset: Int?) async -> Result<[Comment], APIError> {
        .success([mockComment1])
    }
    
    func fetchPickedSet(topicId: String) async -> Result<PickSet?, APIError> {
        .success(nil)
    }
    
    func like(setId: String, commentId: String) async -> Result<LikeResponse, APIError> {
        .success(mockLikeResponse)
    }
}
