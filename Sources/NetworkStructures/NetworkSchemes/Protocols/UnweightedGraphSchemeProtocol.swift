//
//  UnweightedGraphSchemeProtocol.swift
//  SpelledPitch
//
//  Created by Benjamin Wetherfield on 03/11/2018.
//

import DataStructures

public protocol UnweightedGraphSchemeProtocol: GraphSchemeProtocol {
    init (_ contains: @escaping (Edge) -> Bool)
}

extension UnweightedGraphSchemeProtocol {
    
    @inlinable
    public func pullback <H> (_ f: @escaping (H.Node) -> Node) -> H where
        H: UnweightedGraphSchemeProtocol
    {
        return H { self.contains(Edge(f($0.a),f($0.b))) }
    }
    
    @inlinable
    public func pullback <H> (_ f: @escaping (H.Node) -> Node?) -> H where
        H: UnweightedGraphSchemeProtocol
    {
        return H {
            guard let a = f($0.a), let b = f($0.b) else { return false }
            return self.contains(Edge(a, b)) }
    }
}
