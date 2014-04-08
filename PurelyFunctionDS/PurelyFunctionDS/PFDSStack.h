//
//  PFDSStack.h
//  PurelyFunctionDS
//
//  Created by Curt Clifton on 3/16/14.
//  Copyright (c) 2014 curtclifton.net. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Based on signature Stack from Figure 2.1, extended with additional functions presented in the text.
@protocol PFDSStack <NSObject>
+ (instancetype)empty;

- (BOOL)isEmpty;
// CCC, 3/16/2014. In keeping with Objective-C data structures, I'm going with type 'id' for elements. The alternative seems to be to reify types and dynamically check type properties. That might be an interesting experiment, but seems orthogonal to the functional aspects of this.
// CCC, 3/16/2014. I'm keeping the operation names Okasaki uses in the text for now as much as possible, just so it's easier to compare. These are very unconventional names in Objective-C, but I think using more conventional names would muddy comparisons.
/// Adds a new element to the top of the stack, returning a fresh stack instance.
- (id <PFDSStack>)cons:(id)element;
/// Returns the element on the top of the stack. Raises if the stack is empty.
- (id)head;
/// Returns a stack consisting of all but the top-most element. Raises if the stack is empty.
- (id <PFDSStack>)tail;

/// Returns a new stack consisting of all the elements of this stack followed by the elements of otherStack.
- (id <PFDSStack>)append:(id <PFDSStack>)otherStack;

// CCC, 3/16/2014. Here we need to at least nod to Objective-C naming conventions, since we have multiple non-receiver arguments.
/// Returns a new stack with the element at the given index replaced with the given element.
- (id <PFDSStack>)updateIndex:(NSUInteger)index withElement:(id)element;

/// Returns a stack of all suffixes of this stack, include the improper suffix. Exercise 2.1.
- (id <PFDSStack>)suffixes;

@end
