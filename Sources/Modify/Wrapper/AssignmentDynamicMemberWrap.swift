//
//  AssignmentDynamicMemberWrap.swift
//  
//
//  Created by p-x9 on 2023/01/29.
//  
//

import Foundation

@dynamicMemberLookup
public struct AssignmentDynamicMemberWrap<T> {
    private var pointer: UnsafeMutablePointer<T>

    public init(_ value: inout T) {
        self.pointer = withUnsafeMutablePointer(to: &value) { $0 }
    }

    @discardableResult
    public func callAsFunction(_ block: ((inout T) -> Void)) -> AssignmentDynamicMemberWrap<T> {
        modify(block)
    }

    public subscript<U>(dynamicMember keyPath: WritableKeyPath<T, U>) -> DiscardableResultClosure<U, AssignmentDynamicMemberWrap<T>> {
        DiscardableResultClosure { val in
            pointer.pointee[keyPath: keyPath] = val
            return AssignmentDynamicMemberWrap(&pointer.pointee)
        }
    }

    @discardableResult
    public func modify(_ block: ((inout T) -> Void)) -> AssignmentDynamicMemberWrap<T> {
        block(&pointer.pointee)
        return AssignmentDynamicMemberWrap(&pointer.pointee)
    }
}
