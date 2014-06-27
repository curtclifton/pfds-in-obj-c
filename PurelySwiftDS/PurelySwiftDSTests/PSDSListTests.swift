//
//  PSDSListTests.swift
//  PurelySwiftDS
//
//  Created by Curt Clifton on 6/25/14.
//  Copyright (c) 2014 curtclifton.net. All rights reserved.
//

import XCTest
import PurelySwiftDS

class PSDSListTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEmpty1() {
        var empty: List<Int> = List.empty();
        XCTAssert(empty.isEmpty(), "Expected isEmpty. empty = \(empty)")
    }
    
    func testEmpty2() {
        var emptyA: List<String> = List.empty();
        var emptyB: List<String> = List.empty();

        XCTAssertEqual(emptyA, emptyB, "Expected two empty instances to be equal")
    }
}
