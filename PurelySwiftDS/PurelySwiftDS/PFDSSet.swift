//
//  PFDSSet.swift
//  PurelySwiftDS
//
//  Created by Curt Clifton on 10/31/15.
//  Copyright © 2015 curtclifton.net. All rights reserved.
//

import Foundation

// NOTE: prefixed to avoid collision with Swift.Set
protocol PFDSSet {
    typealias Element
    
    var isEmpty: Bool { get }
    // CCC, 10/31/2015. Going all-in on mutating value types? The idea is to use the information sharing from the text, while making the interface Swifty.
    mutating func insert(element: Element)
    func member(element: Element) -> Bool
}

enum BinaryTree<Element: Comparable> {
    case Empty
    indirect case Node(element: Element, left: BinaryTree<Element>, right: BinaryTree<Element>)
}

private enum BinaryTreeEscape: ErrorType {
    case NotReallyAnErrorButWeAlreadyHaveElement(element: Any)
}

extension BinaryTree: PFDSSet {
    var isEmpty: Bool {
        switch self {
        case .Empty:
            return true
        default:
            return false
        }
    }
    
    // Solution to Ex. 2.3. This is a horrible abuse of throws, or is it?
    private mutating func insertIfNecessary(newElement: Element) throws {
        switch self {
        case .Empty:
            self = .Node(element: newElement, left: .Empty, right: .Empty)
        case .Node(let element, var left, var right):
            if newElement < element {
                try left.insertIfNecessary(newElement)
            } else if newElement > element {
                try right.insertIfNecessary(newElement)
            } else {
                print("🎉")
                throw BinaryTreeEscape.NotReallyAnErrorButWeAlreadyHaveElement(element: newElement)
            }
            self = .Node(element: element, left: left, right: right)
        }
    }
    
    mutating func insert(newElement: Element) {
        do {
            try insertIfNecessary(newElement)
        } catch is BinaryTreeEscape {
            // Using errors for control flow, I feel dirty. However, the item already exists, so do nothing.
        } catch {
            abort()
        }
    }

    // Solution to Ex. 2.2. This seemed inefficient to me at first, since we keep delving deeper in the tree looking for matches, even though we might have passed a match on the way down. This reduces the number of comparisons in the worst case from 2d (where d is the depth of the tree) to d + 1. The best case is now d + 1 if the tree is perfectly balanced. However, the cases where we would early out with a match in the standard implementation are actually fairly small, as most nodes in the tree are quite deep. (Half the nodes are at the leaves if the tree is perfectly balanced!)
    private func member(elementToFind: Element, bestCandidate: Element?) -> Bool {
        switch self {
        case .Empty:
            return bestCandidate == elementToFind
        case let .Node(element, left, right):
            if elementToFind < element {
                return left.member(elementToFind, bestCandidate: bestCandidate)
            } else {
                return right.member(elementToFind, bestCandidate: element)
            }
        }
    }
    
    func member(elementToFind: Element) -> Bool {
        return member(elementToFind, bestCandidate: nil)
    }
}