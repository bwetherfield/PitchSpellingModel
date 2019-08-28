//
//  NetworkScheme.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/28/19.
//

import DataStructures
import GraphSchemes

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

extension NetworkScheme {
    public func containsEdge(from start: FlowNode<InnerNode>, to end: FlowNode<InnerNode>) -> Bool {
        return contains(Edge(start, end))
    }
}
