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
    @Published private(set) var topic: Topic
    @Published private(set) var viewStatus: TopicViewStatus = .loading
    @Published private(set) var selectedSet: PickSet?
    @Published private(set) var uiState: UIState = .loading
    @Published private(set) var comments: [Comment]?
    @Published var showLikeFailureAlert = false
    private var isInitialAppear = true
    private let topicTopUseCase: any TopicTopUseCase
    
    init(topic: Topic, topicTopUseCase: some TopicTopUseCase) {
        self.topic = topic
        self.topicTopUseCase = topicTopUseCase
    }
    
    func onAppear() async {
        if isInitialAppear || viewStatus == .failure {
            isInitialAppear = false
            switch await topicTopUseCase.fetchPickedSet(topicId: topic.id) {
            case .success(let pickSet):
                if let pickSet {
                    await selectSet(set: pickSet)
                } else {
                    viewStatus = .top
                    await fetchTopic()
                }
            case .failure:
                viewStatus = .failure
            }
        }
    }
    
    private func fetchTopic() async {
        switch await topicTopUseCase.fetchTopic(topicId: topic.id) {
        case .success(let topic):
            self.topic = topic
        case .failure:
            return
        }
    }
    
    func selectSet(set: PickSet) async {
        selectedSet = set
        viewStatus = .detail
        await fetchTopic()
        uiState = .loading
        switch await topicTopUseCase.fetchSetComments(setId: set.id, offset: nil) {
        case .success(let comments):
            self.comments = comments
            uiState = .success
        case .failure:
            uiState = .failure
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
