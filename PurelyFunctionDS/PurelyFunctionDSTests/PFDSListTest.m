//
//  PFDSListTest.m
//  PurelyFunctionDS
//
//  Created by Curt Clifton on 3/16/14.
//  Copyright (c) 2014 curtclifton.net. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "PFDSList.h"

@interface PFDSListTest : XCTestCase

@end

@implementation PFDSListTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEmpty1;
{
    PFDSList *empty = [PFDSList empty];
    XCTAssert([empty isEmpty], @"Expected isEmpty. empty = %@", empty);
}

- (void)testEmpty2;
{
    PFDSList *emptyA = [PFDSList empty];
    PFDSList *emptyB = [PFDSList empty];
    XCTAssertEqualObjects(emptyA, emptyB, @"Expected two empty instances to be equal");
    XCTAssert(emptyA == emptyB, @"Expected two empty instances to be identical. left = %@, right = %@", emptyA, emptyB);
}

- (void)testCons1;
{
    id element1 = @(1);
    PFDSList *list1 = [[PFDSList empty] cons:element1];
    PFDSList *list2 = [[PFDSList empty] cons:element1];
    XCTAssertEqualObjects(list1, list2, @"Expected identically constructed lists to be equal");
}

- (void)testCons2;
{
    id element1 = @(1);
    id element2 = @(2);
    PFDSList *list1 = [[[PFDSList empty] cons:element1] cons:element2];
    PFDSList *list2 = [[[PFDSList empty] cons:element1] cons:element2];
    XCTAssertEqualObjects(list1, list2, @"Expected identically constructed lists to be equal");
}

- (void)testCons3;
{
    id element1 = @(1);
    id element2 = @(2);
    PFDSList *list1 = [[PFDSList empty] cons:element1];
    PFDSList *list2 = [[PFDSList empty] cons:element2];
    XCTAssertNotEqualObjects(list1, list2, @"Expected differently constructed lists to be not equal");
}

- (void)testCons4;
{
    id element1 = @(1);
    id element2 = @(2);
    PFDSList *list1 = [[[PFDSList empty] cons:element1] cons:element1]; // element1 appears twice
    PFDSList *list2 = [[[PFDSList empty] cons:element1] cons:element2];
    XCTAssertNotEqualObjects(list1, list2, @"Expected differently constructed lists to be not equal");
}

- (void)testCons5;
{
    id element1 = @(1);
    id element2 = @(2);
    PFDSList *list1 = [[PFDSList empty] cons:element1];
    PFDSList *list2 = [[[PFDSList empty] cons:element1] cons:element2];
    XCTAssertNotEqualObjects(list1, list2, @"Expected differently constructed lists to be not equal");
}

- (void)testTail1;
{
    id element1 = @(1);
    id element2 = @(2);
    PFDSList *list1 = [[PFDSList empty] cons:element1];
    PFDSList *list2 = [[[PFDSList empty] cons:element1] cons:element2];
    XCTAssertEqualObjects(list1, list2.tail, @"Expected cons followed by tail to be equal to original");
}

- (void)testTail2;
{
    id element1 = @(1);
    id element2 = @(2);
    PFDSList *list1 = [[PFDSList empty] cons:element1];
    PFDSList *list2 = [list1 cons:element2];
    XCTAssertEqualObjects(list1, list2.tail, @"Expected cons followed by tail to be equal to original");
}

- (void)testTail3;
{
    PFDSList *empty = [PFDSList empty];
    XCTAssertThrows(empty.tail, @"Can't take the tail of an empty list");
}

- (void)testHead1;
{
    id element1 = @(1);
    id element2 = @(2);
    PFDSList *list1 = [[PFDSList empty] cons:element1];
    PFDSList *list2 = [[[PFDSList empty] cons:element1] cons:element2];
    XCTAssertNotEqualObjects(list1.head, list2.head, @"");
    XCTAssertEqualObjects(list1.head, list2.tail.head, @"");
}

- (void)testHead2;
{
    PFDSList *empty = [PFDSList empty];
    XCTAssertThrows(empty.head, @"Can't take the head of an empty list");
}

@end
