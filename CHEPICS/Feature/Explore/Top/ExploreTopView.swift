//
//  ExploreTopView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/16.
//

import SwiftUI
import SwiftUIIntrospect

struct ExploreTopView: View {
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    @EnvironmentObject var router: NavigationRouter
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var isFocused: Bool
    @StateObject var viewModel: ExploreTopViewModel
    
    var body: some View {
        VStack {
            SearchTextField(searchText: $viewModel.searchText, textField: {
                TextField("検索", text: $viewModel.searchText)
                    .focused($isFocused)
                    .submitLabel(.search)
                    .onSubmit {
                        router.items.append(.exploreResult(searchText: viewModel.searchText))
                    }
                    .frame(maxWidth: .infinity)
                    .introspect(.textField, on: .iOS(.v16, .v17
                                                    )) { textField in
                        textField.enablesReturnKeyAutomatically = true
                    }
            }, onProgress: true, onTapBackButton: {
                dismiss()
            }, onTapDeleteButton: {
                viewModel.onTapDeleteButton()
            })
            
            if !viewModel.searchText.isEmpty {
                VStack {
                    Button {
                        router.items.append(.exploreResult(searchText: viewModel.searchText))
                    } label: {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(.chepicsPrimary)
                            
                            Text(viewModel.searchText)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                            
                            Text("を検索")
                                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                    
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
