//
//  CreateTopicViewModel.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/09.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor protocol CreateTopicViewModel: ObservableObject {
    var isLoading: Bool { get }
    var title: String { get set }
    var description: String { get set }
    var link: String { get set }
    var selectedItems: [PhotosPickerItem] { get set }
    var selectedImages: [UIImage] { get }
    var isActive: Bool { get }
    func onTapSubmitButton() async
}

@MainActor final class CreateTopicViewModelImpl: CreateTopicViewModel {
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
    
    init() {
    }
    
    func onTapSubmitButton() async {
        isLoading = true
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        isLoading = false
    }
}

final class CreateTopicViewModel_Previews: CreateTopicViewModel {
    var isLoading: Bool = false
    var title: String = ""
    var description: String = ""
    var link: String = ""
    var isActive: Bool = true
    var selectedItems: [PhotosPickerItem] = []
    var selectedImages: [UIImage] = []
    func onTapSubmitButton() async {
        
    }
}
