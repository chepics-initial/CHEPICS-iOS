//
//  PasswordRegistrationView.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/02/25.
//

import SwiftUI

struct PasswordRegistrationView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: PasswordRegistrationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HeaderView(colorScheme: colorScheme, title: "パスワード作成", description: "\(Constants.passwordCount)文字以上のパスワードを設定してください。")
            
            SecureField("8文字以上の半角英数字", text: $viewModel.password)
                .keyboardType(.emailAddress)
                .padding()
                .overlay {
                    Rectangle()
                        .stroke(style: StrokeStyle())
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                }
                .padding()
            
            Text("確認のため再度パスワードを入力してください。")
                .font(.footnote)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                .padding()
            
            SecureField("8文字以上の半角英数字", text: $viewModel.confirmPassword)
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
                Task { await viewModel.onTapButton() }
            }
        }
        .overlay {
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .networkError($viewModel.showAlert)
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $viewModel.isPresented) {
            NameRegistrationView(viewModel: NameRegistrationViewModel(nameRegistrationUseCase: DIFactory.nameRegistrationUseCase()))
        }
    }
}

#Preview {
    PasswordRegistrationView(viewModel: PasswordRegistrationViewModel(passwordRegistrationUseCase: PasswordRegistrationUseCase_Previews()))
}
