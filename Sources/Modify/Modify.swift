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


postfix operator ^
postfix public func ^<T>(lhs: T) -> DynamicMemberWrap<T> {
    return DynamicMemberWrap(lhs)
}

postfix operator ^=
postfix public func ^=<T>(lhs: inout T) -> AssignmentDynamicMemberWrap<T> {
    return AssignmentDynamicMemberWrap(&lhs)
}

postfix public func ^=<T>(lhs: T) -> AssignmentReferenceDynamicMemberWrap<T> where T: AnyObject {
    return AssignmentReferenceDynamicMemberWrap(lhs)
}
