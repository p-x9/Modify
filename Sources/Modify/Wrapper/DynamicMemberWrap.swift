//
//  DynamicMemberWrap.swift
//  
//
//  Created by p-x9 on 2023/01/29.
//  
//

import Foundation

@dynamicMemberLookup
public struct DynamicMemberWrap<T> {
    private var _value: T

    public var value: T {
        _value
    }

    public init(_ value: T) {
        self._value = value
    }

    public func callAsFunction(_ block: ((inout T) -> Void)) -> DynamicMemberWrap<T> {
        modify(block)
    }

    @_disfavoredOverload
    public func callAsFunction(_ block: ((inout T) -> Void)) -> T {
        modify(block)
    }

    public subscript<U>(dynamicMember keyPath: WritableKeyPath<T, U>) -> ((U) -> DynamicMemberWrap<T>) {
        { val in
            var value = self._value
            value[keyPath: keyPath] = val
            return DynamicMemberWrap(value)
        }
    }

    @_disfavoredOverload
    public subscript<U>(dynamicMember keyPath: WritableKeyPath<T, U>) -> ((U) -> T) {
        { val in
            var value = self._value
            value[keyPath: keyPath] = val
            return value
        }
    }

    public func modify(_ block: ((inout T) -> Void)) -> DynamicMemberWrap<T> {
        var value = self._value
        block(&value)
        return DynamicMemberWrap(value)
    }

    @_disfavoredOverload
    public func modify(_ block: ((inout T) -> Void)) -> T {
        var value = self._value
        block(&value)
        return value
    }
}
