//
//  SetCommentDetailView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/15.
//

import SwiftUI

struct SetCommentDetailView: View {
    @Binding var dismissView: Bool
    @StateObject var viewModel: SetCommentDetailViewModel
    
    var body: some View {
        VStack {
            VStack {
                Text(viewModel.set.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 16) {
                    Text("20%")
                        .font(.footnote)
                    
                    HStack(spacing: 4) {
                        Image(.blackPeople)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16)
                        
                        Text("\(viewModel.set.votes)")
                            .font(.footnote)
                    }
                    
                    Spacer()
                }
            }
            .padding()
            
            ScrollView {
                CommentCell(comment: viewModel.comment, type: .detail, onTapImage: { index in
                    
                }, onTapUserInfo: { _ in
                    
                }, onTapLikeButton: {
                    
                }, onTapReplyButton: {
                    viewModel.replyFor = nil
                })
                
                HStack {
                    Image(systemName: "text.bubble.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    
                    Text("リプライ5件")
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                .padding()
                
                LazyVStack {
                    switch viewModel.uiState {
                    case .loading:
                        LoadingView()
                    case .success:
                        if let replies = viewModel.replies {
                            ForEach(replies) { reply in
                                CommentCell(comment: reply, type: .reply, onTapImage: { index in
                                    
                                }, onTapUserInfo: { _ in
                                    
                                }, onTapLikeButton: {
                                    
                                }, onTapReplyButton: {
                                    viewModel.replyFor = reply
                                })
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismissView = true
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.gray)
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showCreateReplyView) {
            NavigationStack {
                CreateCommentView(
                    viewModel: CreateCommentViewModel(
                        topicId: viewModel.comment.topicId,
                        setId: viewModel.comment.setId,
                        parentId: viewModel.comment.id,
                        type: .reply,
                        replyFor: viewModel.replyFor,
                        createCommentUseCase: DIFactory.createCommentUseCase()
                    )
                )
            }
        }
    }
}

#Preview {
    SetCommentDetailView(dismissView: .constant(false), viewModel: SetCommentDetailViewModel(set: mockSet1, comment: mockComment1, setCommentDetailUseCase: SetCommenDetailUseCase_Previews()))
}
