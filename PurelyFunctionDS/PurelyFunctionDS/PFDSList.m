//
//  PFDSList.m
//  PurelyFunctionDS
//
//  Created by Curt Clifton on 3/16/14.
//  Copyright (c) 2014 curtclifton.net. All rights reserved.
//

#import "PFDSList.h"

#import "PFDSExceptions.h"

static PFDSList *empty;

@interface ConsCell : NSObject
@property (nonatomic, strong) id element;
@property (nonatomic, strong) ConsCell *nextCell;
@end

@interface PFDSList ()
@property (nonatomic, strong) ConsCell *firstCell;
@end

@implementation PFDSList
+ (void)initialize;
{
    if (self != [PFDSList class]) {
        return;
    }
    
    empty = [PFDSList new];
}

#pragma mark - NSObject subclass

- (BOOL)isEqual:(id)object;
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[PFDSList class]]) {
        return NO;
    }

    PFDSList *otherObject = object;
    if ([self isEmpty] || [otherObject isEmpty]) {
        // Only one isEmpty, otherwise we would early-out above
        return NO;
    }
    
    if ([self.head isEqual:otherObject.head]) {
        return [self.tail isEqual:otherObject.tail];
    }
        
    return NO;
}

- (NSUInteger)hash;
{
    if ([self isEmpty]) {
        return [super hash];
    }
    
    return [self.head hash] * 31 + [self.tail hash];
}

#pragma mark - Public API

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
    ConsCell *newCell = [ConsCell new];
    newCell.element = element;
    PFDSList *result = [PFDSList new];
    result.firstCell = newCell;

    if (![self isEmpty]) {
        // Need to chain to our linked list of cells, but since our list in immutable, we don't need to copy anything here.
        newCell.nextCell = self.firstCell;
    }

    return result;
}

- (id)head;
{
    if (self.firstCell == nil) {
        [NSException raise:PFDSEmptyStackException format:@"can't take the head of an empty list"];
    }

    return self.firstCell.element;
}

- (id <PFDSStack>)tail;
{
    if (self.firstCell == nil) {
        [NSException raise:PFDSEmptyStackException format:@"can't take the head of an empty list"];
    }

    ConsCell *nextCell = self.firstCell.nextCell;
    if (nextCell == nil) {
        return empty;
    }
    
    PFDSList *result = [PFDSList new];
    result.firstCell = nextCell;
    return result;
}

@end

@implementation ConsCell
// nothing to do here but autosynthesize the properties
@end
