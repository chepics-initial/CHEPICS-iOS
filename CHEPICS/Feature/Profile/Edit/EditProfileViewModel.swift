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
    @Published private(set) var isCompleted = false
    @Published private(set) var profileImage: Image?
    @Published private(set) var profileImageUrl: String?
    var selectedItem: PhotosPickerItem? {
        didSet { Task { await loadImage() } }
    }
    var isActive: Bool {
        !username.isEmpty && !fullname.isEmpty && username.count <= Constants.nameCount && fullname.count <= Constants.nameCount
    }
    private let user: User

    
    init(user: User) {
        self.user = user
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
        isCompleted = true
    }
    
    private func loadImage() async {
        guard let item = selectedItem else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        profileImage = Image(uiImage: uiImage)
    }
}
