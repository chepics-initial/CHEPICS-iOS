//
//  OneTimeCodeView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/24.
//

import SwiftUI
import Combine

struct OneTimeCodeView<ViewModel: OneTimeCodeViewModel>: View {
    @Environment(\.viewModelProvider) var viewModelProvider
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: ViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HeaderView(colorScheme: colorScheme, title: "認証コードを入力", description: "\(viewModel.email)に送信された\(Constants.oneTimeCodeCount)桁のコードを入力してください。")
            
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
                        
                        Color.getDefaultColor(for: colorScheme)
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
            PasswordRegistrationView(viewModel: viewModelProvider!.passwordRegistrationViewModel())
        }
    }
}

#Preview {
    OneTimeCodeView(viewModel: OneTimeCodeViewModel_Previews())
}
