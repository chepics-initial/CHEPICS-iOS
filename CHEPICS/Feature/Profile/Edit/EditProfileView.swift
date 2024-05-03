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
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: EditProfileViewModel
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    ZStack(alignment: .bottomTrailing) {
                        if let profileImage = viewModel.profileImage {
                            profileImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 96, height: 96)
                                .clipShape(Circle())
                        } else if let profileImageUrl = viewModel.profileImageUrl {
                            KFImage(URL(string: profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 96, height: 96)
                                .clipShape(Circle())
                        } else {
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
                            
                        }
                        
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
                    
                    usernameView
                    
                    fullnameView
                    
                    bioView
                }
                Divider()
                
                RoundButton(text: "保存", isActive: viewModel.isActive, type: .fill) {
                    Task { await viewModel.onTapSaveButton() }
                }
            }
        }
        .navigationTitle("プロフィール編集")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.gray)
                }

            }
        }
    }
    
    private var usernameView: some View {
        VStack {
            Text("ユーザー名")
                .font(.headline)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            
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
    
    private var fullnameView: some View {
        VStack {
            Text("表示名")
                .font(.headline)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            
            CustomTextEditor(text: $viewModel.fullname, placeHolder: "表示名を入力")
                .frame(maxWidth: .infinity)
            
            Color.gray
                .frame(height: 1)
            
            HStack(alignment: .bottom) {
                Spacer()
                
                Text("\(viewModel.fullname.count)")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(.chepicsPrimary))
                
                Text("/ \(Constants.nameCount)")
                    .font(.caption)
                    .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            }
        }
    }
    
    private var bioView: some View {
        VStack {
            Text("自己紹介")
                .font(.headline)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            
            CustomTextEditor(text: $viewModel.bio, placeHolder: "自己紹介を入力")
                .frame(maxWidth: .infinity)
            
            Color.gray
                .frame(height: 1)
            
            HStack(alignment: .bottom) {
                Spacer()
                
                Text("\(viewModel.bio.count)")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(.chepicsPrimary))
                
                Text("/ \(Constants.bioCount)")
                    .font(.caption)
                    .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            }
        }
    }
}

#Preview {
    EditProfileView(viewModel: EditProfileViewModel(user: mockUser1))
}
