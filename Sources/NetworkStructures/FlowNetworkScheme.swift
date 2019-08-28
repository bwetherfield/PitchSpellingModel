//
//  FlowNetworkScheme.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/28/19.
//

import DataStructures

struct FlowNetworkScheme<InnerNode: Hashable> {
    typealias Node = FlowNode<InnerNode>
    typealias Edge = OrderedPair<Node>
    
    let weight: (Edge) -> Double?
}

extension FlowNetworkScheme {
    func pullback<BackInnerNode>(via innerLens: @escaping (BackInnerNode) -> InnerNode)
        -> FlowNetworkScheme<BackInnerNode> {
            return FlowNetworkScheme<BackInnerNode> {
                self.weight(Edge(bind(innerLens)($0.a), bind(innerLens)($0.b)))
            }
    }
}
