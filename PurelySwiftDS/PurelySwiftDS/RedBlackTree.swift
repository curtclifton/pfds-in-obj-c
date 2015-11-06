//
//  RedBlackTree.swift
//  CountedSet
//
//  Created by Curt Clifton on 11/2/15.
//  Copyright © 2015 curtclifton.net. All rights reserved.
//

// An implementation of Red-Black trees based on Okasaki's Purely Functional Data Structures, extended with delete as in http://matt.might.net/articles/red-black-delete/

import Foundation

// CCC, 11/3/2015. replace abort() with throws

enum Color: Int {
    case NegativeBlack = 0
    case Red
    case Black
    case DoubleBlack
    
    var redder: Color {
        guard let result = Color(rawValue: rawValue - 1) else {
            abort()
        }
        return result
    }

    var blacker: Color {
        guard let result = Color(rawValue: rawValue + 1) else {
            abort()
        }
        return result
    }
}

enum RedBlackTree<Element: Comparable> {
    case Empty(color: Color)
    indirect case Node(color: Color, left: RedBlackTree<Element>, element: Element, right: RedBlackTree<Element>)
    
    // By default, empty nodes are black. They only get other colors while a deletion if being propagated.
    static func empty<Element: Comparable>() -> RedBlackTree<Element> {
        return .Empty(color: .Black)
    }
    
    private static func fromSortedArraySlice<Element: Comparable>(slice: ArraySlice<Element>) -> RedBlackTree<Element> {
        let count = slice.count
        switch count {
        case 0:
            return RedBlackTree.empty()
        case 1:
            let empty: RedBlackTree<Element> = RedBlackTree.empty()
            return .Node(color: .Black, left: empty, element: slice.first!, right: empty)
        case 2:
            let empty: RedBlackTree<Element> = RedBlackTree.empty()
            let smallerElement = slice.first!
            let largerElement = slice.last!
            let smallerTree: RedBlackTree<Element> = .Node(color: .Red, left: empty, element: smallerElement, right: empty)
            return .Node(color: .Black, left: smallerTree, element: largerElement, right: empty)
        default:
            let middleIndex = slice.startIndex + (count / 2)
            let element = slice[middleIndex]
            let leftSlice = slice.prefixUpTo(middleIndex)
            let rightSlice = slice.suffixFrom(middleIndex + 1)
            let leftTree: RedBlackTree<Element> = RedBlackTree.fromSortedArraySlice(leftSlice)
            let rightTree: RedBlackTree<Element> = RedBlackTree.fromSortedArraySlice(rightSlice)
            return .Node(color: .Black, left: leftTree, element: element, right: rightTree)
        }
    }
    
    // Ex. 3.9
    static func fromSortedArray<Element: Comparable>(array: [Element]) -> RedBlackTree<Element> {
        let arraySlice = array.prefixUpTo(array.count)
        return RedBlackTree.fromSortedArraySlice(arraySlice)
    }
    
    var isEmpty: Bool {
        switch self {
        case .Empty:
            return true
        default:
            return false
        }
    }
    
    var maxElement: Element? {
        switch self {
        case .Empty:
            return nil
        case .Node(_, _, let element, .Empty):
            return element
        case .Node(_, _, _, let right):
            return right.maxElement
        }
    }
    
    func contains(element: Element) -> Bool {
        return contains(element, candidateMatch: nil)
    }
    
    mutating func insert(element: Element) {
        insertHelper(element)
        blacken()
    }
    
    mutating func remove(element: Element) {
        deleteHelper(element)
        blacken()
    }

    //MARK: - Private API
    private func contains(element: Element, candidateMatch: Element?) -> Bool {
        switch self {
        case .Empty:
            return element == candidateMatch
        case let .Node(_, left, nodeElement, right):
            if element < nodeElement {
                return left.contains(element, candidateMatch: candidateMatch)
            } else {
                return right.contains(element, candidateMatch: nodeElement)
            }
        }
    }
    
    private var color: Color {
        switch self {
        case .Empty(let color):
            return color
        case .Node(let color, _, _, _):
            return color
        }
    }
    
