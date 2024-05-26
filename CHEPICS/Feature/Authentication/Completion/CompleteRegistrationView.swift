//
//  CompleteRegistrationView.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/02/25.
//

import SwiftUI

struct CompleteRegistrationView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: CompleteRegistrationViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("アカウント登録が完了しました！")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            
            Spacer()
            
            NavigationLink {
                IconRegistrationView(viewModel: IconRegistrationViewModel(iconRegistrationUseCase: DIFactory.iconRegistrationUseCase()))
            } label: {
                RoundButtonContentView(text: "プロフィール画像を設定", isActive: true, type: .fill)
            }
            
            RoundButton(text: "スキップ", isActive: true, type: .border) {
                viewModel.onTapSkipButton()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    CompleteRegistrationView(viewModel: CompleteRegistrationViewModel(completeRegistrationUseCase: CompleteRegistrationUseCase_Previews()))
}
