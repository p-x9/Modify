//
//  DiscardableResultClosure.swift
//  
//
//  Created by p-x9 on 2023/01/28.
//  
//

import Foundation

public struct DiscardableResultClosure<T, U> {
    var closure: (T) -> U

    @discardableResult
    public func callAsFunction(_ arg: T) -> U {
        closure(arg)
    }
}
