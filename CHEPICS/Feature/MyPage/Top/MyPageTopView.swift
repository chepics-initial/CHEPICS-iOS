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
                    UserIconView(url: viewModel.user?.profileImageUrl, scale: .profile)
                    
                    if let user = viewModel.user {
                        VStack(alignment: .leading) {
                            Text(user.fullname)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                            
                            Text("@\(user.username)")
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
                MyPageTopicListView()
            case .comment(comment: let comment):
                CommentDetailView(viewModel: CommentDetailViewModel(comment: comment))
            case .topicTop(topic: let topic):
                TopicTopView(viewModel: TopicTopViewModel(topic: topic, topicTopUseCase: DIFactory.topicTopUseCase()))
            case .topicDetail(topic: let topic):
                TopicDetailView(topic: topic)
            }
        }
    }
}

#Preview {
    MyPageTopView(viewModel: MyPageTopViewModel(myPageTopUseCase: MyPageTopUseCase_Previews()))
}
