//
//  CreateTopicView.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/09.
//

import SwiftUI
import PhotosUI

struct CreateTopicView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: CreateTopicViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 32) {
                    titleView
                    
                    descriptionView
                    
                    linkView
                    
                    imageView
                }
                .padding(.horizontal, 16)
            }
            
            Divider()
            
            RoundButton(text: "投稿", isActive: viewModel.isActive, type: .fill) {
                Task { await viewModel.onTapSubmitButton() }
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
            print("DEBUG: hello")
        }
        .overlay {
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .ignoresSafeArea(.keyboard)
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
        .navigationTitle("新規投稿")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var titleView: some View {
        VStack {
            HStack {
                Text("トピック")
                    .font(.headline)
                    .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                
                Text("必須")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(Color(.chepicsPrimary))
                    }
                
                Spacer()
            }
            
            CustomTextEditor(text: $viewModel.title, placeHolder: "トピックを入力")
                .focused($isFocused)
                .frame(maxWidth: .infinity)
            
            Color.gray
                .frame(height: 1)
            
            HStack(alignment: .bottom) {
                Spacer()
                
                Text("\(viewModel.title.count)")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(.chepicsPrimary))
                
                Text("/ \(Constants.topicTitleCount)")
                    .font(.caption)
                    .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            }
        }
    }
    
    private var categoryView: some View {
        VStack {
            HStack {
                Text("トピック")
                    .font(.headline)
                    .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                
                Text("必須（1つ以上）")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(Color(.chepicsPrimary))
                    }
                
                Spacer()
            }
        }
    }
    
    private var descriptionView: some View {
        VStack(alignment: .leading) {
            Text("説明")
                .font(.headline)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            
            CustomTextEditor(text: $viewModel.description, placeHolder: "説明を入力")
                .focused($isFocused)
                .frame(maxWidth: .infinity)
            
            Color.gray
                .frame(height: 1)
            
            HStack(alignment: .bottom) {
                Spacer()
                
                Text("\(viewModel.description.count)")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(.chepicsPrimary))
                
                Text("/ \(Constants.topicDescriptionCount)")
                    .font(.caption)
                    .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            }
        }
    }
    
    private var linkView: some View {
        VStack(alignment: .leading) {
            Text("リンク")
                .font(.headline)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            
            ZStack(alignment: .leading) {
                if viewModel.link.isEmpty {
                    Text("リンクを入力")
                        .font(.body)
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme).opacity(0.5))
                        .padding(.horizontal, 4)
                }
                
                TextField("", text: $viewModel.link)
                    .font(.body)
                    .focused($isFocused)
                    .foregroundStyle(.blue)
                    .opacity(viewModel.link.isEmpty ? 0.5 : 1)
                    .padding(.horizontal, 4)
            }
            
            Color.gray
                .frame(height: 1)
        }
    }
    
    private var imageView: some View {
        VStack(alignment: .leading) {
            Text("画像")
                .font(.headline)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.selectedImages, id: \.self) { image in
                        PhotosPicker(
                            selection: $viewModel.selectedItems,
                            maxSelectionCount: 4,
                            selectionBehavior: .ordered,
                            matching: .images
                        ) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(style: StrokeStyle())
                                        .foregroundStyle(.gray)
                                }
                        }
                    }
                    
                    if viewModel.selectedImages.count < Constants.topicImageCount {
                        PhotosPicker(
                            selection: $viewModel.selectedItems,
                            maxSelectionCount: 4,
                            selectionBehavior: .ordered,
                            matching: .images
                        ) {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32)
                                .foregroundStyle(.gray)
                                .padding()
                                .frame(width: 120, height: 120)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(style: StrokeStyle())
                                        .foregroundStyle(.gray)
                                }
                        }
                    }
                }
                .padding(1)
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    CreateTopicView(viewModel: CreateTopicViewModel())
}
