//
//  Image.swift
//  Colombia
//
//  Created by Takuma Osada on 2021/03/13.
//

struct Image: Decodable {
    var url: String?

    enum Key: String, CodingKey {
        case url = "recommended_url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.url = try container.decode(String.self, forKey: .url)
    }
}
