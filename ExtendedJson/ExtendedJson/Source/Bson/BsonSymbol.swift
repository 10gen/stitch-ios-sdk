//
//  BsonSymbol.swift
//  ExtendedJson
//
//  Created by Jason Flax on 10/6/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

import Foundation

public struct BsonSymbol {
    let symbol: String
    
    public init(_ symbol: String) {
        self.symbol = symbol
    }
}
