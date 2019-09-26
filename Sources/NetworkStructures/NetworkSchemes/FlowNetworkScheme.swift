//
//  FlowNetworkScheme.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/28/19.
//

import DataStructures

public struct FlowNetworkScheme<InnerNode: Hashable>: NetworkSchemeProtocol, WeightedGraphSchemeProtocol {
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
    public func pullback<BackInnerNode>(_ innerLens: @escaping (BackInnerNode) -> InnerNode)
        -> FlowNetworkScheme<BackInnerNode> {
            return self.pullback(bind(innerLens))
    }
    
    public func weight(from start: FlowNode<InnerNode>, to end: FlowNode<InnerNode>) -> Double? {
        return weight(Edge(start, end))
    }
}
