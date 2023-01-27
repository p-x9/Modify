import Foundation

@dynamicMemberLookup
public struct DynamicMemberWrap<T> {
    private var value: T

    public init(_ value: T) {
        self.value = value
    }

    @_disfavoredOverload
    public subscript<U>(dynamicMember keyPath: WritableKeyPath<T, U>) -> ((U) -> DynamicMemberWrap<T>) {
        { val in
            var value = self.value
            value[keyPath: keyPath] = val
            return DynamicMemberWrap(value)
        }
    }

    public subscript<U>(dynamicMember keyPath: WritableKeyPath<T, U>) -> ((U) -> T) {
        { val in
            var value = self.value
            value[keyPath: keyPath] = val
            return value
        }
    }

    @_disfavoredOverload
    public func modify(_ block: ((inout T) -> Void)) -> DynamicMemberWrap<T> {
        var value = self.value
        block(&value)
        return DynamicMemberWrap(value)
    }

    public func modify(_ block: ((inout T) -> Void)) -> T {
        var value = self.value
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

    @_disfavoredOverload
    public subscript<U>(dynamicMember keyPath: WritableKeyPath<T, U>) -> ((U) -> AssignmentDynamicMemberWrap<T>) {
        { val in
            pointer.pointee[keyPath: keyPath] = val
            return AssignmentDynamicMemberWrap(&pointer.pointee)
        }
    }

    public subscript<U>(dynamicMember keyPath: WritableKeyPath<T, U>) -> ((U) -> Void) {
        { val in
            pointer.pointee[keyPath: keyPath] = val
        }
    }

    @_disfavoredOverload
    public func modify(_ block: ((inout T) -> Void)) -> AssignmentDynamicMemberWrap<T> {
        block(&pointer.pointee)
        return AssignmentDynamicMemberWrap(&pointer.pointee)
    }

    public func modify(_ block: ((inout T) -> Void)) {
        block(&pointer.pointee)
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
