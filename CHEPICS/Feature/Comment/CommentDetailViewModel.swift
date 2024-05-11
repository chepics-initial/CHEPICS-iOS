//
//  CommentDetailViewModel.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/11.
//

import Foundation

@MainActor final class CommentDetailViewModel: ObservableObject {
    @Published private(set) var comment: Comment
    
    init(comment: Comment) {
        self.comment = comment
    }
}
