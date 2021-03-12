//
//  WorkEntity.swift
//  Colombia
//
//  Created by 山根大生 on 2021/02/16.
//

import Foundation

struct WorkEntity: Decodable {
    var id: Int
    var title: String
    var image: Image
    
    enum Key: String, CodingKey {
        case id
        case title
        case image = "images"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.image = try container.decode(Image.self, forKey: .image)
    }
}
