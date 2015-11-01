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
    // NOTE: Going all-in on mutating value types. The idea is to use the information sharing from the text, while making the interface Swifty.
    mutating func insert(element: Element)
    mutating func remove(element: Element)
    func member(element: Element) -> Bool
}

enum BinaryTree<Element: Comparable> {
    case Empty
    indirect case Node(element: Element, left: BinaryTree<Element>, right: BinaryTree<Element>)
}

extension BinaryTree: Equatable {
}
func ==<Element: Comparable>(lhs: BinaryTree<Element>, rhs: BinaryTree<Element>) -> Bool {
    switch (lhs, rhs) {
    case (.Empty, .Empty):
        return true
    case let (.Node(lhsElement, lhsLeft, lhsRight), .Node(rhsElement, rhsLeft, rhsRight)):
        return lhsElement == rhsElement && lhsLeft == rhsLeft && lhsRight == rhsRight
    default:
        return false
    }
}


private enum BinaryTreeEscape: ErrorType {
    case NotReallyAnErrorButWeAlreadyHaveElement(element: Any)
    case NotReallyAnErrorButWeDoNotHaveElement(element: Any)
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
    // Extended to solve Ex. 2.4.
    private mutating func insertIfNecessary(newElement: Element, possibleMatch: Element?) throws {
        switch self {
        case .Empty:
            if possibleMatch == newElement {
                print("🎉")
                throw BinaryTreeEscape.NotReallyAnErrorButWeAlreadyHaveElement(element: newElement)
            } else {
                self = .Node(element: newElement, left: .Empty, right: .Empty)
            }
        case .Node(let element, var left, var right):
            if newElement < element {
                try left.insertIfNecessary(newElement, possibleMatch: possibleMatch)
            } else {
                try right.insertIfNecessary(newElement, possibleMatch: element)
            }
            self = .Node(element: element, left: left, right: right)
        }
    }
    
    mutating func insert(newElement: Element) {
        do {
            try insertIfNecessary(newElement, possibleMatch: nil)
        } catch is BinaryTreeEscape {
            // Using errors for control flow, I feel dirty. However, the item already exists, so do nothing.
        } catch {
            abort()
        }
    }

    private mutating func removeMinimumElement() -> Element? {
        switch self {
        case .Empty:
            return nil
        case .Node(let element, .Empty, let right):
            // we're on the node with the minimum element
            self = right
            return element
        case .Node(let element, var left, let right):
            let result = left.removeMinimumElement()
            self = .Node(element: element, left: left, right: right)
            return result
        }
    }
    
    private mutating func removeIfNecessary(elementToRemove: Element) throws {
        switch self {
        case .Empty:
            print("🎉")
            throw BinaryTreeEscape.NotReallyAnErrorButWeDoNotHaveElement(element: elementToRemove)
        case .Node(elementToRemove, .Empty, .Empty):
            self = .Empty
        case .Node(elementToRemove, let left, .Empty):
            self = left
        case .Node(elementToRemove, .Empty, let right):
            self = right
        case .Node(elementToRemove, let left, var right):
            // need to remove the current node, should replace it with the minimum element of the right subtree
            let minimumElement = right.removeMinimumElement()
            self = .Node(element: minimumElement!, left: left, right: right)
        case .Node(let element, var left, var right):
            if elementToRemove < element {
                try left.removeIfNecessary(elementToRemove)
            } else {
                // because of == checks on elementToRemove in cases above, we know:
                assert(elementToRemove > element)
                try right.removeIfNecessary(elementToRemove)
            }
            self = .Node(element: element, left: left, right: right)
        }
    }

    mutating func remove(element: Element) {
        do {
            try removeIfNecessary(element)
        } catch is BinaryTreeEscape {
            // Using errors for control flow, I feel dirty. However, the item isn't there, so do nothing.
        } catch {
            abort()
        }
    }
    
    // Solution to Ex. 2.2. This seemed inefficient to me at first, since we keep delving deeper in the tree looking for matches, even though we might have passed a match on the way down. This reduces the number of comparisons in the worst case from 2d (where d is the depth of the tree) to d + 1. The best case is now d + 1 if the tree is perfectly balanced. However, the cases where we would early out with a match in the standard implementation are actually fairly small, as most nodes in the tree are quite deep. (Half the nodes are at the leaves if the tree is perfectly balanced!)
    private func elementMatchingElement(elementToFind: Element, bestCandidate: Element?) -> Element? {
        switch self {
        case .Empty:
            return (bestCandidate == elementToFind) ? bestCandidate : nil
        case let .Node(element, left, right):
            if elementToFind < element {
                return left.elementMatchingElement(elementToFind, bestCandidate: bestCandidate)
            } else {
                return right.elementMatchingElement(elementToFind, bestCandidate: element)
            }
        }
    }
    
    func member(elementToFind: Element) -> Bool {
        return self[elementToFind] != nil
    }
    
    subscript(element: Element) -> Element? {
        get {
            return elementMatchingElement(element, bestCandidate: nil)
        }
    }
}

