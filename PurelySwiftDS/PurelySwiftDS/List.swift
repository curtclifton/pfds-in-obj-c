//
//  List.swift
//  PurelySwiftDS
//
//  Created by Curt Clifton on 6/17/14.
//  Copyright (c) 2014 curtclifton.net. All rights reserved.
//

/// Based on both List from Figure 2.2 and CustomStack from Figure 2.3.

enum ListNode<Element: Equatable> {
    case Nil
    indirect case Interior(element: Element, nextNode: ListNode<Element>)
    
    var nextNode: ListNode<Element> {
        switch self {
        case .Nil:
            return self
        case let .Interior(_, nextNode):
            return nextNode
        }
    }
}

extension ListNode: Equatable {
}
func ==<T: Equatable>(lhs: ListNode<T>, rhs: ListNode<T>) -> Bool {
    switch (lhs, rhs) {
    case (.Nil, .Nil):
        return true
    case let (.Interior(lhsElement, lhsNextNode), .Interior(rhsElement, rhsNextNode)):
        return lhsElement == rhsElement && lhsNextNode == rhsNextNode
    default:
        return false
    }
}

struct List<Element: Equatable> {
    var headNode: ListNode<Element>

    init() {
        self.headNode = .Nil
    }
    
    init(headNode: ListNode<Element>) {
        self.headNode = headNode
    }
}

extension List: Stack {
    static func empty() -> List<Element> {
        return List()
    }
    
    var isEmpty: Bool {
        return headNode == ListNode.Nil
    }
    
    func cons(element: Element) -> List<Element> {
        let newNode: ListNode<Element> = .Interior(element: element, nextNode: headNode)
        return List(headNode: newNode)
    }

    var head: Element {
        switch headNode {
        case .Nil:
            abort()
        case let .Interior(element, _):
            return element
        }
    }
    
    var tail: List<Element> {
        switch headNode {
        case .Nil:
            abort()
        case let .Interior(_, nextNode):
            return List(headNode: nextNode)
        }
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
