//
//  Stack.swift
//  PurelySwiftDS
//
//  Created by Curt Clifton on 6/17/14.
//  Copyright (c) 2014 curtclifton.net. All rights reserved.
//

import Foundation

/// Based on signature Stack from Figure 2.1, extended with additional functions presented in the text.
public protocol Stack: Equatable {
    typealias Element: Equatable
    
    // NOTE: I'm keeping the operation names Okasaki uses in the text for now as much as possible, just so it's easier to compare. These are very unconventional names in Objective-C, but I think using more conventional names would muddy comparisons.

    // Returns an empty stack.
    static func empty() -> Self
    
    /// Whether the stack is empty.
    var isEmpty: Bool { get }

    /// Adds a new element to the top of the stack, returning a fresh stack instance.
    func cons(element: Element) -> Self

    /// The element on the top of the stack.
    var head: Element { get }

    /// A stack consisting of all but the top-most element.
    var tail: Self { get }
    
    /// Returns a new stack consisting of all the elements of this stack followed by the elements of otherStack.
    func append<OtherStack: Stack where OtherStack.Element == Element>(otherStack: OtherStack) -> OtherStack

    // NOTE: Using subscript instead of an updated function. Subscript in Swift is mutating, but because of the copy-on-write semantics of structs, this is still purely functional. That is, it only changes the copy on which it is called and is just sugar for reassigning in place. That is, instead of `stack = stack.update(4, "x")` we can write `stack[4] = "x"`, and instead of `ys = xs.update(4, "x")` we can write `var ys = xs; ys[4] = "x"`
    subscript(index: Int) -> Element { get set }
    
    /// All suffixes of this stack, include the improper suffix. Exercise 2.1.
    var suffixes: [Self] { get }
    func suffixesAsStacks<StackOfStacks: Stack where StackOfStacks.Element == Self>() -> StackOfStacks
}

// default implementations
extension Stack {
    func append<OtherStack: Stack where OtherStack.Element == Element>(otherStack: OtherStack) -> OtherStack {
        if isEmpty {
            return otherStack
        } else {
            return tail.append(otherStack).cons(head)
        }
    }

    var suffixes: [Self] {
        var result: [Self] = []
        var list = self
        while !list.isEmpty {
            result.append(list)
            list = list.tail
        }
        result.append(list) // make sure to include empty list
        return result
    }
    
    func suffixesAsStacks<StackOfStacks: Stack where StackOfStacks.Element == Self>() -> StackOfStacks {
        var result: StackOfStacks = StackOfStacks.empty()
        var stack = self
        while !stack.isEmpty {
            result = result.cons(stack)
            stack = stack.tail
        }
        result = result.cons(stack) // make sure to include empty list
        return result
    }
}

infix operator -|- { precedence 132 associativity right}
public func -|-<Element, S: Stack where S.Element == Element>(element: Element, stack: S) -> S {
    return stack.cons(element)
}

public func +<S: Stack>(lhs: S, rhs: S) -> S {
    return lhs.append(rhs)
}
