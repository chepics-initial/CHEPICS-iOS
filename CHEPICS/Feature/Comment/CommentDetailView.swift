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
    let isTopicTitleEnabled: Bool
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    switch viewModel.headerUIState {
                    case .loading:
                        LoadingView(showBackgroundColor: false)
                    case .success:
                        if let comment = viewModel.comment {
                            CommentCell(comment: comment, type: isTopicTitleEnabled ? .detail : .topicCommentDetail, onTapImage: { index in
                                if let images = comment.images {
                                    mainTabViewModel.images = images.map({ $0.url })
                                    mainTabViewModel.pagerState = ImagePagerState(pageCount: images.count, initialIndex: index, pageSize: getRect().size)
                                    withAnimation {
                                        mainTabViewModel.showImageViewer = true
                                    }
                                }
                            }, onTapUserInfo: { user in
                                router.items.append(.profile(user: user))
                            }, onTapLikeButton: {
                                Task { await viewModel.onTapLikeButton(comment: comment) }
                            }, onTapReplyButton: {
                                Task { await viewModel.onTapReplyButton(replyFor: nil) }
                            }, onTapTopicTitle: {
                                if isTopicTitleEnabled {
                                    router.items.append(.topicTop(topicId: comment.topicId, topic: nil))
                                }
                            })
                            
                            if let parentId = comment.parentId {
                                HStack {
                                    Spacer()
                                    
                                    Button(action: {
                                        router.items.append(.comment(commentId: parentId, comment: nil, showTopicTitle: isTopicTitleEnabled))
                                    }, label: {
                                        HStack {
                                            Text("リプライ元のコメントを見る")
                                                .foregroundStyle(.chepicsPrimary)
                                            
                                            Image(systemName: "chevron.forward")
                                        }
                                    })
                                }
                                .padding()
                            } else {
                                HStack {
                                    Text("Reply")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                                    
                                    if let replyCount = comment.replyCount {
                                        Text("\(replyCount) 件の返信")
                                            .foregroundStyle(.gray)
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                                
                                switch viewModel.uiState {
                                case .loading:
                                    LoadingView(showBackgroundColor: false)
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
                                                    Task { await viewModel.onTapLikeButton(comment: reply) }
                                                }, onTapReplyButton: {
                                                    Task { await viewModel.onTapReplyButton(replyFor: reply) }
                                                }, onTapTopicTitle: {
                                                    if isTopicTitleEnabled {
                                                        router.items.append(.topicTop(topicId: reply.topicId, topic: nil))
                                                    }
                                                })
                                            }
                                            
                                            FooterView(footerStatus: viewModel.footerStatus)
                                                .onAppear {
                                                    Task { await viewModel.onAppearFooterView() }
                                                }
                                        }
                                    }
                                case .failure:
                                    ErrorView()
                                }
                            }
                        }
                    case .failure:
                        ErrorView()
                    }
                    
                }
            }
        }
        .modifier(ToastModifier(showToast: $viewModel.showReplyRestriction, text: "トピック内でセットを選択することでリプライが可能になります"))
        .modifier(ToastModifier(showToast: $viewModel.showLikeCommentFailureAlert, text: "選択していないセットのコメントにはいいねをすることができません"))
        .modifier(ToastModifier(showToast: $viewModel.showLikeReplyFailureAlert, text: "参加していないトピックの返信にはいいねをすることができません"))
        .onAppear {
            Task { await viewModel.onAppear() }
        }
        .fullScreenCover(isPresented: $viewModel.showCreateReplyView) {
            if let comment = viewModel.comment {
                NavigationStack {
                    CreateCommentView(
                        viewModel: CreateCommentViewModel(
                            topicId: comment.topicId,
                            setId: comment.setId,
                            parentId: comment.id,
                            type: .reply,
                            replyFor: viewModel.replyFor,
                            createCommentUseCase: DIFactory.createCommentUseCase()
                        )
                    ) {
                        Task { await viewModel.createReplyCompletion() }
                    }
                }
            }
        }
    }
}

#Preview {
    CommentDetailView(viewModel: CommentDetailViewModel(commentId: "", comment: mockComment1, commentDetailUseCase: CommentDetailUseCase_Previews()), isTopicTitleEnabled: true)
}
