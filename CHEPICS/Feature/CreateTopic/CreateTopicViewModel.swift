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
    @Published private(set) var selectedImages: [UIImage] = []
    var isActive: Bool {
        isValidInput(title) && title.count <= Constants.topicTitleCount && description.count <= Constants.topicDescriptionCount && (link.isEmpty || isValidUrl(link))
    }
    
    private let createTopicUseCase: any CreateTopicUseCase
    
    init(createTopicUseCase: some CreateTopicUseCase) {
        self.createTopicUseCase = createTopicUseCase
    }
    
    func onTapSubmitButton() async {
        isLoading = true
        let result = await createTopicUseCase.createTopic(title: title)
        isLoading = false
        switch result {
        case .success(let success):
            return
        case .failure(let failure):
            print("DEBUG: error is \(failure.localizedDescription)")
        }
    }
}

final class CreateTopicUseCase_Previews: CreateTopicUseCase {
    func createTopic(title: String) async -> Result<Void, APIError> {
        .success(())
    }
}
