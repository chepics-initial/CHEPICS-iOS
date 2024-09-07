//
//  EditProfileView.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/01.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct EditProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: EditProfileViewModel
    let completion: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    PhotosPicker(selection: $viewModel.selectedItem, matching: .any(of: [.images, .not(.videos)])) {
                        ZStack(alignment: .bottomTrailing) {
                            if let profileImage = viewModel.profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 144, height: 144)
                                    .clipShape(Circle())
                            } else if let profileImageUrl = viewModel.profileImageUrl {
                                KFImage(URL(string: profileImageUrl))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 144, height: 144)
                                    .clipShape(Circle())
                                    .background {
                                        Circle()
                                            .foregroundStyle(Color(.lightGray))
                                    }
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
                                .padding(.trailing, -16)
                        }
                    }
                    
                    VStack {
                        usernameView
                        
                        fullnameView
                        
                        bioView
                    }
                    .padding()
                }
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
                
                Divider()
                
                RoundButton(text: "保存", isActive: viewModel.isActive, type: .fill) {
                    Task {
                        UIApplication.shared.endEditing()
                        await viewModel.onTapSaveButton()
                        if viewModel.isCompleted {
                            completion()
                            dismiss()
                        }
                    }
                }
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .networkError($viewModel.showAlert)
        .alert("このユーザー名はすでに使用されています", isPresented: $viewModel.showUniqueAlert) {
            Button {
            } label: {
                Text("OK")
            }
        }
        .navigationTitle("プロフィール編集")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.onAppear()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    UIApplication.shared.endEditing()
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.gray)
                }
            }
            
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button {
                    UIApplication.shared.endEditing()
                } label: {
                    Text("Done")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(.chepicsPrimary))
                }
            }
        }
    }
    
    private var usernameView: some View {
        VStack(alignment: .leading) {
            Text("ユーザー名")
                .font(.headline)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            
            TextField("ユーザー名を入力", text: $viewModel.username)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
            
            Color.gray
                .frame(height: 1)
            
            HStack(alignment: .bottom) {
                Spacer()
                
                Text("\(viewModel.username.count)")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                Text("/ \(Constants.nameCount)")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
    }
    
    private var fullnameView: some View {
        VStack(alignment: .leading) {
            Text("表示名")
                .font(.headline)
                .foregroundStyle(Color.getDefaultColor(for: colorScheme))
            
            TextField("表示名を入力", text: $viewModel.fullname)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
            
            Color.gray
                .frame(height: 1)
            
            HStack(alignment: .bottom) {
                Spacer()
                
                Text("\(viewModel.fullname.count)")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                Text("/ \(Constants.nameCount)")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
    }
    
    private var bioView: some View {
        VStack(alignment: .leading) {
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
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                Text("/ \(Constants.bioCount)")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    EditProfileView(viewModel: EditProfileViewModel(user: mockUser1, editProfileUseCase: EditProfileUseCase_Previews()), completion: {})
}
