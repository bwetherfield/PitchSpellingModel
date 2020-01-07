//
//  NetworkScheme.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/28/19.
//

import DataStructures

public struct NetworkScheme<InnerNode: Hashable>: UnweightedNetworkSchemeProtocol {
    
    public typealias Node = FlowNode<InnerNode>
    public typealias Edge = OrderedPair<Node>
    
    public let contains: (Edge) -> Bool
}

extension NetworkScheme {
    public init(_ contains: @escaping (Edge) -> Bool) {
        self.contains = contains
    }
}
