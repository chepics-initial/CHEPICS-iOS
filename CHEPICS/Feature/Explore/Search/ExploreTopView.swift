//
//  ExploreTopView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/16.
//

import SwiftUI

struct ExploreTopView: View {
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool
    @StateObject var viewModel: ExploreTopViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.gray)
                })
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.gray)
                    
                    TextField("検索", text: $viewModel.searchText)
                        .focused($isFocused)
                        .submitLabel(.search)
                        .frame(maxWidth: .infinity)
                    
                    if !viewModel.searchText.isEmpty {
                        Button(action: {
                            viewModel.onTapDeleteButton()
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(.gray)
                        })
                    }
                }
                .padding(8)
                .background {
                    Capsule(style: .circular)
                        .foregroundStyle(.gray.opacity(0.2))
                }
            }
            .padding(.horizontal, 16)
            
            if !viewModel.searchText.isEmpty {
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(.chepicsPrimary)
                        
                        Text(viewModel.searchText)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        
                        Text("を検索")
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    Divider()
                }
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            isFocused = true
        }
    }
}

#Preview {
    ExploreTopView(viewModel: ExploreTopViewModel())
}
