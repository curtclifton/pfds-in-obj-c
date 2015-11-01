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

extension BinaryTree: PFDSSet {
    var isEmpty: Bool {
        switch self {
        case .Empty:
            return true
        default:
            return false
        }
    }
    
    mutating func insert(newElement: Element) {
        switch self {
        case .Empty:
            self = .Node(element: newElement, left: .Empty, right: .Empty)
        case .Node(let element, var left, var right):
            if newElement < element {
                left.insert(newElement)
            } else if newElement > element {
                right.insert(newElement)
            } else {
                return
            }
            self = .Node(element: element, left: left, right: right)
        }
    }
    
    func member(elementToFind: Element) -> Bool {
        switch self {
        case .Empty:
            return false
        case let .Node(element, left, right):
            if elementToFind < element {
                return left.member(elementToFind)
            } else if elementToFind > element {
                return right.member(elementToFind)
            } else {
                return true
            }
        }
    }
}