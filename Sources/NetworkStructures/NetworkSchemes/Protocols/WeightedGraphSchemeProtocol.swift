//
//  WeightedGraphSchemeProtocol.swift
//  SpelledPitch
//
//  Created by Benjamin Wetherfield on 03/11/2018.
//

import DataStructures

public protocol WeightedGraphSchemeProtocol: GraphSchemeProtocol {
    associatedtype Weight: Numeric
    
    var weight: (Edge) -> Weight? { get }
    
    init (_ weight: @escaping (Edge) -> Weight?)
}

extension WeightedGraphSchemeProtocol {
    @inlinable
    public func pullback <H> (_ path: KeyPath<H.Node, Node>) -> H where
        H: WeightedGraphSchemeProtocol,
        H.Weight == Weight
    {
        return pullback { $0[keyPath: path] }
    }
    
    @inlinable
    public func pullback <H> (_ f: @escaping (H.Node) -> Node) -> H where
        H: WeightedGraphSchemeProtocol,
        H.Weight == Weight
    {
        return H { self.weight(from: f($0.a), to: f($0.b)) }
    }
    
    @inlinable
    public func pullback <H> (_ path: KeyPath<H.Node, Node?>) -> H where
        H: WeightedGraphSchemeProtocol,
        H.Weight == Weight
    {
        return pullback { $0[keyPath: path] }
    }
    
    @inlinable
    public func pullback <H> (_ f: @escaping (H.Node) -> Node?) -> H where
        H: WeightedGraphSchemeProtocol,
        H.Weight == Weight
    {
        return H {
            guard let a = f($0.a), let b = f($0.b) else { return nil }
            return self.weight(from: a, to: b)
        }
    }
    
    @inlinable
    public func weight (from start: Node, to end: Node) -> Weight? {
        return weight(Edge(start, end))
    }
    
    public var contains: (Edge) -> Bool {
        return { self.weight($0) != nil ? true : false }
    }
}

extension WeightedGraphSchemeProtocol {

    public static func + (lhs: Self, rhs: Self) -> Self {
        return Self { edge in
            guard let left = lhs.weight(edge) else {
                return rhs.weight(edge)
            }
            guard let right = rhs.weight(edge) else {
                return left
            }
            return left + right
        }
    }

    public static func * (lhs: Self, rhs: Self) -> Self {
        return Self { edge in
            if let left = lhs.weight(edge), let right = rhs.weight(edge) {
                return left * right
            } else {
                return nil
            }
        }
    }
    
    public static func *<H> (lhs: Self, rhs: H) -> Self
        where H: UnweightedGraphSchemeProtocol, H.Edge == Edge {
        return Self { edge in
            return rhs.contains(edge) ? lhs.weight(edge) : nil
        }
    }
    
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    public static func *=<H> (lhs: inout Self, rhs: H)
        where H: UnweightedGraphSchemeProtocol, H.Edge == Edge {
        lhs = lhs * rhs
    }
}
