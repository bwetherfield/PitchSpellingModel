//
//  NetworkScheme.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/28/19.
//

import DataStructures

struct NetworkScheme<InnerNode: Hashable> {
    typealias Node = FlowNode<InnerNode>
    typealias Edge = OrderedPair<Node>
    
    let contains: (Edge) -> Bool
}

extension NetworkScheme {
    func pullback<BackInnerNode>(via innerLens: @escaping (BackInnerNode) -> InnerNode)
        -> NetworkScheme<BackInnerNode> {
        return NetworkScheme<BackInnerNode> {
            self.contains(Edge(bind(innerLens)($0.a), bind(innerLens)($0.b)))
        }
    }
}
