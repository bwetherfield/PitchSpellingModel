//
//  UnweightedNetworkSchemeProtocol.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/28/19.
//

public protocol UnweightedNetworkSchemeProtocol: NetworkSchemeProtocol, UnweightedGraphSchemeProtocol { }

extension UnweightedNetworkSchemeProtocol {
    
    @inlinable
    public func pullback<H>(_ f: @escaping (H.InnerNode) -> InnerNode) -> H where
        H: UnweightedNetworkSchemeProtocol
    {
        return pullback(bind(f))
    }
    
    @inlinable
    public func pullback<H>(_ f: @escaping (H.InnerNode) -> InnerNode?) -> H where
        H: UnweightedNetworkSchemeProtocol
    {
        return pullback(bind(f))
    }
}

extension UnweightedNetworkSchemeProtocol {
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        return Self { edge in lhs.contains(edge) || rhs.contains(edge) }
    }
    
    public static func * (lhs: Self, rhs: Self) -> Self {
        return Self { edge in lhs.contains(edge) && rhs.contains(edge) }
    }
    
    public static func *<H, W> (lhs: W, rhs: Self) -> H where H: WeightedGraphSchemeProtocol,
        H.Edge == Edge, W == H.Weight {
        return H.init({ rhs.contains($0) ? lhs : nil })
    }
}

