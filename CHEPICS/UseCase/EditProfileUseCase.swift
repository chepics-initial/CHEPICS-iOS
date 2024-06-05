//
//  EditProfileUseCase.swift
//  CHEPICS
//
//  Created by 川尻辰義 on 2024/06/01.
//

import Foundation

protocol EditProfileUseCase {
    func updateUser(username: String, fullname: String, bio: String?, image: Data?) async -> Result<Void, APIError>
}

final class EditProfileUseCaseImpl: EditProfileUseCase {
    private let userRepository: any UserRepository
    
    init(userRepository: some UserRepository) {
        self.userRepository = userRepository
    }
    
    func updateUser(username: String, fullname: String, bio: String?, image: Data?) async -> Result<Void, APIError> {
        await userRepository.updateUser(username: username, fullname: fullname, bio: bio, image: image)
    }
}
