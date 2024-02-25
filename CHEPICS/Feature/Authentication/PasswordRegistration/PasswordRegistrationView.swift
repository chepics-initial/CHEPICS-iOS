//
//  PasswordRegistrationView.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/02/25.
//

import SwiftUI

struct PasswordRegistrationView<ViewModel: PasswordRegistrationViewModel>: View {
    @Environment(\.viewModelProvider) var viewModelProvider
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HeaderView(colorScheme: colorScheme, title: "パスワード作成", description: "\(Constants.passwordCount)文字以上のパスワードを設定してください。")
            
            SecureField("Password", text: $viewModel.password)
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
            
            SecureField("Password", text: $viewModel.confirmPassword)
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
                viewModel.onTapButton()
            }
        }
        .ignoresSafeArea(.keyboard)
        .navigationDestination(isPresented: $viewModel.isPresented) {
            EmptyView()
        }
    }
}

#Preview {
    PasswordRegistrationView(viewModel: PasswordRegistrationViewModel_Previews())
}
