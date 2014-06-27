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
    
    func testCons1() {
        var list1: List<Int> = 1 =+= List.empty()
        var list2: List<Int> = 1 =+= List.empty()
        XCTAssertEqual(list1, list2, "Expected identically constructed lists to be equal");
    }
    
    func testCons2() {
        var list1: List<Int> = 1 =+= 2 =+= List.empty()
        var list2: List<Int> = 1 =+= 2 =+= List.empty()
        XCTAssertEqual(list1, list2, "Expected identically constructed lists to be equal");
    }
    
    func testCons3() {
        var list1: List<Int> = 1 =+= List.empty()
        var list2: List<Int> = 2 =+= List.empty()
        XCTAssertNotEqual(list1, list2, "Expected differently constructed lists to be equal");
    }
    
    func testCons4() {
        var list1: List<Int> = 2 =+= 1 =+= List.empty()
        var list2: List<Int> = 1 =+= 2 =+= List.empty()
        XCTAssertNotEqual(list1, list2, "Expected differently constructed lists to be equal");
    }
    
    func testCons5() {
        var list1: List<Int> = 1 =+= List.empty()
        var list2: List<Int> = 1 =+= 2 =+= List.empty()
        XCTAssertNotEqual(list1, list2, "Expected differently constructed lists to be equal");
    }

    func testTail1() {
        var list1: List<Int> = 1 =+= List.empty()
        var list2: List<Int> = 2 =+= 1 =+= List.empty() // fresh list
        XCTAssertEqual(list1, list2.tail, "Expected cons followed by tail to be equal to original");
    }
    
    func testTail2() {
        var list1: List<Int> = 1 =+= List.empty()
        var list2: List<Int> = 2 =+= list1 // cons-ing onto existing list
        XCTAssertEqual(list1, list2.tail, "Expected cons followed by tail to be equal to original");
    }
    
    // CCC, 6/26/2014. Swift doesn't currently support any form of exception handling, so this test case doesn't transfer from the Objective-C version.
    //    func testTail3() {
    //        var list1: List<Int> = List.empty()
    //        XCTAssertThrows(list1.tail, "Can't take the tail of an empty list");
    //    }
    
    func testHead1() {
        var list1: List<Int> = 1 =+= List.empty()
        var list2: List<Int> = 2 =+= 1 =+= List.empty()
        XCTAssertNotEqual(list1.head, list2.head)
        XCTAssertEqual(list1.head, list2.tail.head);
    }

    // CCC, 6/26/2014. Swift doesn't currently support any form of exception handling, so this test case doesn't transfer from the Objective-C version.
    //    func testHead2() {
    //        var empty: List<Int> = List.empty()
    //        XCTAssertThrows(empty.head, "Can't take the head of an empty list");
    //    }

}
