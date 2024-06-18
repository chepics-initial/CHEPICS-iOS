//
//  SetCommentView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/15.
//

import SwiftUI

struct SetCommentView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: SetCommentViewModel
    @Binding var dismissView: Bool
    @State private var isNavigationActive = false
    @State private var showReplyComment: Comment?
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Image(systemName: "text.bubble.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    
                    Text("コメント\(viewModel.set.commentCount)件")
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                
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
                switch viewModel.uiState {
                case .loading:
                    LoadingView(showBackgroundColor: false)
                case .success:
                    LazyVStack {
                        if let comments = viewModel.comments {
                            ForEach(comments) { comment in
                                CommentCell(comment: comment, type: .set, onTapImage: { index in
                                }, onTapUserInfo: { _ in
                                    
                                }, onTapLikeButton: {
                                    Task { await viewModel.onTapLikeButton(comment: comment) }
                                }, onTapReplyButton: {})
                                .onTapGesture {
                                    showReplyComment = comment
                                    isNavigationActive = true
                                }
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
        .modifier(ToastModifier(showToast: $viewModel.showLikeCommentFailureAlert, text: "選択していないセットのコメントにはいいねをすることができません"))
        .modifier(ToastModifier(showToast: $viewModel.showLikeCommentFailureAlert, text: "参加していないトピックの返信にはいいねをすることができません"))
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
        .navigationDestination(isPresented: $isNavigationActive) {
            if let showReplyComment {
                SetCommentDetailView(dismissView: $dismissView, viewModel: SetCommentDetailViewModel(set: viewModel.set, comment: showReplyComment, setCommentDetailUseCase: DIFactory.setCommentDetailUseCase()))
            }
        }
    }
}

#Preview {
    SetCommentView(viewModel: SetCommentViewModel(set: mockSet1, setCommentUseCase: SetCommentUseCase_Previews()), dismissView: .constant(false))
}
