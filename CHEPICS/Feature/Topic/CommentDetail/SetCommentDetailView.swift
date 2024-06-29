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
                    Text("\(Int(viewModel.set.rate))%")
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
                CommentCell(comment: viewModel.comment, type: .setDetail, onTapImage: { index in
                    
                }, onTapUserInfo: { _ in
                    
                }, onTapLikeButton: {
                    Task { await viewModel.onTapLikeButton(comment: viewModel.comment) }
                }, onTapReplyButton: {
                })
                
                if let replyCount = viewModel.comment.replyCount {
                    HStack {
                        Image(systemName: "text.bubble.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        
                        Text("リプライ \(replyCount) 件")
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    .padding()
                }
                
                LazyVStack {
                    switch viewModel.uiState {
                    case .loading:
                        LoadingView(showBackgroundColor: false)
                    case .success:
                        if let replies = viewModel.replies {
                            ForEach(replies) { reply in
                                CommentCell(comment: reply, type: .reply, onTapImage: { index in
                                    
                                }, onTapUserInfo: { _ in
                                    
                                }, onTapLikeButton: {
                                    Task { await viewModel.onTapLikeButton(comment: reply) }
                                }, onTapReplyButton: {
                                })
                            }
                            
                            FooterView(footerStatus: viewModel.footerStatus)
                                .onAppear {
                                    Task { await viewModel.onAppearFooterView() }
                                }
                        }
                    case .failure:
                        ErrorView()
                    }
                }
            }
        }
        .modifier(ToastModifier(showToast: $viewModel.showLikeCommentFailureAlert, text: "選択していないセットのコメントにはいいねをすることができません"))
        .modifier(ToastModifier(showToast: $viewModel.showLikeReplyFailureAlert, text: "参加していないトピックの返信にはいいねをすることができません"))
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
    }
}

#Preview {
    SetCommentDetailView(dismissView: .constant(false), viewModel: SetCommentDetailViewModel(set: mockSet1, comment: mockComment1, setCommentDetailUseCase: SetCommenDetailUseCase_Previews()))
}
