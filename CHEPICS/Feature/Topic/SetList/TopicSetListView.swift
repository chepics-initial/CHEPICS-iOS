//
//  TopicSetListView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/15.
//

import SwiftUI

struct TopicSetListView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: TopicSetListViewModel
    @State private var showCreateSetView = false
    @State private var showCommentView = false
    @State private var dismissView = false
    let onTapSelectButton: (PickSet) -> Void
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("set")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    switch viewModel.uiState {
                    case .loading:
                        LoadingView(showBackgroundColor: false)
                    case .success:
                        if let sets = viewModel.sets {
                            Text("あなたの意見をセットしてください")
                            
                            ForEach(sets) { pickSet in
                                setCell(set: pickSet) {
                                    showCommentView = true
                                }
                            }
                            
                            Button(action: {
                                showCreateSetView = true
                            }, label: {
                                Text("セットを追加する")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.blue)
                            })
                        }
                    case .failure:
                        VStack {
                            Text("通信に失敗しました。インターネット環境を確認して、もう一度お試しください。")
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(16)
                            
                            Spacer()
                        }
                    }
                }
                .padding(16)
            }
            
            Divider()
            
            RoundButton(text: "選択する", isActive: viewModel.isActive, type: .fill) {
                if let set = viewModel.selectedSet {
                    onTapSelectButton(set)
                }
            }
        }
        .navigationDestination(isPresented: $showCommentView, destination: {
            SetCommentView(dismissView: $dismissView)
        })
        .fullScreenCover(isPresented: $showCreateSetView, content: {
            NavigationStack {
                CreateSetView(viewModel: CreateSetViewModel(topicId: viewModel.topicId, createSetUseCase: DIFactory.createSetUseCase())) {
                    Task { await viewModel.fetchSets() }
                }
            }
        })
        .onChange(of: dismissView, perform: { newValue in
            if newValue {
                dismiss()
            }
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    dismissView = true
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.gray)
                })
            }
        }
        .onAppear {
            Task { await viewModel.fetchSets() }
        }
    }
    
    private func setCell(set: PickSet, onTapCommentButton: @escaping() -> Void) -> some View {
        VStack {
            HStack {
                Text(set.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                
                Spacer()
                
                Button {
                    onTapCommentButton()
                } label: {
                    VStack {
                        Image(systemName: "text.bubble.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        
                        Text("\(set.commentCount)件")
                            .font(.caption2)
                    }
                    .foregroundStyle(.blue)
                }

            }
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: getRect().width - 64, height: 32)
                    .foregroundStyle(.clear)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(style: StrokeStyle())
                            .foregroundStyle(.blue)
                    }
                
                // 両サイドのpaddingを計算してwidthをつける
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: (getRect().width - 64) * 0.95, height: 32)
                    .foregroundStyle(.blue)
                
                HStack {
                    Spacer()
                    
                    Text("95%")
                        .font(.caption)
                        .foregroundStyle(.blue)
                        .padding(2)
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .padding(.trailing, 4)
                }
            }
        }
        .padding(16)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(style: StrokeStyle())
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    TopicSetListView(viewModel: TopicSetListViewModel(topicId: "", topicSetListUseCase: TopicSetListUseCase_Previews()), onTapSelectButton: {_ in})
}
