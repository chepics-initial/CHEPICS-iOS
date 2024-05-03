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
        return isValidInput(title) && title.count <= Constants.topicTitleCount && description.count <= Constants.topicDescriptionCount && (link.isEmpty || isValidUrl(link))
    }
    
    private let createTopicUseCase: any CreateTopicUseCase
    
    init(createTopicUseCase: some CreateTopicUseCase) {
        self.createTopicUseCase = createTopicUseCase
    }
    
    func onTapSubmitButton() async {
        isLoading = true
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        isLoading = false
    }
}

final class CreateTopicUseCase_Previews: CreateTopicUseCase {
}
