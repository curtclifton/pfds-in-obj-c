//
//  PFDSList.m
//  PurelyFunctionDS
//
//  Created by Curt Clifton on 3/16/14.
//  Copyright (c) 2014 curtclifton.net. All rights reserved.
//

#import "PFDSList.h"

static PFDSList *empty;

@implementation PFDSList
+ (void)initialize;
{
    if (self != [PFDSList class]) {
        return;
    }
    
    empty = [PFDSList new];
}

+ (instancetype)empty;
{
    return empty;
}

- (BOOL)isEmpty;
{
    // Because we use a shared instance to represent empty, we can use identity comparison here.
    return self == empty;
}

- (id <PFDSStack>)cons:(id)element;
{
    // CCC, 3/16/2014. implement
    return self;
}

- (id)head;
{
    // CCC, 3/16/2014. implement
    return nil;
}

- (id <PFDSStack>)tail;
{
    // CCC, 3/16/2014. implement
    return self;
}

@end
