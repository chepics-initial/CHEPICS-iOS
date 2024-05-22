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
    
    private let setCommentUseCase: any SetCommentUseCase
    
    init(set: PickSet, setCommentUseCase: some SetCommentUseCase) {
        self.set = set
        self.setCommentUseCase = setCommentUseCase
    }
    
    func onAppear() async {
        await fetchSet()
        await fetchComments()
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