    private mutating func redden() {
        switch self {
        case .Empty:
            abort()
        case let .Node(_, left, element, right):
            self = .Node(color: .Red, left: left, element: element, right: right)
        }
    }
    
    private mutating func blacken() {
        switch self {
        case .Empty(.Black):
            return
        case .Empty(_):
            self = .Empty(color: .Black)
        case let .Node(_, left, element, right):
            self = .Node(color: .Black, left: left, element: element, right: right)
        }
    }
    
    private mutating func redder() {
        switch self {
        case .Empty(.DoubleBlack):
            self = .Empty(color: .Black)
        case .Empty(_):
            abort()
        case let .Node(color, left, element, right):
            self = .Node(color: color.redder, left: left, element: element, right: right)
        }
    }
    
    private mutating func blacker() {
        switch self {
        case .Empty(.Black):
            self = .Empty(color: .DoubleBlack)
        case .Empty(_):
            abort()
        case let .Node(color, left, element, right):
            self = .Node(color: color.blacker, left: left, element: element, right: right)
        }
    }
    
    private var isDoubleBlack: Bool {
        return color == .DoubleBlack
    }
    
    // See Purely Functional Data Structures, figure 3.5. Generalized per http://matt.might.net/articles/red-black-delete/
    // I've mostly cribbed Might's Haskell implementation here. After an attempt at using sensible variable names, it turns out that the length obscures the message. So instead, variable names are based on the figures in the Okasaki and Might's post.
    private mutating func balance() {
        let isBlackOrDoubleBlack = (color == .Black || color == .DoubleBlack) // let's us combine Okasaki's cases with the first four of Might's
        switch (isBlackOrDoubleBlack, self) {
        case (_, .Empty):
            return
            
        case let (true, .Node(color, .Node(.Red, .Node(.Red, a, x, b), y, c), z, d)):
            let newLeft: RedBlackTree<Element> = .Node(color: .Black, left: a, element: x, right: b)
            let newRight: RedBlackTree<Element> = .Node(color: .Black, left: c, element: z, right: d)
            self = .Node(color: color.redder, left: newLeft, element: y, right: newRight)
            
        case let (true, .Node(color, .Node(.Red, a, x, .Node(.Red, b, y, c)), z, d)):
            let newLeft: RedBlackTree<Element> = .Node(color: .Black, left: a, element: x, right: b)
            let newRight: RedBlackTree<Element> = .Node(color: .Black, left: c, element: z, right: d)
            self = .Node(color: color.redder, left: newLeft, element: y, right: newRight)
            
        case let (true, .Node(color, a, x, .Node(.Red, .Node(.Red, b, y, c), z, d))):
            let newLeft: RedBlackTree<Element> = .Node(color: .Black, left: a, element: x, right: b)
            let newRight: RedBlackTree<Element> = .Node(color: .Black, left: c, element: z, right: d)
            self = .Node(color: color.redder, left: newLeft, element: y, right: newRight)
            
        case let (true, .Node(color, a, x, .Node(.Red, b, y, .Node(.Red, c, z, d)))):
            let newLeft: RedBlackTree<Element> = .Node(color: .Black, left: a, element: x, right: b)
            let newRight: RedBlackTree<Element> = .Node(color: .Black, left: c, element: z, right: d)
            self = .Node(color: color.redder, left: newLeft, element: y, right: newRight)
            
        case let (true, .Node(.DoubleBlack, a, x, .Node(.NegativeBlack, .Node(.Black, b, y, c), z, d))):
            if d.color == .Black {
                let newLeft: RedBlackTree<Element> = .Node(color: .Black, left: a, element: x, right: b)
                var dd = d
                dd.redden()
                var newRight: RedBlackTree<Element> = .Node(color: .Black, left: c, element: z, right: dd)
                newRight.balance()
                self = .Node(color: .Black, left: newLeft, element: y, right: newRight)
            }
            
        case let (true, .Node(.DoubleBlack, .Node(.NegativeBlack, a, x, .Node(.Black, b, y, c)), z, d)):
            if a.color == .Black {
                var aa = a
                aa.redden()
                var newLeft: RedBlackTree<Element> = .Node(color: .Black, left: aa, element: x, right: b)
                newLeft.balance()
                let newRight: RedBlackTree<Element> = .Node(color: .Black, left: c, element: z, right: d)
                self = .Node(color: .Black, left: newLeft, element: y, right: newRight)
            }
            
        default:
            break
        }
    }
    
