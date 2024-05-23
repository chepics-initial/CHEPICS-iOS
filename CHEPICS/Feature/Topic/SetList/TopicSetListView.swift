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
    @State private var showConfirmAlert = false
    @State private var showCommentSet: PickSet?
    let completion: (PickSet) -> Void
    
    var body: some View {
        ZStack {
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
                                Text("セットを選択してください")
                                
                                LazyVStack {
                                    ForEach(sets) { pickSet in
                                        Button {
                                            viewModel.selectSet(set: pickSet)
                                        } label: {
                                            SetCell(currentSet: viewModel.currentSet, set: pickSet, isSelected: pickSet.id == viewModel.selectedSet?.id) {
                                                showCommentSet = pickSet
                                                showCommentView = true
                                            }
                                        }
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
                            ErrorView()
                        }
                    }
                    .padding(16)
                }
                
                Divider()
                
                RoundButton(text: "選択する", isActive: viewModel.isActive, type: .fill) {
                    if viewModel.isActive && viewModel.currentSet != nil {
                        showConfirmAlert = true
                    } else {
                        Task {
                            await viewModel.onTapSelectButton()
                            if viewModel.isCompleted, let set = viewModel.selectedSet {
                                completion(set)
                                dismiss()
                            }
                        }
                    }
                }
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .navigationDestination(isPresented: $showCommentView, destination: {
            if let showCommentSet {
                SetCommentView(viewModel: SetCommentViewModel(set: showCommentSet, setCommentUseCase: DIFactory.setCommentUseCase()), dismissView: $dismissView)
            }
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
        .alert("このセットを選択しますか？", isPresented: $showConfirmAlert, actions: {
            Button {
            } label: {
                Text("キャンセル")
            }
            
            Button {
                Task {
                    await viewModel.onTapSelectButton()
                    if viewModel.isCompleted, let set = viewModel.selectedSet {
                        completion(set)
                        dismiss()
                    }
                }
            } label: {
                Text("選択する")
            }
        }, message: {
            Text("既に他のセットを選択しているため、そのセット内で行ったコメントやいいねは削除されます。")
        })
        .alert("通信エラー", isPresented: $viewModel.showAlert, actions: {
            Button {
            } label: {
                Text("OK")
            }
        }, message: {
            Text("インターネット環境を確認して、もう一度お試しください。")
        })
    }
}

private struct SetCell: View {
    @Environment(\.colorScheme) var colorScheme
    let currentSet: PickSet?
    let set: PickSet
    let isSelected: Bool
    let onTapCommentButton: () -> Void
    
    var body: some View {
        VStack {
            if let currentSet, currentSet.id == set.id {
                HStack {
                    Text("参加中")
                        .font(.footnote)
                        .foregroundStyle(.white)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background {
                            Capsule(style: .circular)
                                .foregroundStyle(.chepicsPrimary)
                        }
                    
                    Spacer()
                }
            }
            
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
            
            HStack(spacing: 4) {
                Image(.blackPeople)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16)
                
                Text("\(set.votes)")
                    .font(.footnote)
                
                Spacer()
            }
            .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: getRect().width - 64, height: 32)
                    .foregroundStyle(.white)
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
        .background(isSelected ? .blue.opacity(0.4) : .clear)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(style: StrokeStyle(lineWidth: isSelected ? 2 : 1))
                .foregroundStyle(isSelected ? .blue : .gray)
        }
    }
}

#Preview {
    TopicSetListView(viewModel: TopicSetListViewModel(topicId: "", currentSet: nil, topicSetListUseCase: TopicSetListUseCase_Previews()), completion: {_ in})
}
