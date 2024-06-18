//
//  MyPageTopicListView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/05.
//

import SwiftUI

struct MyPageTopicListView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject var viewModel: MyPageTopicListViewModel
    
    var body: some View {
        VStack {
            switch viewModel.uiState {
            case .loading:
                LoadingView(showBackgroundColor: false)
            case .success:
                content
            case .failure:
                ScrollView {
                    ErrorView()
                }
                .refreshable {
                    Task { await viewModel.fetchSets() }
                }
            }
        }
        .onAppear {
            Task { await viewModel.onAppear() }
        }
        .navigationTitle("参加中のセット")
    }
    
    var content: some View {
        ScrollView {
            LazyVStack {
                if let sets = viewModel.sets {
                    // MARK: - 一時的にidをsetのidにした（おそらく複数同じsetIDのセルが並ぶことはないから問題ないはず）
                    ForEach(sets, id: \.set.id) { mySet in
                        Button {
                            router.items.append(.topicTop(topic: mySet.topic))
                        } label: {
                            MyPageTopicCell(set: mySet)
                        }
                    }
                    
                    FooterView(footerStatus: viewModel.footerStatus)
                        .onAppear {
                            Task { await viewModel.onAppearFooterView() }
                        }
                }
            }
        }
        .refreshable {
            Task { await viewModel.fetchSets() }
        }
    }
}

private struct MyPageTopicCell: View {
    @Environment(\.colorScheme) var colorScheme
    let set: MySet
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("topic")
                    .font(.headline)
                    .foregroundStyle(.chepicsPrimary)
                
                Spacer()
                
                Image(.orangePeople)
                
                Text("\(set.topic.votes)")
                    .font(.footnote)
                    .foregroundStyle(.chepicsPrimary)
            }
            
            Text(set.topic.title)
                .fontWeight(.semibold)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            
            HStack {
                Text("set")
                    .font(.headline)
                    .foregroundStyle(.blue)
                
                Spacer()
                
                Text("\(Int(set.set.rate))%")
                    .font(.footnote)
                    .foregroundStyle(.blue)
                    .padding(.trailing, 16)
                
                Image(.bluePeople)
                
                Text("\(set.set.votes)")
                    .font(.footnote)
                    .foregroundStyle(.blue)
            }
            
            Text("\(set.set.name)")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.blue)
                }
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(style: StrokeStyle())
                .foregroundStyle(.chepicsPrimary)
        }
        .padding()
    }
}

#Preview {
    MyPageTopicListView(viewModel: MyPageTopicListViewModel(myPageTopicListUseCase: MyPageTopicListUseCase_Previews()))
}
