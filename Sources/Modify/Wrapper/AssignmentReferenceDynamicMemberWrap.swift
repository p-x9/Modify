//
//  AssignmentReferenceDynamicMemberWrap.swift
//  
//
//  Created by p-x9 on 2023/01/29.
//  
//

import Foundation

@dynamicMemberLookup
public struct AssignmentReferenceDynamicMemberWrap<T> where T: AnyObject {
    private var value: T

    public init(_ value: T) {
        self.value = value
    }

    @discardableResult
    public func callAsFunction(_ block: ((T) -> Void)) -> AssignmentReferenceDynamicMemberWrap<T> {
        modify(block)
    }

    public subscript<U>(dynamicMember keyPath: WritableKeyPath<T, U>) -> DiscardableResultClosure<U, AssignmentReferenceDynamicMemberWrap<T>> {
        DiscardableResultClosure { val in
            var value = self.value
            value[keyPath: keyPath] = val
            return AssignmentReferenceDynamicMemberWrap(value)
        }
    }

    @discardableResult
    public func modify(_ block: ((T) -> Void)) -> AssignmentReferenceDynamicMemberWrap<T> {
        block(value)
        return AssignmentReferenceDynamicMemberWrap(value)
    }
}
