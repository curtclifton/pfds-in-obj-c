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

- (void)testDescription;
{
    PFDSList *empty = [PFDSList empty];
    XCTAssertEqualObjects([empty description], @"[]", @"");
    PFDSList *list1 = [empty cons:@(1)];
    XCTAssertEqualObjects([list1 description], @"[1]", @"");
    PFDSList *list2 = [list1 cons:@(2)];
    XCTAssertEqualObjects([list2 description], @"[2,1]", @"");
}

- (void)testAppend1;
{
    PFDSList *empty1 = [PFDSList empty];
    PFDSList *empty2 = [PFDSList empty];
    PFDSList *result = [empty1 append:empty2];
    XCTAssertTrue(result.isEmpty, @"");
}

- (void)testAppend2;
{
    PFDSList *empty = [PFDSList empty];
    PFDSList *list = [[[PFDSList empty] cons:@(1)] cons:@(2)];

    PFDSList *result1 = [empty append:list];
    XCTAssertEqualObjects(result1, list, @"");
    
    PFDSList *result2 = [list append:empty];
    XCTAssertEqualObjects(result2, list, @"");
}

- (void)testAppend3;
{
    PFDSList *list1 = [[PFDSList empty] cons:@(1)];
    PFDSList *list2 = [[PFDSList empty] cons:@(2)];
    
    PFDSList *result1 = [list1 append:list2];
    XCTAssertEqualObjects(result1, [[[PFDSList empty] cons:@(2)] cons:@(1)], @"");
    
    PFDSList *result2 = [list2 append:list1];
    XCTAssertEqualObjects(result2, [[[PFDSList empty] cons:@(1)] cons:@(2)], @"");
}

- (void)testAppend4;
{
    XCTAssertThrows([[PFDSList empty] append:nil], @"can't append nil");
}

- (void)testUpdateIndexWithElement1;
{
    PFDSList *originalList = [[[[[PFDSList empty] cons:@(4)] cons:@(3)] cons:@(2)] cons:@(1)];
    
    PFDSList *resultList = [originalList updateIndex:0 withElement:@(0)];
    PFDSList *expectedList = [[[[[PFDSList empty] cons:@(4)] cons:@(3)] cons:@(2)] cons:@(0)];
    XCTAssertEqualObjects(resultList, expectedList, @"");
    
    resultList = [originalList updateIndex:2 withElement:@(0)];
    expectedList = [[[[[PFDSList empty] cons:@(4)] cons:@(0)] cons:@(2)] cons:@(1)];
    XCTAssertEqualObjects(resultList, expectedList, @"");
    
    resultList = [originalList updateIndex:3 withElement:@(0)];
    expectedList = [[[[[PFDSList empty] cons:@(0)] cons:@(3)] cons:@(2)] cons:@(1)];
    XCTAssertEqualObjects(resultList, expectedList, @"");
    
    XCTAssertThrows([originalList updateIndex:4 withElement:@(0)], @"index out of bounds");
}
@end
