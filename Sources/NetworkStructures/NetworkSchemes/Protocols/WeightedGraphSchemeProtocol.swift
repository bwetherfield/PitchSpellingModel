//
//  WeightedGraphSchemeProtocol.swift
//  SpelledPitch
//
//  Created by Benjamin Wetherfield on 03/11/2018.
//

import DataStructures

public protocol WeightedGraphSchemeProtocol: GraphSchemeProtocol {
    associatedtype Weight
    
    var weight: (Edge) -> Weight? { get }
    
    init (_ weight: @escaping (Edge) -> Weight?)
    
    func weight (from start: Node, to end: Node) -> Weight?
}

extension WeightedGraphSchemeProtocol {
    @inlinable
    public func pullback <H> (_ f: @escaping (H.Node) -> Node) -> H where
        H: WeightedGraphSchemeProtocol,
        H.Weight == Weight
    {
        return H { self.weight(from: f($0.a), to: f($0.b)) }
    }

    @inlinable
    func unweighted <H> () -> H where
        H: UnweightedGraphSchemeProtocol,
        H.Edge == Edge
    {
        return H { self.weight($0) != nil }
    }
}
