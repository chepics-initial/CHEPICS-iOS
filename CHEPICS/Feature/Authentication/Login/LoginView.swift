//
//  LoginView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/21.
//

import SwiftUI

struct LoginView<ViewModel: LoginViewModel>: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("メールアドレスを入力", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .padding()
                .overlay {
                    Rectangle()
                        .stroke(style: StrokeStyle())
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                }
                .padding()
            
            SecureField("パスワードを入力", text: $viewModel.password)
                .padding()
                .overlay {
                    Rectangle()
                        .stroke(style: StrokeStyle())
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                }
                .padding()
            
//            HStack {
//                Spacer()
//                
//                Button(action: {}, label: {
//                    Text("パスワードを忘れた方はこちら")
//                        .font(.caption2)
//                        .foregroundStyle(Color(.chepicsPrimary))
//                })
//            }
//            .padding()
            
            Spacer()
            
            RoundButton(text: "ログイン", isActive: viewModel.loginButtonIsActive, type: .fill) {
                Task { await viewModel.onTapLoginButton() }
            }
            .padding(.bottom, 24)
            
            Text("アカウントを持っていない場合")
                .font(.caption)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))

            NavigationLink {
                EmailRegistrationView(viewModel: EmailRegistrationViewModel(emailRegistrationUseCase: DIFactory.emailRegistrationUseCase()))
            } label: {
                RoundButtonContentView(text: "新規登録", isActive: true, type: .border)
            }
        }
        .ignoresSafeArea(.keyboard)
        .overlay {
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .networkError($viewModel.showAlert)
        .alert("ログインに失敗しました", isPresented: $viewModel.showInvalidAlert, actions: {
            Button {
            } label: {
                Text("OK")
            }
        }, message: {
            Text("メールアドレスとパスワードが正しいことを確認してください")
        })
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(loginUseCase: LoginUseCase_Previews()))
}
