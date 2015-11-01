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
    
    subscript(index: Int) -> Element {
        // NOTE: We could use the stack and recursive calls to act as a zipper. For variety, I'm trying a more direct approach here.
        get {
            var currentIndex = index
            var list = self
            while currentIndex > 0 {
                list = list.tail
                currentIndex--
            }
            // head of list is now the element to read
            guard case let ListNode.Interior(element, _) = list.headNode else {
                abort()
            }
            return element
        }
        set {
            var currentIndex = index
            var skippedElements = Array<Element>()
            var list = self
            while currentIndex > 0 {
                skippedElements.append(list.head)
                list = list.tail
                currentIndex--
            }
            // head of list is now the element to update
            guard case let ListNode.Interior(_, nextNode) = list.headNode else {
                abort()
            }
            list.headNode = .Interior(element: newValue, nextNode: nextNode)
            while let precedingElement = skippedElements.popLast() {
                list = list.cons(precedingElement)
            }
            self = list
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
