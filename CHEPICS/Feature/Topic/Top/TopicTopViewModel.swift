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
    @Published private(set) var viewStatus: TopicViewStatus = .top
    // TODO: - モックの削除
    @Published private(set) var selectedSet: PickSet? = PickSet(id: "", name: "うちの猫だけが世界一可愛い", votes: 140, commentCount: "")
    @Published private(set) var uiState: UIState = .loading
    // TODO: - モックの削除
    @Published private(set) var comments: [Comment]? = [mockComment1, mockComment2, mockComment3, mockComment4]
    @Published var commentText: String = ""
    @Published private(set) var selectedImages: [UIImage] = []
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
    @Published private(set) var isLoading = false
    
    private let topicTopUseCase: any TopicTopUseCase
    
    init(topic: Topic, topicTopUseCase: some TopicTopUseCase) {
        self.topic = topic
        self.topicTopUseCase = topicTopUseCase
    }
    
    func onAppear() async {
        switch await topicTopUseCase.fetchTopic(topicId: topic.id) {
        case .success(let topic):
            self.topic = topic
        case .failure:
            return
        }
    }
    
    func selectSet(set: PickSet) async {
        selectedSet = set
        uiState = .loading
        switch await topicTopUseCase.fetchSetComments(setId: set.id) {
        case .success(let comments):
            self.comments = comments
            uiState = .success
        case .failure:
            uiState = .failure
        }
    }
    
    func onTapSubmitButton() async {
        isLoading = true
        
    }
}

enum TopicViewStatus {
    case top
    case detail
}

final class TopicTopUseCase_Previews: TopicTopUseCase {
    func fetchTopic(topicId: String) async -> Result<Topic, APIError> {
        .success(mockTopic1)
    }
    
    func fetchSetComments(setId: String) async -> Result<[Comment], APIError> {
        .success([mockComment1])
    }
}
