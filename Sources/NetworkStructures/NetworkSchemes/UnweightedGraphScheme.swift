//
//  UnweightedGraphScheme.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 1/14/20.
//

import DataStructures

public struct UnweightedGraphScheme<Node: Hashable>: UnweightedGraphSchemeProtocol & DirectedGraphSchemeProtocol {
    
    public typealias Edge = OrderedPair<Node>
    
    public let contains: (Edge) -> Bool
    
    public init(_ contains: @escaping (Edge) -> Bool) {
        self.contains = contains
    }
}

extension UnweightedGraphScheme {
    public var lifted: NetworkScheme<Node> {
        return NetworkScheme(lift(includesSourceAndSinkEdges: true, contains))
    }
}
