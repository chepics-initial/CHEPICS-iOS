//
//  Items.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/20.
//

import Foundation

struct Items<T: Decodable>: Decodable {
    let items: [T]
    
    init(items: [T]) {
        self.items = items
    }
}
