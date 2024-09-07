//
//  MyPageTopView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/03.
//

import SwiftUI

struct MyPageTopView: View {
    @EnvironmentObject var myPageRouter: NavigationRouter
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: MyPageTopViewModel
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: 32) {
            Button {
                if let user = viewModel.user {
                    myPageRouter.items.append(.profile(user: user))
                }
            } label: {
                HStack {
                    UserIconView(url: viewModel.uiModel?.profileImageUrl, scale: .profile)
                    
                    if let uiModel = viewModel.uiModel {
                        VStack(alignment: .leading) {
                            Text(uiModel.fullname)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                            
                            Text("@\(uiModel.username)")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.forward")
                        .foregroundStyle(.gray)
                }
            }
            
            
            Button(action: {
                myPageRouter.items.append(.myPageTopicList)
            }, label: {
                HStack {
                    Text("参加中のセット一覧")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.forward")
                        .foregroundStyle(.gray)
                }
            })
            
            Button(action: {
                showAlert = true
            }, label: {
                Text("ログアウト")
                    .fontWeight(.semibold)
                    .foregroundStyle(.chepicsPrimary)
            })
            
            Spacer()
            
            // MARK: - 仮のユーザー削除ボタン
            Text("※同じメールアドレスで起動処理をデバッグするためのユーザー削除 ↓")
                .font(.caption2)
                .foregroundStyle(.gray)
            Button {
                Task { await viewModel.onTapDeleteButton() }
            } label: {
                Text("ユーザー削除")
                    .fontWeight(.bold)
                    .foregroundStyle(.red)
            }
            
        }
        .padding()
        .onAppear {
            Task { await viewModel.onAppear() }
        }
        .alert("ログアウトしますか？", isPresented: $showAlert) {
            Button(role: .cancel) {
                
            } label: {
                Text("キャンセル")
            }
            
            Button(action: {
                viewModel.logout()
            }, label: {
                Text("ログアウト")
            })
        }
        .navigationDestination(for: NavigationRouter.Item.self) { value in
            switch value {
            case .exploreTop:
                ExploreTopView(viewModel: ExploreTopViewModel())
            case .exploreResult(searchText: _):
                EmptyView()
            case .profile(user: let user):
                ProfileView(viewModel: ProfileViewModel(user: user, profileUseCase: DIFactory.profileUseCase()))
            case .myPageTopicList:
                MyPageTopicListView(viewModel: MyPageTopicListViewModel(myPageTopicListUseCase: DIFactory.myPageTopicListUseCase()))
            case .comment(commentId: let commentId, comment: let comment, showTopicTitle: let showTopicTitle):
                CommentDetailView(viewModel: CommentDetailViewModel(commentId: commentId, comment: comment, commentDetailUseCase: DIFactory.commentDetailUseCase()), isTopicTitleEnabled: showTopicTitle)
            case .topicTop(topicId: let topicId, topic: let topic):
                TopicTopView(viewModel: TopicTopViewModel(topicId: topicId, topic: topic, topicTopUseCase: DIFactory.topicTopUseCase()))
            case .topicDetail(topic: let topic):
                TopicDetailView(topic: topic)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MyPageTopView(viewModel: MyPageTopViewModel(myPageTopUseCase: MyPageTopUseCase_Previews()))
}
