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
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    CommentCell(comment: viewModel.comment, type: .detail, onTapImage: { index in
                        if let images = viewModel.comment.images {
                            UIApplication.shared.endEditing()
                            mainTabViewModel.images = images.map({ $0.url })
                            mainTabViewModel.pagerState = ImagePagerState(pageCount: images.count, initialIndex: index, pageSize: getRect().size)
                            withAnimation {
                                mainTabViewModel.showImageViewer = true
                            }
                        }
                    }, onTapUserInfo: { userId in
                        router.items.append(.profile(userId: userId))
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
                    
                    LazyVStack {
                        ForEach(0..<5, id: \.self) { _ in
                            CommentCell(comment: mockComment3, type: .reply, onTapImage: { index in
                                if let images = mockComment3.images {
                                    UIApplication.shared.endEditing()
                                    mainTabViewModel.images = images.map({ $0.url })
                                    mainTabViewModel.pagerState = ImagePagerState(pageCount: images.count, initialIndex: index, pageSize: getRect().size)
                                    withAnimation {
                                        mainTabViewModel.showImageViewer = true
                                    }
                                }
                            }, onTapUserInfo: { userId in
                                router.items.append(.profile(userId: userId))
                            })
                        }
                    }
                }
                
                CreateCommentView(
                    text: $viewModel.commentText,
                    selectedImages: $viewModel.selectedImages,
                    selectedItems: $viewModel.selectedItems,
                    type: .reply
                ) {
                    UIApplication.shared.endEditing()
                    Task { await viewModel.onTapSubmitButton() }
                }
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

#Preview {
    CommentDetailView(viewModel: CommentDetailViewModel(comment: mockComment1))
}
