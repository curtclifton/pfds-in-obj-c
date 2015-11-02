//
//  Heap.swift
//  PurelySwiftDS
//
//  Created by Curt Clifton on 11/1/15.
//  Copyright © 2015 curtclifton.net. All rights reserved.
//

import Foundation

enum HeapError: ErrorType {
    case EmptyHeap
}

protocol Heap {
    typealias Element: Comparable
    
    var isEmpty: Bool { get }
    
    mutating func insert(element: Element)
    mutating func deleteMin() throws
    
    func merge(otherHeap: Self) -> Self
    func findMin() throws -> Element
}

enum LeftistHeap<Element: Comparable> {
    case Empty
    indirect case Node(rank: Int, element: Element, left: LeftistHeap<Element>, right: LeftistHeap<Element>)
    
    var rank: Int {
        switch self {
        case .Empty:
            return 0
        case .Node(let rank, _, _, _):
            return rank
        }
    }
}

extension LeftistHeap: Heap {
    var isEmpty: Bool {
        switch self {
        case .Empty:
            return true
        default:
            return false
        }
    }
    
    mutating func insert(element: Element) {
        self = self.merge(.Node(rank: 1, element: element, left: .Empty, right: .Empty))
    }
    
    mutating func deleteMin() throws {
        switch self {
        case .Empty:
            throw HeapError.EmptyHeap
        case let .Node(_, _, left, right):
            self = left.merge(right)
        }
    }
    
    private func makeTreeWithRootElement(rootElement: Element, heap1: LeftistHeap<Element>, heap2: LeftistHeap<Element>) -> LeftistHeap<Element> {
        if heap1.rank >= heap2.rank {
            return .Node(rank: heap2.rank + 1, element: rootElement, left: heap1, right: heap2)
        } else {
            return .Node(rank: heap1.rank + 1, element: rootElement, left: heap2, right: heap1)
        }
    }
    
    func merge(otherHeap: LeftistHeap<Element>) -> LeftistHeap<Element> {
        switch (self, otherHeap) {
        case (let nonEmpty, .Empty):
            return nonEmpty
        case (.Empty, let nonEmpty):
            return nonEmpty
        case let (.Node(_, lhsElement, lhsLeft, lhsRight), .Node(_, rhsElement, rhsLeft, rhsRight)):
            if lhsElement <= rhsElement {
                return makeTreeWithRootElement(lhsElement, heap1: lhsLeft, heap2: lhsRight.merge(otherHeap))
            } else {
                return makeTreeWithRootElement(rhsElement, heap1: rhsLeft, heap2: self.merge(rhsRight))
            }
        default:
            // cases are really exhaustive, but somehow the compiler isn't discovering that
            abort()
        }
    }
    
    func findMin() throws -> Element {
        switch self {
        case .Empty:
            throw HeapError.EmptyHeap
        case .Node(_, let element, _, _):
            return element
        }
    }
}
