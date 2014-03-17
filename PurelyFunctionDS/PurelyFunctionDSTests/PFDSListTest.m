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
    XCTAssert([empty isEmpty], @"Expected isEmpty: %@", empty);
}

- (void)testEmpty2;
{
    PFDSList *emptyA = [PFDSList empty];
    PFDSList *emptyB = [PFDSList empty];
    XCTAssertEqualObjects(emptyA, emptyB, @"Expected two empty instances to be equal");
}

@end
