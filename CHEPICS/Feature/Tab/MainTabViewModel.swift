//
//  MainTabViewModel.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/21.
//

import Foundation

final class MainTabViewModel: ObservableObject {
    @Published var images: [String] = []
    @Published var showImageViewer = false
    @Published var selectedImage = ""
}
