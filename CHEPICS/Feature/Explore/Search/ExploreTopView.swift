//
//  ExploreTopView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/04/16.
//

import SwiftUI
import SwiftUIIntrospect

struct ExploreTopView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var isFocused: Bool
    @StateObject var viewModel: ExploreTopViewModel
    @State private var isPresented = false
    
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
                        .onSubmit {
                            isPresented = true
                        }
                        .frame(maxWidth: .infinity)
                        .introspect(.textField, on: .iOS(.v16, .v17
                                                        )) { textField in
                            textField.enablesReturnKeyAutomatically = true
                        }
                    
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
                    Button {
                        isPresented = true
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
        .navigationDestination(isPresented: $isPresented) {
            ExploreResultView()
        }
    }
}

#Preview {
    ExploreTopView(viewModel: ExploreTopViewModel())
}
