//
//  MySet.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/06/06.
//

import Foundation

struct MySet: Decodable {    
    let topic: Topic
    let set: PickSet
    
    init(topic: Topic, set: PickSet) {
        self.topic = topic
        self.set = set
    }
}
