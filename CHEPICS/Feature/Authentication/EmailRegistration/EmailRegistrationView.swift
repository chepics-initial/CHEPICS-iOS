//
//  EmailRegistrationView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/24.
//

import SwiftUI

struct EmailRegistrationView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: EmailRegistrationViewModel
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
            OneTimeCodeView(viewModel: OneTimeCodeViewModel(email: viewModel.email, oneTimeCodeUseCase: DIFactory.oneTimeCodeUseCase()))
        }
        .networkError($viewModel.showAlert, closeAction: {
            isFocused = true
        })
        .alert("すでに使用されているメールアドレスです", isPresented: $viewModel.showAlreadyAlert) {
            Button {
                isFocused = true
            } label: {
                Text("OK")
            }
        }
    }
}

#Preview {
    EmailRegistrationView(viewModel: EmailRegistrationViewModel(emailRegistrationUseCase: EmailRegistrationUseCase_Previews()))
}
