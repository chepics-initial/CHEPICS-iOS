//
//  CreateTopicViewModel.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/09.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor final class CreateTopicViewModel: ObservableObject {
    @Published private(set) var isLoading: Bool = false
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var link: String = ""
    @Published private(set) var isCompleted = false
    @Published var showAlert = false
    @Published private(set) var selectedImages: [UIImage] = []
    @Published var selectedItems: [PhotosPickerItem] = [] {
        didSet {
            Task {
                selectedImages = []
                
                for item in selectedItems {
                    guard let data = try? await item.loadTransferable(type: Data.self) else { return }
                    guard let image = UIImage(data: data) else { return }
                    selectedImages.append(image)
                }
            }
        }
    }
    var isActive: Bool {
        isValidInput(title) && title.count <= Constants.topicTitleCount && description.count <= Constants.topicDescriptionCount && (link.isEmpty || isValidUrl(link))
    }
    
    private let createTopicUseCase: any CreateTopicUseCase
    
    init(createTopicUseCase: some CreateTopicUseCase) {
        self.createTopicUseCase = createTopicUseCase
    }
    
    func onTapSubmitButton() async {
        isLoading = true
        var imageData = [Data]()
        for image in selectedImages {
            guard let data = image.jpegData(compressionQuality: 0.8) else {
                isLoading = false
                return
            }
            imageData.append(data)
        }
        let result = await createTopicUseCase.createTopic(title: title, link: link, description: isValidInput(description) ? description : nil, images: imageData.isEmpty ? nil : imageData)
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
}

final class CreateTopicUseCase_Previews: CreateTopicUseCase {
    func createTopic(title: String, link: String?, description: String?, images: [Data]?) async -> Result<Void, APIError> {
        .success(())
    }
}
