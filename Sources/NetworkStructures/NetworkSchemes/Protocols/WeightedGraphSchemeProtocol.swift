//
//  WeightedGraphSchemeProtocol.swift
//  SpelledPitch
//
//  Created by Benjamin Wetherfield on 03/11/2018.
//

import DataStructures

public protocol WeightedGraphSchemeProtocol: GraphSchemeProtocol {
    
    // MARK: - Associated Types
    
    associatedtype Weight: Numeric
    
    var weight: (Edge) -> Weight? { get }
    
    init (_ weight: @escaping (Edge) -> Weight?)
}

extension WeightedGraphSchemeProtocol {
    
    /// - Returns:`FlowNetworkSchemeProtocol`constructed  by deriving weights from `self`
    /// using `f` map over `Node` types.
    @inlinable
    public func pullback <H> (_ f: @escaping (H.Node) -> Node) -> H where
        H: WeightedGraphSchemeProtocol,
        H.Weight == Weight
    {
        return H { self.weight(from: f($0.a), to: f($0.b)) }
    }

    /// - Returns: `FlowNetworkSchemeProtocol` constructed  by deriving weights from `self`
    /// using `f` map over `Node` types optional return values.
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

    /// - Returns: `Self` type summing edges present in `lhs` and `rhs`
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

    /// - Returns: `Self` type multiplying edges present in `lhs` and `rhs`using `Optional` monad
    public static func * (lhs: Self, rhs: Self) -> Self {
        return Self { edge in
            if let left = lhs.weight(edge), let right = rhs.weight(edge) {
                return left * right
            } else {
                return nil
            }
        }
    }
    
    /// - Returns: `UnweightedGraphSchemeProtocol` with edges retained if they are presen tin `rhs`
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
