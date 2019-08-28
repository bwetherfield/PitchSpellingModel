//
//  NetworkScheme.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/28/19.
//

import DataStructures
import GraphSchemes

struct NetworkScheme<InnerNode: Hashable>: UnweightedNetworkSchemeProtocol{
    
    typealias Node = FlowNode<InnerNode>
    typealias Edge = OrderedPair<Node>
    
    let contains: (Edge) -> Bool
}

extension NetworkScheme {
    init(_ contains: @escaping (Edge) -> Bool) {
        self.contains = contains
    }
}

extension NetworkScheme {
    func containsEdge(from start: FlowNode<InnerNode>, to end: FlowNode<InnerNode>) -> Bool {
        return contains(Edge(start, end))
    }
}
