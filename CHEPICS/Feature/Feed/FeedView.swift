//
//  FeedView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/04.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel: FeedViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showCreateTopicView = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                headerTab
                
                Spacer()
                
                listView
            }
            
            Button {
                showCreateTopicView = true
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.white)
                    .padding()
                    .background {
                        Circle()
                            .foregroundColor(.blue)
                    }
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showCreateTopicView, content: {
            NavigationStack {
                CreateTopicView(viewModel: CreateTopicViewModel())
            }
        })
    }
    
    private var headerTab: some View {
        HStack(spacing: 0) {
            ForEach(TabType.allCases, id: \.self) { type in
                Button {
                    viewModel.selectTab(type: type)
                } label: {
                    VStack {
                        Text(type.title)
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Rectangle()
                            .frame(height: 2)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(viewModel.selectedTab == type ? Color.getDefaultColor(for: colorScheme) : .gray)
                }

            }
        }
    }
    
    private var listView: some View {
        ScrollView {
            LazyVStack {
                switch viewModel.selectedTab {
                case .topics:
                    ForEach(0 ..< 20, id: \.self) { _ in
                        TopicCell()
                    }
                case .comments:
                    ForEach(0 ..< 20, id: \.self) { _ in
                        
                    }
                }
            }
        }
    }
}

#Preview {
    FeedView(viewModel: FeedViewModel())
}
