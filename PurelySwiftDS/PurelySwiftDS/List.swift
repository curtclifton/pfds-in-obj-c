//
//  List.swift
//  PurelySwiftDS
//
//  Created by Curt Clifton on 6/17/14.
//  Copyright (c) 2014 curtclifton.net. All rights reserved.
//

/// Based on both List from Figure 2.2 and CustomStack from Figure 2.3.

enum ListNode<Element: Equatable> {
    // CCC, 10/31/2015. blah. should be Nil not Tail
    case Tail(element: Element)
    indirect case Interior(element: Element, nextNode: ListNode<Element>)
    
    var element: Element {
        switch self {
        case let Tail(element):
            return element
        case let Interior(element, _):
            return element
        }
    }
    
    var nextNode: ListNode<Element>? {
        switch self {
        case Tail(_):
            return nil
        case let Interior(_, nextNode):
            return nextNode
        }
    }
}

struct List<Element: Equatable> {
    var headNode: ListNode<Element>? // CCC, 10/31/2015. shouldn't be optional, use Nil

    init() {
        self.headNode = nil
    }
    
    init(headNode: ListNode<Element>?) {
        self.headNode = headNode
    }
}

extension List: Stack {
    typealias ElementType = Element
    
    static func empty() -> List<Element> {
        return List()
    }
    
    var isEmpty: Bool {
        return headNode == nil
    }
    
    func cons(element: Element) -> List<Element> {
        let newNode: ListNode<Element>
        if let head = headNode {
            newNode = .Interior(element: element, nextNode: head)
        } else {
            newNode = .Tail(element: element)
        }
        return List(headNode: newNode)
    }

    var head: Element {
        return headNode!.element
    }
    
    var tail: List<Element> {
        return List(headNode: headNode!.nextNode)
    }

// CCC, 10/31/2015. overload for efficiency?
//    func append(otherStack: List<Element>) -> List<Element> {
//        // basically want a zipper that finds the last node of self, then rebuilds nodes back to the head
//        return self
//    }
    
    var suffixes: [List<Element>] {
        // CCC, 6/26/2014. TODO. Test and implement. This is just a stub to get the types right.
        return []
    }
}

extension List: Equatable {}
func ==<T: Equatable>(lhs: List<T>, rhs: List<T>) -> Bool {
    if lhs.isEmpty && rhs.isEmpty {
        return true
    } else if lhs.isEmpty || rhs.isEmpty {
        return false
    }

    if lhs.head != rhs.head {
        return false
    }

    return lhs.tail == rhs.tail
}

extension List: CustomStringConvertible {
    var _elementsAsString: String {
        if isEmpty {
            return ""
        } else if tail.isEmpty {
            return "\(head)"
        } else {
            return "\(head),\(tail._elementsAsString)"
        }
    }
    var description: String {
        get {
            let result = "(\(_elementsAsString))"
            return result
        }
    }
}
