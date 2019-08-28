//
//  UnweightedNetworkSchemeProtocol.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/28/19.
//

import GraphSchemes

public protocol UnweightedNetworkSchemeProtocol: NetworkSchemeProtocol, UnweightedGraphSchemeProtocol { }

extension UnweightedNetworkSchemeProtocol {
    public func pullback<H>(_ f: @escaping (H.InnerNode) -> InnerNode) -> H where H: UnweightedNetworkSchemeProtocol {
        return pullback(bind(f))
    }
}

extension UnweightedNetworkSchemeProtocol {
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        return Self { edge in lhs.contains(edge) || rhs.contains(edge) }
    }
}
