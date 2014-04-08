//
//  PFDSList.m
//  PurelyFunctionDS
//
//  Created by Curt Clifton on 3/16/14.
//  Copyright (c) 2014 curtclifton.net. All rights reserved.
//

#import "PFDSList.h"

#import "PFDSExceptions.h"

// CCC, 4/7/2014. It would be more object-oriented to use polymorphism to distinguish between empty and non-empty lists.
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

+ (instancetype)listFromArray:(NSArray *)array;
{
    __block PFDSList *result = [PFDSList empty];
    [array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = [result cons:obj];
    }];
    return result;
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

- (NSString *)description;
{
    NSString *result = @"[";
    PFDSList *list = self;
    while (![list isEmpty]) {
        result = [result stringByAppendingString:[list.head description]];
        list = list.tail;
        if (![list isEmpty]) {
            result = [result stringByAppendingString:@","];
        }
    }
    result = [result stringByAppendingString:@"]"];
    return result;
}

#pragma mark - PFDSStack protocol

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

// CCC, 4/7/2014. Without tail recursion elimination, this is spendy.
- (id <PFDSStack>)append:(id <PFDSStack>)otherStack;
{
    if (otherStack == nil) {
        [NSException raise:PFDSIllegalArgumentException format:@"otherStack must be non-nil"];
    }
    
    if (self.isEmpty) {
        return otherStack;
    }
    
    return [[self.tail append:otherStack] cons:self.head];
}

// CCC, 4/7/2014. Without tail recursion elimination, this is spendy.
- (id <PFDSStack>)updateIndex:(NSUInteger)index withElement:(id)element;
{
    if (index == 0) {
        return [self.tail cons:element];
    }
    
    return  [[self.tail updateIndex:index - 1 withElement:element] cons:self.head];
}

// CCC, 4/7/2014. Without tail recursion elimination, this is spendy.
- (id <PFDSStack>)suffixes;
{
    if (self.firstCell == nil) {
        return [[PFDSList empty] cons:[PFDSList empty]];
    }
    
    return [self.tail.suffixes cons:self];
}

@end

@implementation ConsCell
// nothing to do here but autosynthesize the properties
@end
