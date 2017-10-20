//
//  ApiKey.swift
//  StitchCore
//
//  Created by Jason Flax on 10/18/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

import Foundation

public struct ApiKey: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case key
        case name
        case disabled
    }

    public let id: String
    public let key: String?
    public let name: String
    public let disabled: Bool
}
