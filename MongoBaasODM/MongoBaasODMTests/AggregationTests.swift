//
//  AggregationTests.swift
//  MongoBaasODM
//
//  Created by Yanai Rozenberg on 24/05/2017.
//  Copyright © 2017 MongoDB. All rights reserved.
//

import XCTest
@testable import MongoBaasODM
import MongoExtendedJson
import MongoDB

class AggregationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: Aggregation
    func testAggregationStageMatch() {
        let field1 = "age"
        let value1 = 30
        let match: AggregationStage = .match(query: .greaterThan(field: field1, value: value1))
        let matchDocument = match.asDocument
        
        let query = matchDocument["$match"] as? Document
        XCTAssert(query != nil)
        XCTAssertEqual((query?[field1] as? Document)?["$gt"] as? Int ,value1)
        
    }
    
    
    
}
