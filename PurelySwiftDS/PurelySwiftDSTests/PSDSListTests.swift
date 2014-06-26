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
    class Wrapper {
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEmpty1() {
        var empty: List<Wrapper> = List.empty();
        XCTAssert(empty.isEmpty(), "Expected isEmpty. empty = \(empty)")
    }
}
