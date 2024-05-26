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
    @Published private(set) var profileImage: Image?
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
        guard let uiImage = UIImage(data: data) else { return }
        profileImage = Image(uiImage: uiImage)
    }
    
    func onTapSkipButton() {
        iconRegistrationUseCase.skip()
    }
}

final class IconRegistrationUseCase_Previews: IconRegistrationUseCase {
    func skip() {
        
    }
}
