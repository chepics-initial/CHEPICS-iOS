//
//  IconRegistrationView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/26.
//

import SwiftUI
import PhotosUI

struct IconRegistrationView<ViewModel: IconRegistrationViewModel>: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            HeaderView(colorScheme: colorScheme, title: "プロフィール画像設定", description: "プロフィール画像は後から編集することができます。")
            
            if let image = viewModel.profileImage {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 144, height: 144)
                    .clipShape(Circle())
            }
            
            PhotosPicker(selection: $viewModel.selectedItem, matching: .any(of: [.images, .not(.videos)])) {
                if viewModel.profileImage == nil {
                    ZStack(alignment: .bottomTrailing) {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 96, height: 96)
                            .foregroundStyle(.gray)
                            .padding(24)
                            .background {
                                Circle()
                                    .foregroundStyle(Color(.lightGray))
                            }
                            .padding(.horizontal)
                        
                        Image(systemName: "photo.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                            .foregroundStyle(.white)
                            .padding()
                            .background {
                                Circle()
                                    .foregroundStyle(Color(.chepicsPrimary))
                            }
                    }
                } else {
                    Text("画像の変更")
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
            }
            
            Spacer()
            
            RoundButton(text: "画像を登録", isActive: viewModel.profileImage != nil, type: .fill) {
                
            }
            
            RoundButton(text: "スキップ", isActive: true, type: .border) {
                
            }
        }
    }
}

#Preview {
    IconRegistrationView(viewModel: IconRegistrationViewModel_Previews())
}
