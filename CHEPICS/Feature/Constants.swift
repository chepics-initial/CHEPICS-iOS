//
//  Constants.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/02/24.
//

import UIKit


enum Constants {
    static let oneTimeCodeCount = 6
    static let passwordCount = 8
    static let nameCount = 30
    static let bioCount = 100
    static let topicTitleCount = 100
    static let topicDescriptionCount = 300
    static let commentCount = 300
    static let imageCount = 4
    static let setCount = 50
}

func isValidUrl(_ urlString: String) -> Bool {
    if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
        return true
    }
    
    return false
}

func isValidInput(_ text: String) -> Bool {
    let modifiedNewLineString = text.replacingOccurrences(of: "\n", with: "")
    let modifiedSpaceString = modifiedNewLineString.replacingOccurrences(of: " ", with: "")
    let modifiedAnotherSpaceString = modifiedSpaceString.replacingOccurrences(of: "　", with: "")
    return !modifiedAnotherSpaceString.isEmpty
}
