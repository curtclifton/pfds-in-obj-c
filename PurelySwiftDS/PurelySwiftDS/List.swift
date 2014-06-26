//
//  List.swift
//  PurelySwiftDS
//
//  Created by Curt Clifton on 6/17/14.
//  Copyright (c) 2014 curtclifton.net. All rights reserved.
//

/// Based on both List from Figure 2.2 and CustomStack from Figure 2.3.

// Can't use a struct here because the definition is recursive.
class ListNode<T> {
    // CCC, 6/25/2014. Because of a compiler bug, we hack the backing storage for the element to use indirection through an array. I'm borrowing this approach from: https://gist.github.com/lukeredpath/917ce10328fb34a0b7ba Alternatively, we could constrain T to be an object type. These gyrations are to avoid "LLVM ERROR: unimplemented IRGen feature! non-fixed class layout"
    let _element: T[]
    var element: T {
        return _element[0]
    }
    let nextNode: ListNode<T>?
    
    init(element: T, nextNode: ListNode<T>?) {
        self._element = [element]
        self.nextNode = nextNode
    }
}

// CCC, 6/25/2014. Want List<T> itself to be Equatable, but that causes the compiler to blow up.
class List<T> {
    let head: ListNode<T>?
    init() {
    }
    
    init(head: ListNode<T>) {
        self.head = head
    }
}

extension List: Stack {
    typealias ElementType = T
    typealias StackType = List<T>
    typealias NestedStackType = List<List<T>>
    
    class func empty() -> List<T> {
        return List<T>()
    }
    
    func isEmpty() -> Bool {
        return head == nil
    }
    
    func cons(element: T) -> List<T> {
        var newNode = ListNode<T>(element: element, nextNode: head)
        return List<T>(head: newNode)
    }
    
    func suffixes() -> List<List<T>> {
        var result = List<List<T>>.empty()
        result = result.cons(self)
        return result
    }
}
