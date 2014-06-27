//
//  Stack.swift
//  PurelySwiftDS
//
//  Created by Curt Clifton on 6/17/14.
//  Copyright (c) 2014 curtclifton.net. All rights reserved.
//

import Foundation

/// Based on signature Stack from Figure 2.1, extended with additional functions presented in the text.
protocol Stack: Equatable {
    typealias ElementType: Equatable
    typealias StackType: Equatable
    typealias NestedStackType
    
    // CCC, 3/16/2014. I'm keeping the operation names Okasaki uses in the text for now as much as possible, just so it's easier to compare. These are very unconventional names in Objective-C, but I think using more conventional names would muddy comparisons.

    // Returns an empty stack.
    class func empty() -> StackType
    
    /// Returns whether the stack is empty.
    func isEmpty() -> Bool

    /// Adds a new element to the top of the stack, returning a fresh stack instance.
    func cons(element: ElementType) -> StackType

    // CCC, 6/26/2014. Should these be (computed) properties instead of methods?
    /// Returns the element on the top of the stack.
    func head() -> ElementType

    /// Returns a stack consisting of all but the top-most element.
    func tail() -> StackType
    
    /* CCC, 6/17/2014. TODO: uncomment and implement
    /// Returns a new stack consisting of all the elements of this stack followed by the elements of otherStack.
    func append(otherStack: StackType) -> StackType;
    
    // CCC, 6/17/2014. It would be nice to use Swift's subscripting here, but the setter assumes mutation. We nod to Objective-C naming conventions, since we have multiple non-receiver arguments, and I don't want to promote unnamed parameters in Swift.
    /// Returns a new stack with the element at the given index replaced with the given element.
    func updateIndex(index: Int, withElement element: ElementType)
    */
    
    // CCC, 6/26/2014. Should this be a computed property instead of a method:
    /// Returns a stack of all suffixes of this stack, include the improper suffix. Exercise 2.1.
    func suffixes() -> NestedStackType
}

operator infix =+= { precedence 50 associativity right}
func =+=<T, S: Stack where S.ElementType == T, S.StackType == S>(element: T, stack: S) -> S {
    return stack.cons(element)
}

//func ==<S: Stack where S.ElementType: Equatable>(lhs: S, rhs: S) -> Bool {
//    if lhs.isEmpty() && rhs.isEmpty() {
//        return true
//    }
//    // CCC, 6/25/2014. Handle non-emtpy stacks:
//    return false
//}
