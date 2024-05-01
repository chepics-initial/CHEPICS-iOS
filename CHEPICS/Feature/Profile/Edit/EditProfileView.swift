//
//  EditProfileView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/01.
//

import SwiftUI
import Kingfisher

struct EditProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: EditProfileViewModel
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
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
                }
                Divider()
                
                RoundButton(text: "投稿", isActive: viewModel.isActive, type: .fill) {
                    Task { await viewModel.onTapSaveButton() }
                }
            }
        }
        .navigationTitle("プロフィール編集")
    }
    
    private var userView: some View {
        VStack {
            HStack {
                Text("ユーザー名")
                    .font(.headline)
                    .foregroundStyle(Color.getDefaultColor(for: colorScheme))
                
                Text("必須")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(Color(.chepicsPrimary))
                    }
                
                Spacer()
            }
            
            CustomTextEditor(text: $viewModel.username, placeHolder: "ユーザー名を入力")
                .frame(maxWidth: .infinity)
            
            Color.gray
                .frame(height: 1)
            
            HStack(alignment: .bottom) {
                Spacer()
                
                Text("\(viewModel.username.count)")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(.chepicsPrimary))
                
                Text("/ \(Constants.nameCount)")
                    .font(.caption)
                    .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            }
        }
    }
}

#Preview {
    EditProfileView(viewModel: EditProfileViewModel(user: mockUser1))
}
