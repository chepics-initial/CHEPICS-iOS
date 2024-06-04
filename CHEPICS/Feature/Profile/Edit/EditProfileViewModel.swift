//
//  EditProfileViewModel.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/05/01.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor final class EditProfileViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var fullname: String = ""
    @Published var bio: String = ""
    @Published var showAlert = false
    @Published private(set) var isLoading = false
    @Published private(set) var isCompleted = false
    @Published private(set) var profileImage: UIImage?
    @Published private(set) var profileImageUrl: String?
    var selectedItem: PhotosPickerItem? {
        didSet { Task { await loadImage() } }
    }
    var isActive: Bool {
        !username.isEmpty && !fullname.isEmpty && username.count <= Constants.nameCount && fullname.count <= Constants.nameCount
    }
    private let user: User
    private let editProfileUseCase: any EditProfileUseCase
    
    init(user: User, editProfileUseCase: some EditProfileUseCase) {
        self.user = user
        self.editProfileUseCase = editProfileUseCase
    }
    
    func onAppear() {
        profileImageUrl = user.profileImageUrl
        username = user.username
        fullname = user.fullname
        if let bio = user.bio {
            self.bio = bio
        }
    }
    
    func onTapSaveButton() async {
        isLoading = true
        var imageData: Data?
        if let profileImage {
            guard let data = profileImage.jpegData(compressionQuality: 0.8) else {
                isLoading = false
                return
            }
            imageData = data
        }
        let result = await editProfileUseCase.updateUser(username: username, fullname: fullname, bio: !bio.isEmpty ? bio : nil, image: imageData)
        isLoading = false
        switch result {
        case .success:
            isCompleted = true
        case .failure(let error):
            if case .errorResponse(let errorResponse, _) = error, errorResponse.errorCode == .INVALID_REFRESH_TOKEN {
                return
            }
            showAlert = true
        }
    }
    
    private func loadImage() async {
        guard let item = selectedItem else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        profileImage = UIImage(data: data)
    }
}

final class EditProfileUseCase_Previews: EditProfileUseCase {
    func updateUser(username: String, fullname: String, bio: String?, image: Data?) async -> Result<Void, APIError> {
        .success(())
    }
}
