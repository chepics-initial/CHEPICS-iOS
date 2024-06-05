//
//  IconRegistrationViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/26.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor final class IconRegistrationViewModel: ObservableObject {
    @Published private(set) var profileImage: UIImage?
    @Published private(set) var isLoading = false
    @Published var showAlert = false
    var selectedItem: PhotosPickerItem? {
        didSet { Task { await loadImage() } }
    }
    
    private let iconRegistrationUseCase: any IconRegistrationUseCase
    
    init(iconRegistrationUseCase: some IconRegistrationUseCase) {
        self.iconRegistrationUseCase = iconRegistrationUseCase
    }
    
    private func loadImage() async {
        guard let item = selectedItem else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        profileImage = UIImage(data: data)
    }
    
    func onTapSkipButton() {
        iconRegistrationUseCase.skip()
    }
    
    func onTapRegisterButton() async {
        guard let data = profileImage?.jpegData(compressionQuality: 0.8) else { return }
        isLoading = true
        let result = await iconRegistrationUseCase.registerIcon(image: data)
        isLoading = false
        switch result {
        case .success:
            return
        case .failure(let error):
            if case .errorResponse(let errorResponse, _) = error, errorResponse.errorCode == .INVALID_REFRESH_TOKEN {
                return
            }
            showAlert = true
        }
    }
}

final class IconRegistrationUseCase_Previews: IconRegistrationUseCase {
    func skip() {
    }
    
    func registerIcon(image: Data) async -> Result<Void, APIError> {
        .success(())
    }
}
