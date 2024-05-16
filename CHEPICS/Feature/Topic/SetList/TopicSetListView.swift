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
                    
                    Text("あなたの意見をセットしてください")
                    
                    ForEach(0..<4, id: \.self) { _ in
                        setCell {
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
                .padding(16)
            }
            
            Divider()
            
            RoundButton(text: "選択する", isActive: viewModel.isActive, type: .fill) {
                if let set = viewModel.set {
                    onTapSelectButton(set)
                }
            }
        }
        .navigationDestination(isPresented: $showCommentView, destination: {
            SetCommentView(dismissView: $dismissView)
        })
        .fullScreenCover(isPresented: $showCreateSetView, content: {
            NavigationStack {
                CreateSetView(viewModel: CreateSetViewModel(topicId: viewModel.topicId))
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
    }
    
    private func setCell(onTapCommentButton: @escaping() -> Void) -> some View {
        VStack {
            HStack {
                Text("猫は可愛い")
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
                        
                        Text("500件")
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
    TopicSetListView(viewModel: TopicSetListViewModel(topicId: ""), onTapSelectButton: {_ in})
}