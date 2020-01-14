//
//  FunctionComposition.swift
//  SpellingNetworks
//
//  Created by Benjamin Wetherfield on 1/6/20.
//


precedencegroup FunctionCompositionPrecedence {
    associativity: right
    higherThan: AdditionPrecedence
}

infix operator >>>: FunctionCompositionPrecedence
infix operator |||: AdditionPrecedence

/// - Returns: function composition of `a2b` and `b2c`.
public func >>> <A, B, C> (a2b: @escaping (A) -> B, b2c: @escaping (B) -> C) -> (A) -> C {
    return { b2c(a2b($0)) }
}

/// - Returns: function composition of `a2b` and `b2c`with optionals forwarded.
public func >>> <A, B, C> (a2b: @escaping (A) -> B?, b2c: @escaping (B) -> C) -> (A) -> C? {
    return { a in
        guard let b = a2b(a) else { return nil }
        return b2c(b)
    }
}

/// - Returns: function composition of `a2b` and `b2c`with optionals forwarded.
public func >>> <A, B, C> (a2b: @escaping (A) -> B?, b2c: @escaping (B) -> C?) -> (A) -> C? {
    return { a in
        guard let b = a2b(a) else { return nil }
        guard let c = b2c(b) else { return nil }
        return c
    }
}

/// - Returns: closure computing `first` or `second` if `first` returns `nil`
public func ||| <A, B> (first: @escaping (A) -> B?, second: @escaping (A) -> B?) -> (A) -> B? {
    return { first($0) ?? second($0) }
}
