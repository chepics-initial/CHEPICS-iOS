//
//  CommentDetailView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/11.
//

import SwiftUI

struct CommentDetailView: View {
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    @EnvironmentObject var router: NavigationRouter
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: CommentDetailViewModel
    @State private var showCreateReplyView = false
    @State private var replyFor: Comment?
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    CommentCell(comment: viewModel.comment, type: .detail, onTapImage: { index in
                        if let images = viewModel.comment.images {
                            mainTabViewModel.images = images.map({ $0.url })
                            mainTabViewModel.pagerState = ImagePagerState(pageCount: images.count, initialIndex: index, pageSize: getRect().size)
                            withAnimation {
                                mainTabViewModel.showImageViewer = true
                            }
                        }
                    }, onTapUserInfo: { user in
                        router.items.append(.profile(user: user))
                    }, onTapLikeButton: {
                        
                    }, onTapReplyButton: {
                        replyFor = nil
                        showCreateReplyView = true
                    })
                    
                    HStack {
                        Text("Reply")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                        
                        Text("4件の返信")
                            .foregroundStyle(.gray)
                        
                        Spacer()
                    }
                    .padding()
                    
                    switch viewModel.uiState {
                    case .loading:
                        LoadingView()
                    case .success:
                        if let replies = viewModel.replies {
                            LazyVStack {
                                ForEach(replies) { reply in
                                    CommentCell(comment: reply, type: .reply, onTapImage: { index in
                                        if let images = reply.images {
                                            mainTabViewModel.images = images.map({ $0.url })
                                            mainTabViewModel.pagerState = ImagePagerState(pageCount: images.count, initialIndex: index, pageSize: getRect().size)
                                            withAnimation {
                                                mainTabViewModel.showImageViewer = true
                                            }
                                        }
                                    }, onTapUserInfo: { user in
                                        router.items.append(.profile(user: user))
                                    }, onTapLikeButton: {
                                        
                                    }, onTapReplyButton: {
                                        replyFor = reply
                                        showCreateReplyView = true
                                    })
                                }
                            }
                        }
                    case .failure:
                        ErrorView()
                    }
                }
            }
        }
        .onAppear {
            Task { await viewModel.onAppear() }
        }
        .fullScreenCover(isPresented: $showCreateReplyView) {
            NavigationStack {
                CreateCommentView(viewModel: CreateCommentViewModel(topicId: viewModel.comment.topicId, setId: viewModel.comment.setId, parentId: viewModel.comment.id, type: .reply, replyFor: replyFor, createCommentUseCase: DIFactory.createCommentUseCase()))
            }
        }
    }
}

#Preview {
    CommentDetailView(viewModel: CommentDetailViewModel(comment: mockComment1, commentDetailUseCase: CommentDetailUseCase_Previews()))
}
