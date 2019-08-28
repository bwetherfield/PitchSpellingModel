//
//  FlowNetwork.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/27/19.
//

public struct FlowNetwork<InnerNode: Hashable> {
    
    public typealias Node = FlowNode<InnerNode>

    private var weights: [Node: [Node: Double]] = [.source: [:], .sink: [:]]
    private var reverseAdjacencies: [Node: Set<Node>] = [.source: [], .sink: []]
}

extension FlowNetwork {
    mutating func insert(_ node: InnerNode) {
        insert(.internal(node))
    }
    
    mutating func insert(_ node: Node) {
        if !weights.keys.contains(node) {
            weights[node] = [:]
            reverseAdjacencies[node] = []
        }
    }
    
    mutating func edge(from start: InnerNode, to end: InnerNode, withWeight weight: Double) {
        insertEdge(from: .internal(start), to: .internal(end), withWeight: weight)
    }
    
    mutating func sourceEdge(to end: InnerNode, withWeight weight: Double) {
        insertEdge(from: .source, to: .internal(end), withWeight: weight)
    }
    
    mutating func sinkEdge(from start: InnerNode, withWeight weight: Double) {
        insertEdge(from: .internal(start), to: .sink, withWeight: weight)
    }
    
    mutating func insertEdge(from start: Node, to end: Node, withWeight weight: Double) {
        insert(start)
        insert(end)
        weights[start]![end] = weight
        reverseAdjacencies[end]!.insert(start)
    }
    
    mutating func removeEdge(from start: Node, to end: Node) {
        weights[start]![end] = nil
        reverseAdjacencies[end]!.remove(start)
        if start != .sink && start != .source {
            if weights[start]!.isEmpty { weights[start] = nil }
            if reverseAdjacencies[start]!.isEmpty { reverseAdjacencies[start] = nil }
        }
        if end != .sink && end != .source {
            if weights[end]!.isEmpty { weights[end] = nil }
            if reverseAdjacencies[end]!.isEmpty { reverseAdjacencies[end] = nil }
        }
    }
}

extension FlowNetwork {
    
    mutating func mask (_ scheme: NetworkScheme<InnerNode>) {
        weights.forEach { (node, neighbors) in
            neighbors.keys.forEach { neighbor in
                if !scheme.containsEdge(from: node, to: neighbor) { weights[node]![neighbor] = nil }
            }
        }
    }
    
    mutating func mask (_ weightScheme: FlowNetworkScheme<InnerNode>) {
        weights.forEach { (node, neighbors) in
            neighbors.keys.forEach { neighbor in
                if let weight = weightScheme.weight(from: node, to: neighbor) {
                    weights[node]![neighbor]! *= weight
                } else {
                    weights[node]![neighbor] = nil
                }
            }
        }
    }
}

extension FlowNetwork {
    
    // MARK: - Mutating Methods
    
    mutating func reduceFlow(from start: Node, to end: Node, by amount: Double) {
        weights[start]![end]! -= amount
    }

    /// Removes the given edge if its weight is `0`. This happens after an edge, which has the
    /// minimum flow of an augmenting path, is reduced by the minimum flow (which is its previous
    /// value).
    mutating func removeEdgeIfFlowless(from start: Node, to end: Node) {
        if weights[start]![end]! == 0 {
            removeEdge(from: start, to: end)
        }
    }

    /// Inserts an edge in the opposite direction of the given `edge` with the minimum flow
    mutating func updateBackEdge(from start: Node, to end: Node, by minimumFlow: Double) {
        if weights[end]!.keys.contains(start) {
            weights[end]![start]! += minimumFlow
        } else {
            insertEdge(from: end, to: start, withWeight: minimumFlow)
        }
    }

    /// Reduces the flow of the given `edge` by the given `minimumFlow`. If the new flow through
    /// the `edge` is now `0`, removes the `edge` from the network. Updates the reverse of the given
    /// `edge` by the given `minimumFlow`.
    mutating func pushFlow(from start: Node, to end: Node, by minimumFlow: Double) {
        reduceFlow(from: start, to: end, by: minimumFlow)
        removeEdgeIfFlowless(from: start, to: end)
        updateBackEdge(from: start, to: end, by: minimumFlow)
    }

    /// Pushes flow through the given `path` in this `graph`.
    mutating func pushFlow(through path: [Node]) {
        let pairs = path.pairs
        let minimumFlow = pairs.map { weights[$0.0]![$0.1]! }.min() ?? 0
        pairs.forEach { pushFlow(from: $0.0, to: $0.1, by: minimumFlow) }
    }
}

extension FlowNetwork {
    var unweighted: UnweightedNetwork<InnerNode> {
        return UnweightedNetwork(
            adjacencies: weights.reduce(into: [Node: Set<Node>]()) { adjacencies, forNode in
            let (node, neighbors) = forNode
            adjacencies[node] = Set(neighbors.keys)
        }, reverseAdjacencies: reverseAdjacencies)
    }
}

extension FlowNetwork: FlowNetworkProtocol {
    public var nodes: Set<FlowNode<InnerNode>> {
        return Set(weights.keys)
    }
    
    public func neighbors(of node: Node) -> [Node] {
        return Array(weights[node]!.keys)
    }
}
