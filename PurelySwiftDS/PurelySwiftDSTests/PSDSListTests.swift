//
//  PSDSListTests.swift
//  PurelySwiftDS
//
//  Created by Curt Clifton on 6/25/14.
//  Copyright (c) 2014 curtclifton.net. All rights reserved.
//

import XCTest
@testable import PurelySwiftDS

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
        let empty: List<Int> = List.empty();
        XCTAssert(empty.isEmpty, "Expected isEmpty. empty = \(empty)")
    }
    
    func testEmpty2() {
        let emptyA: List<String> = List.empty()
        let emptyB: List<String> = List.empty()

        XCTAssertEqual(emptyA, emptyB, "Expected two empty instances to be equal")
    }
    
    func testCons1() {
        let list1: List<Int> = 1 -|- List.empty()
        let list2: List<Int> = 1 -|- List.empty()
        XCTAssertEqual(list1, list2, "Expected identically constructed lists to be equal")
    }
    
    func testCons2() {
        let list1: List<Int> = 1 -|- 2 -|- List.empty()
        let list2: List<Int> = 1 -|- 2 -|- List.empty()
        XCTAssertEqual(list1, list2, "Expected identically constructed lists to be equal")
    }
    
    func testCons3() {
        let list1: List<Int> = 1 -|- List.empty()
        let list2: List<Int> = 2 -|- List.empty()
        XCTAssertNotEqual(list1, list2, "Expected differently constructed lists to be equal")
    }
    
    func testCons4() {
        let list1: List<Int> = 2 -|- 1 -|- List.empty()
        let list2: List<Int> = 1 -|- 2 -|- List.empty()
        XCTAssertNotEqual(list1, list2, "Expected differently constructed lists to be equal")
    }
    
    func testCons5() {
        let list1: List<Int> = 1 -|- List.empty()
        let list2: List<Int> = 1 -|- 2 -|- List.empty()
        XCTAssertNotEqual(list1, list2, "Expected differently constructed lists to be equal")
    }

    func testTail1() {
        let list1: List<Int> = 1 -|- List.empty()
        let list2: List<Int> = 2 -|- 1 -|- List.empty() // fresh list
        XCTAssertEqual(list1, list2.tail, "Expected cons followed by tail to be equal to original")
    }
    
    func testTail2() {
        let list1: List<Int> = 1 -|- List.empty()
        let list2: List<Int> = 2 -|- list1 // cons-ing onto existing list
        XCTAssertEqual(list1, list2.tail, "Expected cons followed by tail to be equal to original")
    }

    func testHead1() {
        let list1: List<Int> = 1 -|- List.empty()
        let list2: List<Int> = 2 -|- 1 -|- List.empty()
        XCTAssertNotEqual(list1.head, list2.head)
        XCTAssertEqual(list1.head, list2.tail.head)
    }

    func testDescription() {
        var list: List<Int> = List.empty()
        XCTAssertEqual(list.description, "()")
        list = 1 -|- list
        XCTAssertEqual(list.description, "(1)")
        list = 2 -|- list
        XCTAssertEqual(list.description, "(2,1)")
    }

    func testAppend1() {
        let emptyA: List<String> = List.empty()
        let emptyB: List<String> = List.empty()
        let result = emptyA + emptyB
        XCTAssert(result.isEmpty)
    }
    
    func testAppend2() {
        let empty: List<String> = List.empty()
        let list: List<String> = "Hello" -|- List.empty()

        let result1 = empty + list
        XCTAssertEqual(result1, list)
        
        let result2 = list + empty
        XCTAssertEqual(result2, list)
    }
    
    func testAppend3() {
        let list1: List<Int> = 1 -|- List.empty()
        let list2: List<Int> = 2 -|- List.empty()
        
        let result1 = list1 + list2
        XCTAssertEqual(result1.description, "(1,2)")
        
        let result2 = list2 + list1
        XCTAssertEqual(result2.description, "(2,1)")
        
        let result3 = result1 + result2
        XCTAssertEqual(result3.description, "(1,2,2,1)")
    }

    func testSuffixes1() {
        let list: List<Int> = List.empty()
        let suffixes = list.suffixes
        let expectedSuffixes: [List<Int>] = [List.empty()]
        XCTAssertEqual(suffixes, expectedSuffixes)
    }
    
    func testSuffixes2() {
        let list: List<Int> = 1 -|- List.empty()
        let suffixes = list.suffixes
        let expectedSuffixes: [List<Int>] = [list, List.empty()]
        XCTAssertEqual(suffixes, expectedSuffixes)
    }
    
    func testSuffixes3() {
        let list: List<Int> = 2 -|- 1 -|- List.empty()
        let suffixes = list.suffixes
        let expectedSuffixes: [List<Int>] = [list, 1 -|- List.empty(), List.empty()]
        XCTAssertEqual(suffixes, expectedSuffixes)
    }

    func testSuffixesAsStacks1() {
        let list: List<Int> = List.empty()
        let suffixes: List<List<Int>> = list.suffixesAsStacks()
        let expectedSuffixes: List<List<Int>> = List.empty() -|- List.empty()
        XCTAssertEqual(suffixes, expectedSuffixes)
    }
    
    func testSuffixesAsStacks2() {
        let list: List<Int> = 1 -|- List.empty()
        let suffixes: List<List<Int>> = list.suffixesAsStacks()
        let expectedSuffixes: List<List<Int>> = List.empty() -|- list -|- List.empty()
        XCTAssertEqual(suffixes, expectedSuffixes)
    }
    
    func testSuffixesAsStacks3() {
        let list: List<Int> = 2 -|- 1 -|- List.empty()
        let suffixes: List<List<Int>> = list.suffixesAsStacks()
        let expectedSuffixes: List<List<Int>> = List.empty() -|- (1 -|- List.empty()) -|- list -|- List.empty()
        XCTAssertEqual(suffixes, expectedSuffixes)
    }

}
