//
//  UnweightedNetworkSchemeProtocol.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/28/19.
//

public protocol UnweightedNetworkSchemeProtocol: NetworkSchemeProtocol, UnweightedGraphSchemeProtocol { }

extension UnweightedNetworkSchemeProtocol {
    
    /// - Returns: `UnweightedNetworkSchemeProtocol` constructed  by deriving adjacencies from `self`
    /// using `f` map over `InnerNode` types.
    @inlinable
    public func pullback<H>(_ f: @escaping (H.InnerNode) -> InnerNode) -> H where
        H: UnweightedNetworkSchemeProtocol
    {
        return pullback(bind(f))
    }
    
    /// - Returns: `UnweightedNetworkSchemeProtocol` constructed by deriving adjacencies from
    /// `self` using `f` map over `InnerNode` types with optional return value.
    @inlinable
    public func pullback<H>(_ f: @escaping (H.InnerNode) -> InnerNode?) -> H where
        H: UnweightedNetworkSchemeProtocol
    {
        return pullback(bind(f))
    }
}

extension UnweightedNetworkSchemeProtocol {
    
    /// - Returns: `Self` value, which retains edges present in `lhs` or `rhs`.
    public static func + (lhs: Self, rhs: Self) -> Self {
        return Self { edge in lhs.contains(edge) || rhs.contains(edge) }
    }
    
    /// - Returns: `Self` value, which retains edges present in both `lhs` and `rhs`.
    public static func * (lhs: Self, rhs: Self) -> Self {
        return Self { edge in lhs.contains(edge) && rhs.contains(edge) }
    }
    
    /// - Returns: weighted scheme which gives edges present fixed weight `lhs`.
    public static func *<H, W> (lhs: W, rhs: Self) -> H where H: WeightedGraphSchemeProtocol,
        H.Edge == Edge, W == H.Weight {
        return H.init({ rhs.contains($0) ? lhs : nil })
    }
}

