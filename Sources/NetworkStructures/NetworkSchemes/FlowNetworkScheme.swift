//
//  FlowNetworkScheme.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/28/19.
//

import DataStructures

public struct FlowNetworkScheme<InnerNode: Hashable>: FlowNetworkSchemeProtocol {
    public typealias Node = FlowNode<InnerNode>
    public typealias Edge = OrderedPair<Node>
    
    public let weight: (Edge) -> Double?
}

extension FlowNetworkScheme {
    public init(_ weight: @escaping (Edge) -> Double?) {
        self.weight = weight
    }
    
    public init(_ weight: [Edge: Double]) {
        self.weight = { weight[$0] }
    }
}

extension FlowNetworkScheme {
    public func weight(from start: FlowNode<InnerNode>, to end: FlowNode<InnerNode>) -> Double? {
        return weight(Edge(start, end))
    }
}
