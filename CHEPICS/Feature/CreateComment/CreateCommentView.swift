//
//  CreateCommentView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/26.
//

import SwiftUI

struct CreateCommentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: CreateCommentViewModel
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    if let replyFor = viewModel.replyFor {
                        HStack {
                            Image(systemName: "arrowshape.turn.up.left.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                            
                            Text("\(replyFor.user.fullname)に返信")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    }
                    
                    Spacer()
                        .frame(height: 32)
                    
                    CustomTextEditor(text: $viewModel.commentText, placeHolder: viewModel.type.placeholder)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 32)
                    
                    Text("リンク")
                        .font(.headline)
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    TextField("リンクを入力", text: $viewModel.linkText)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 32)
                    
                    PostImagesView(selectedItems: $viewModel.selectedItems, images: viewModel.selectedImages)
                        .padding(.horizontal)
                }
                
                Divider()
                
                RoundButton(text: "投稿", isActive: viewModel.isActive, type: .fill) {
                    Task { await viewModel.onTapSubmitButton() }
                }
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .navigationTitle(viewModel.type.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button {
                    UIApplication.shared.endEditing()
                } label: {
                    Text("Done")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(.chepicsPrimary))
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.gray)
                }
            }
        }
    }
}

#Preview {
    CreateCommentView(viewModel: CreateCommentViewModel(topicId: "", setId: "", parentId: "", type: .comment, replyFor: nil, createCommentUseCase: CreateCommentUseCase_Previews()))
}