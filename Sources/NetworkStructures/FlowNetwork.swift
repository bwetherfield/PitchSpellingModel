//
//  FlowNetwork.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/27/19.
//

import DataStructures

public struct FlowNetwork<InnerNode: Hashable> {
    
    public typealias Node = FlowNode<InnerNode>

    public var weights: [Node: [Node: Double]] = [.source: [:], .sink: [:]]
    public var reverseAdjacencies: [Node: Set<Node>] = [.source: [], .sink: []]
}

extension FlowNetwork {
    
    public init (nodes: [InnerNode], scheme: FlowNetworkScheme<InnerNode>) {
        self.init()
        nodes.forEach { node in
            if let weight = scheme.weight(from: .source, to: .internal(node)) {
                sourceEdge(to: node, withWeight: weight)
            }
            if let weight = scheme.weight(from: .internal(node), to: .sink) {
                sinkEdge(from: node, withWeight: weight)
            }
            nodes.forEach { destination in
                if node != destination {
                    if let weight = scheme.weight(from: .internal(node), to: .internal(destination)) {
                        edge(from: node, to: destination, withWeight: weight)
                    }
                }
            }
        }
    }
}

extension FlowNetwork {
    
    // MARK: - Mutating Methods
    
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
        if let slice = weights[node] {
            return Array(slice.keys)
        } else {
            return []
        }
    }
    
    public func reverseNeighbors(of node: Node) -> [Node] {
        if let slice = reverseAdjacencies[node] {
            return Array(slice)
        } else {
            return []
        }
    }
}

extension FlowNetwork {
    
    // MARK: - Computed Properties
    
    /// - Returns: A minimum cut with nodes included on the `sink` side in case of a
    /// tiebreak (in- and out- edges saturated).
    public var sinkWeightedMinimumCut: (Set<Node>, Set<Node>) {
        let cachedResidualNetwork = residualNetwork
        let sourceSideNodes = Set(cachedResidualNetwork.sourceSearch())
        let notSourceSideNodes = cachedResidualNetwork.nodes.subtracting(sourceSideNodes)
        return (sourceSideNodes, notSourceSideNodes)
    }
    
    /// - Returns: A minimum cut with nodes included on the `source` side in case of a
    /// tiebreak (in- and out- edges saturated).
    public var sourceWeightedMinimumCut: (Set<Node>, Set<Node>) {
        let cachedResidualNetwork = residualNetwork
        let sinkSideNodes = Set(cachedResidualNetwork.sinkSearch())
        let notSinkSideNodes = cachedResidualNetwork.nodes.subtracting(sinkSideNodes)
        return (notSinkSideNodes, sinkSideNodes)
    }
    
    /// - Returns: The residual network produced after
    /// pushing all possible flow from source to sink (while satisfying flow constraints) - with
    /// saturated edges flipped and all weights removed.
    var residualNetwork: UnweightedNetwork<InnerNode> {
        // Make a copy of the directed representation of the network to be mutated by pushing flow
        // through it.
        var residualNetwork = self
        // While an augmenting path (a path emanating directionally from the source node) can be
        // found, push flow through the path, mutating the residual network
        while let augmentingPath = residualNetwork.augmentingPath() {
            residualNetwork.pushFlow(through: augmentingPath)
        }

        return residualNetwork.unweighted
    }
}

extension Sequence {
    
    func filterComplement (_ predicate: (Element) -> Bool) -> [Element] {
        return filter { !predicate($0) }
    }
    
    func partition (_ predicate: (Element) -> Bool) -> (whereFalse: [Element], whereTrue: [Element]) {
        return (filterComplement(predicate), filter(predicate))
    }
}
