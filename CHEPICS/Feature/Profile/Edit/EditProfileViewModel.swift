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
    @Published private(set) var isActive: Bool = true
    @Published var username: String
    @Published var fullname: String
    @Published var bio: String = ""
    @Published private(set) var profileImage: Image?
    var selectedItem: PhotosPickerItem? {
        didSet { Task { await loadImage() } }
    }
    let profileImageUrl: String?

    
    init(user: User) {
        profileImageUrl = user.profileImageUrl
        username = user.username
        fullname = user.fullname
        if let bio = user.bio {
            self.bio = bio
        }
    }
    
    func onTapSaveButton() async {
        
    }
    
    private func loadImage() async {
        guard let item = selectedItem else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        profileImage = Image(uiImage: uiImage)
    }
}
