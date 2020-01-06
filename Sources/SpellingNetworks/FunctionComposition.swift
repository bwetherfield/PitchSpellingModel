//
//  FunctionComposition.swift
//  SpellingNetworks
//
//  Created by Benjamin Wetherfield on 1/6/20.
//

infix operator >>>

public func >>> <A, B, C> (a2b: @escaping (A) -> B, b2c: @escaping (B) -> C) -> (A) -> C {
    return { b2c(a2b($0)) }
}

public func >>> <A, B, C> (a2b: @escaping (A) -> B?, b2c: @escaping (B) -> C) -> (A) -> C? {
    return { a in
        guard let b = a2b(a) else { return nil }
        return b2c(b)
    }
}
