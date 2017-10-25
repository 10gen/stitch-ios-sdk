//
//  BsonCode+ExtendedJson.swift
//  ExtendedJson
//
//  Created by Jason Flax on 10/5/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

import Foundation

extension BsonCode: ExtendedJsonRepresentable {
    enum CodingKeys: String, CodingKey {
        case code = "$code", scope = "$scope"
    }

    public static func fromExtendedJson(xjson: Any) throws -> ExtendedJsonRepresentable {
        guard let json = xjson as? [String: Any],
            let code = json[ExtendedJsonKeys.code.rawValue] as? String else {
                throw BsonError.parseValueFailure(value: xjson, attemptedType: BsonCode.self)
        }

        if let scope = json["$scope"] {
            return BsonCode(code: code,
                            scope: try BsonDocument.fromExtendedJson(xjson: scope) as? BsonDocument)
        }

        return BsonCode(code: code, scope: nil)
    }

    public var toExtendedJson: Any {
        var code: [String: Any] = [
            ExtendedJsonKeys.code.rawValue: self.code
        ]

        if let scope = self.scope {
            code["$scope"] = scope.toExtendedJson
        }

        return code
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(code: try container.decode(String.self, forKey: CodingKeys.code),
                  scope: try container.decodeIfPresent(BsonDocument.self, forKey: CodingKeys.scope))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.code, forKey: CodingKeys.code)
        try container.encodeIfPresent(self.scope, forKey: CodingKeys.scope)
    }

    public func isEqual(toOther other: ExtendedJsonRepresentable) -> Bool {
        if let other = other as? BsonCode {
            return self.code == other.code  && self.scope == other.scope
        }

        return false
    }
}
