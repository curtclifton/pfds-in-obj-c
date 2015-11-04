//
//  RedBlackTreeTests.swift
//  CountedSet
//
//  Created by Curt Clifton on 11/2/15.
//  Copyright © 2015 curtclifton.net. All rights reserved.
//

import XCTest
@testable import CountedSet

class RedBlackTreeTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInsert() {
        var tree: RedBlackTree<Int> = RedBlackTree<Int>.empty()
        XCTAssert(tree.isEmpty)
        for x in 1...10 {
            XCTAssertFalse(tree.contains(x))
            tree.insert(x)
            XCTAssert(tree.contains(x))
        }
        XCTAssertFalse(tree.isEmpty)
    }

    func testRemove() {
        var tree: RedBlackTree<Int> = RedBlackTree<Int>.empty()
        XCTAssert(tree.isEmpty)
        tree.insert(1)
        XCTAssert(tree.contains(1))
        tree.remove(1)
        XCTAssert(tree.isEmpty)
    }
    
    func testRemoveMany() {
        var tree: RedBlackTree<Int> = RedBlackTree<Int>.empty()
        for x in 1...10 {
            tree.insert(x)
        }
        XCTAssertFalse(tree.isEmpty)
        for x in 1...10 {
            XCTAssert(tree.contains(x))
            tree.remove(x)
            XCTAssertFalse(tree.contains(x))
        }
        XCTAssert(tree.isEmpty)
    }
    
    func testInvariants() {
        var tree: RedBlackTree<Int> = RedBlackTree<Int>.empty()
        XCTAssert(tree.noRedNodeHasARedChild)
        XCTAssert(tree.blackNodePathLengthsMatch)
        for x in 1...10 {
            tree.insert(x)
            XCTAssert(tree.noRedNodeHasARedChild)
            XCTAssert(tree.blackNodePathLengthsMatch)
        }
        for x in 1...10 {
            tree.remove(x)
            XCTAssert(tree.noRedNodeHasARedChild)
            XCTAssert(tree.blackNodePathLengthsMatch)
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