    private mutating func bubble() {
        switch self {
        case .Empty:
            // cannot bubble an empty tree
            abort()
        case .Node(let color, var left, let element, var right):
            if left.color == .DoubleBlack || right.color == .DoubleBlack {
                left.redder()
                right.redder()
                self = .Node(color: color.blacker, left: left, element: element, right: right)
            }
            self.balance()
        }
    }

    private mutating func insertHelper(element: Element) {
        switch self {
        case .Empty:
            // inject a potential red-red violation that will be percolated up to the root by balance()
            self = .Node(color: .Red, left: self, element: element, right: self)
        case .Node(let color, var left, let nodeElement, var right):
            if element == nodeElement {
                // already there, nothing to do
                return
            } else if element < nodeElement {
                left.insertHelper(element)
            } else {
                right.insertHelper(element)
            }
            self = .Node(color: color, left: left, element: nodeElement, right: right)
            self.balance()
        }
    }

    private mutating func deleteHelper(element: Element) {
        switch self {
        case .Empty:
            return
        case .Node(let color, var left, let nodeElement, var right):
            if element == nodeElement {
                removeRoot()
                return
            } else if element < nodeElement {
                left.deleteHelper(element)
            } else {
                right.deleteHelper(element)
            }
            self = .Node(color: color, left: left, element: nodeElement, right: right)
            self.bubble()
        }
    }
    
    private mutating func removeRoot() {
        switch self {
        case .Empty:
            return
        case .Node(.Red, .Empty, _, .Empty):
            self = .Empty(color: .Black)
        case .Node(.Black, .Empty, _, .Empty):
            self = .Empty(color: .DoubleBlack)
        case let .Node(.Black, .Empty, _, .Node(.Red, a, x, b)):
            self = .Node(color: .Black, left: a, element: x, right: b)
        case let .Node(.Black, .Node(.Red, a, x, b), _, .Empty):
            self = .Node(color: .Black, left: a, element: x, right: b)
        case .Node(let color, var left, _, let right):
            let newRootElement = left.maxElement! // left must be non-empty
            left.removeMax()
            self = .Node(color: color, left: left, element: newRootElement, right: right)
            self.bubble()
        }
    }
    
    private mutating func removeMax() {
        switch self {
        case .Empty:
            abort()
        case .Node(_, _, _, .Empty):
            self.removeRoot()
        case .Node(let color, let left, let element, var right):
            right.removeMax()
            self = .Node(color: color, left: left, element: element, right: right)
            self.bubble()
        }
    }
}

// invariants, Okasaki, p. 25
extension RedBlackTree {
    var noRedNodeHasARedChild: Bool {
        switch self {
        case .Empty:
            return true
        case .Node(.Red, .Node(.Red, _, _, _), _, _):
            return false
        case .Node(.Red, _, _, .Node(.Red, _, _, _)):
            return false
        case .Node(_, let left, _, let right):
            return left.noRedNodeHasARedChild && right.noRedNodeHasARedChild
        }
    }
    
    func blackPathLength() throws -> Int {
        switch self {
        case .Empty:
            // empty nodes are assumed to be black
            return 1
        case .Node(let color, let left, _, let right):
            let leftLength = try left.blackPathLength()
            let rightLength = try right.blackPathLength()
            guard leftLength == rightLength else {
                throw RedBlackTreeError.InvariantViolation(message: "mismatched black path lengths")
            }
            return leftLength + (color == .Black ? 1 : 0)
        }
    }
    
    var blackNodePathLengthsMatch: Bool {
        do {
            let _ = try blackPathLength()
            // no throw, so they must match
            return true
        } catch RedBlackTreeError.InvariantViolation(_) {
            return false
        } catch {
            print(error)
            abort()
        }
    }
}

enum RedBlackTreeError: ErrorType {
    case InvariantViolation(message: String)
}