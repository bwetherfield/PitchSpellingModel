//
//  FlowNetworkScheme.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/28/19.
//

import DataStructures
import GraphSchemes

struct FlowNetworkScheme<InnerNode: Hashable>: NetworkSchemeProtocol, WeightedGraphSchemeProtocol {
    typealias Node = FlowNode<InnerNode>
    typealias Edge = OrderedPair<Node>
    
    let weight: (Edge) -> Double?
}

extension FlowNetworkScheme {
    init(_ weight: @escaping (Edge) -> Double?) {
        self.weight = weight
    }
}

extension FlowNetworkScheme {
    func pullback<BackInnerNode>(_ innerLens: @escaping (BackInnerNode) -> InnerNode)
        -> FlowNetworkScheme<BackInnerNode> {
            return FlowNetworkScheme<BackInnerNode>({
                self.weight(Edge(bind(innerLens)($0.a), bind(innerLens)($0.b)))
            })
    }
    
    func weight(from start: FlowNode<InnerNode>, to end: FlowNode<InnerNode>) -> Double? {
        return weight(Edge(start, end))
    }
}
