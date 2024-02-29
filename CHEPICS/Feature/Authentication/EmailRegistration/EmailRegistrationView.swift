//
//  EmailRegistrationView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/24.
//

import SwiftUI

struct EmailRegistrationView<ViewModel: EmailRegistrationViewModel>: View {
    @Environment(\.viewModelProvider) var viewModelProvider
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: ViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HeaderView(colorScheme: colorScheme, title: "メールアドレス登録", description: "ログイン時に使用するメールアドレスを入力してください")

            TextField("メールアドレスを入力", text: $viewModel.email)
                .focused($isFocused)
                .keyboardType(.emailAddress)
                .padding()
                .overlay {
                    Rectangle()
                        .stroke(style: StrokeStyle())
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                }
                .padding()
            
            Spacer()
            
            RoundButton(text: "次へ", isActive: viewModel.isActive, type: .fill) {
                isFocused = false
                Task { await viewModel.onTapButton() }
            }
        }
        .overlay {
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .navigationDestination(isPresented: $viewModel.isPresented) {
            OneTimeCodeView(viewModel: viewModelProvider!.oneTimeCodeViewModel(email: viewModel.email))
        }
        .alert("エラー", isPresented: $viewModel.showAlert) {
            Button {
                
            } label: {
                Text("OK")
            }
        }
    }
}

#Preview {
    EmailRegistrationView(viewModel: EmailRegistrationViewModel_Previews())
}
