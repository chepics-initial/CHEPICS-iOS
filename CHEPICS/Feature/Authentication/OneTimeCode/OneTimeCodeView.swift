//
//  OneTimeCodeView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/24.
//

import SwiftUI
import Combine

struct OneTimeCodeView<ViewModel: OneTimeCodeViewModel>: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: ViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Text("認証コードを入力")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            Text("\(viewModel.email)に送信された\(Constants.oneTimeCodeCount)桁のコードを入力してください。")
                .font(.footnote)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                .padding()
            
            TextField("", text: $viewModel.code)
                .keyboardType(.numberPad)
                .focused($isFocused)
                .frame(width: 0, height: 0)
                .onReceive(Just(viewModel.code)) { _ in
                    if viewModel.code.count > Constants.oneTimeCodeCount {
                        viewModel.code = String(viewModel.code.prefix(Constants.oneTimeCodeCount))
                    }
                }
            
            HStack {
                ForEach(0 ..< Constants.oneTimeCodeCount, id: \.self) { index in
                    VStack {
                        Text(viewModel.getCodeIndex(index: index))
                            .font(.body)
                            .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                            .frame(height: 40)
                        
                        Color.black
                            .frame(maxWidth: .infinity)
                            .frame(height: 4)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            }
            .padding()
            
            Button {
                
            } label: {
                Text("コードを再送信")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(style: StrokeStyle())
                            .foregroundStyle(.gray)
                    }
            }
            
            Spacer()
            
            RoundButton(text: "次へ", isActive: viewModel.isActive, type: .fill) {
                isFocused = false
                Task { await viewModel.onTapNextButton() }
            }
        }
        .didAppear {
            isFocused = true
        }
        .overlay {
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .alert("エラー", isPresented: $viewModel.showFailureAlert, actions: {
            Button {
                isFocused = true
            } label: {
                Text("OK")
            }

        })
        .navigationDestination(isPresented: $viewModel.isPresented) {
            EmptyView()
        }
    }
}

#Preview {
    OneTimeCodeView(viewModel: OneTimeCodeViewModel_Previews())
}
