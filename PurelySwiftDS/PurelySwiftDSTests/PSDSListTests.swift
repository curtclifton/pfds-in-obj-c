//
//  PSDSListTests.swift
//  PurelySwiftDS
//
//  Created by Curt Clifton on 6/25/14.
//  Copyright (c) 2014 curtclifton.net. All rights reserved.
//

import XCTest
import PurelySwiftDS

/// A trivial wrapper class to facilitate testing of lists containing AnyObject instances.
class Wrapper: Equatable {
}

func ==(lhs: Wrapper, rhs: Wrapper) -> Bool {
    return true
}

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
        var empty: List<Wrapper> = List.empty();
        XCTAssert(empty.isEmpty(), "Expected isEmpty. empty = \(empty)")
    }
    
    func testEmpty2() {
        var emptyA: List<Wrapper> = List.empty();
        var emptyB: List<Wrapper> = List.empty();
        // CCC, 6/25/2014. Should really be XCTAssertEqual here, but I haven't sorted out how to make List<T> Equatable when T is Equatable
        XCTAssert(emptyA == emptyB, "Expected two empty instances to be equal")
    }
}
