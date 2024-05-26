//
//  NameRegistrationView.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/02/25.
//

import SwiftUI

struct NameRegistrationView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: NameRegistrationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderView(colorScheme: colorScheme, title: "基本設定", description: "ユーザー名と表示名は後から編集することができます。")
            
            Text("ユーザー名")
                .font(.headline)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                .padding()
            
            Text("半角英数字でユーザー名を設定してください。")
                .font(.footnote)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                .padding(.horizontal)
            
            Text("ユーザー名は一意である必要があります。")
                .font(.footnote)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                .padding(.horizontal)

            TextField("ユーザー名を入力", text: $viewModel.username)
                .padding()
                .overlay {
                    Rectangle()
                        .stroke(style: StrokeStyle())
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                }
                .padding(.horizontal)
            
            HStack(spacing: 0) {
                Spacer()
                
                Text("\(viewModel.username.count)")
                    .foregroundStyle(viewModel.username.count > Constants.nameCount ? .red : Color.getDefaultColor(for: colorScheme))
                
                Text("/30")
                    .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            }
            .font(.caption2)
            .padding(.horizontal)
            
            Text("表示名")
                .font(.headline)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                .padding()
            
            Text("サービス内で表示される名前を設定してください。")
                .font(.footnote)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                .padding(.horizontal)
            
            TextField("表示名を入力", text: $viewModel.fullname)
                .padding()
                .overlay {
                    Rectangle()
                        .stroke(style: StrokeStyle())
                        .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                }
                .padding(.horizontal)
            
            HStack(spacing: 0) {
                Spacer()
                
                Text("\(viewModel.fullname.count)")
                    .foregroundStyle(viewModel.fullname.count > Constants.nameCount ? .red : Color.getDefaultColor(for: colorScheme))
                
                Text("/30")
                    .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            }
            .font(.caption2)
            .padding(.horizontal)
            
            Spacer()
            
            RoundButton(text: "登録する", isActive: viewModel.isActive, type: .fill) {
                Task { await viewModel.onTapButton() }
            }
        }
        .ignoresSafeArea(.keyboard)
        .overlay {
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .navigationDestination(isPresented: $viewModel.isPresented, destination: {
            CompleteRegistrationView(viewModel: CompleteRegistrationViewModel(completeRegistrationUseCase: DIFactory.completeRegistrationUseCase()))
        })
        .alert("このユーザー名は使用されています", isPresented: $viewModel.showAlert) {
            Button {
                
            } label: {
                Text("OK")
            }

        } message: {
            Text("他のユーザー名を設定してください")
        }

    }
}

#Preview {
    NameRegistrationView(viewModel: NameRegistrationViewModel(nameRegistrationUseCase: NameRegistrationUseCase_Previews()))
}
