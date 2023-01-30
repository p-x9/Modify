import Foundation

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