extension BinaryTree: CustomStringConvertible {
    private func descriptionWithIndentLevel(indentLevel: String) -> String {
        var string = ""
        string.appendContentsOf(indentLevel)
        switch self {
        case .Empty:
            string.appendContentsOf("•\n")
        case let .Node(element, left, right):
            string.appendContentsOf("\(element)\n")
            string.appendContentsOf(left.descriptionWithIndentLevel(indentLevel + "|  "))
            string.appendContentsOf(right.descriptionWithIndentLevel(indentLevel + "|  "))
        }
        return string
    }
    
    var description: String {
        let result = descriptionWithIndentLevel("")
        return result
    }
}

extension Int {
    var isEven: Bool {
        return 2 * (self / 2) == self
    }
}

enum Direction {
    case Left
    case Right
}

// Ex. 2.5.
extension BinaryTree {
    static func completeTreeWithDepth(depth: Int) -> BinaryTree<String> {
        if depth == 0 { return .Empty }
        let subtree = BinaryTree.completeTreeWithDepth(depth - 1)
        return .Node(element: "x", left: subtree, right: subtree)
    }
    
    private static func pathToNodeToRemove(var knownSize: Int) -> [Direction] {
        // 2 = 0b10, remove left
        // 3 = 0b11, remove right
        // 4 = 0b100, remove left of left
        // 5 = 0b101, remove right of left
        // 6 = 0b110, remove left of right
        // 7 = 0b111, remove right of right
        var result: [Direction] = []
        while knownSize > 1 {
            result.append(knownSize.isEven ? .Left : .Right)
            knownSize >>= 1
        }
        return result
    }
    
    private mutating func removeNodeAtPath(var path: [Direction], index: Int) {
        let direction = path[index]
        switch self {
        case .Empty:
            abort()
        case .Node(let element, var left, var right):
            if index == path.count - 1 {
                // remove now
                if direction == .Left {
                    assert(right == .Empty)
                    self = .Node(element: element, left: right, right: right)
                } else {
                    self = .Node(element: element, left: left, right: .Empty)
                }
            } else {
                // recurse
                if direction == .Left {
                    left.removeNodeAtPath(path, index: index + 1)
                } else {
                    right.removeNodeAtPath(path, index: index + 1)
                }
                self = .Node(element: element, left: left, right: right)
            }
        }
    }
    
    private mutating func removeANode(knownSize: Int) {
        assert(knownSize >= 2)
        let path = BinaryTree.pathToNodeToRemove(knownSize)
        removeNodeAtPath(path, index: 0)
    }
    
    private static func treesOfSizeAbout(m: Int) -> (BinaryTree<Int>, BinaryTree<Int>) {
        if m == 0 {
            let empty: BinaryTree<Int> = .Empty
            return (.Node(element: -1, left: empty, right: empty), empty)
        }
        
        let left = BinaryTree.treeOfSize(m + 1)
        var right = left
        right.removeANode(m + 1)
        return (left, right)
    }
    
    static func treeOfSize(n: Int) -> BinaryTree<Int> {
        if n == 0 { return .Empty }
        let childrenNeeded = n - 1
        let halfFloored = childrenNeeded / 2
        if childrenNeeded.isEven {
            // evenly divisible
            let subtree = BinaryTree.treeOfSize(halfFloored)
            return .Node(element: 0, left: subtree, right: subtree)
        } else {
            let (leftSubtree, rightSubtree) = BinaryTree.treesOfSizeAbout(halfFloored)
            return .Node(element: 0, left: leftSubtree, right: rightSubtree)
        }
    }
}

// Ex. 2.6
protocol FiniteMap {
    typealias Key
    typealias Value
    
    subscript(key: Key) -> Value { get set }
}

// -------------------------------------------------------------------------
// This pair is kind of weird. We're implementing comparable merely on the keys. The value is incidental.
private struct KeyValuePair<Key: Comparable, Value>: Comparable {
    let key: Key
    let value: Value?
}

private func < <Key, Value>(lhs: KeyValuePair<Key, Value>, rhs: KeyValuePair<Key, Value>) -> Bool {
    return lhs.key < rhs.key
}

private func == <Key, Value>(lhs: KeyValuePair<Key, Value>, rhs: KeyValuePair<Key, Value>) -> Bool {
    return lhs.key == rhs.key
}
// -------------------------------------------------------------------------

struct FiniteMapTree<Key: Comparable, Value>: FiniteMap {
    private var backingTree: BinaryTree<KeyValuePair<Key, Value>> = .Empty
    
    subscript(key: Key) -> Value? {
        get {
            let pair = backingTree[KeyValuePair(key: key, value: nil)]
            return pair?.value
        }
        set {
            // Because backingTree does nothing on insertion of existing item, and we might be changing the value, which isn't used in comparisons, we first remove the key, then reinsert
            let pair = KeyValuePair(key: key, value: newValue)
            backingTree.remove(pair)
            backingTree.insert(pair)
        }
    }
}

