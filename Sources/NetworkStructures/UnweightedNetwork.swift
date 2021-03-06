//
//  UnweightedNetwork.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/27/19.
//

public struct UnweightedNetwork<InnerNode: Hashable> {
    
    // MARK: - Associated Types
    
    public typealias Node = FlowNode<InnerNode>
    
    // MARK: - Instance Properties
    
    public var adjacencies: [Node: Set<Node>] = [.source: [], .sink: []]
    private var reverseAdjacencies: [Node: Set<Node>] = [.source: [], .sink: []]
    
    // MARK: - Initializers
    
    public init() {}
    
    public init(adjacencies: [Node: Set<Node>], reverseAdjacencies: [Node: Set<Node>]) {
        self.adjacencies = adjacencies
        self.reverseAdjacencies = reverseAdjacencies
    }
}

extension UnweightedNetwork {
    public func contains(_ node: Node) -> Bool {
        return adjacencies.keys.contains(node)
    }
    
    public func containsEdge(from source: InnerNode, to destination: InnerNode) -> Bool {
        return adjacencies[.internal(source)]?.contains(.internal(destination)) ?? false
    }
    
    public func containsSourceEdge(to destination: InnerNode) -> Bool {
        return adjacencies[.source]?.contains(.internal(destination)) ?? false
    }
    
    public func containsSinkEdge(from source: InnerNode) -> Bool {
        return adjacencies[.internal(source)]?.contains(.sink) ?? false
    }
}

extension UnweightedNetwork {
    
    public mutating func removeEdge(from start: Node, to end: Node) {
        adjacencies[start]!.remove(end)
    }
    
    public mutating func insert(_ node: InnerNode) {
        insert(.internal(node))
    }
    
    public mutating func insert(_ node: Node) {
        if !adjacencies.keys.contains(node) {
            adjacencies[node] = []
            reverseAdjacencies[node] = []
        }
    }
    
    public mutating func internalEdge(from start: InnerNode, to end: InnerNode) {
        edge(from: .internal(start), to: .internal(end))
    }
    
    public mutating func sourceEdge(to end: InnerNode) {
        edge(from: .source, to: .internal(end))
    }
    
    public mutating func sinkEdge(from start: InnerNode) {
        edge(from: .internal(start), to: .sink)
    }
    
    public mutating func edge(from start: Node, to end: Node) {
        insert(start)
        insert(end)
        adjacencies[start]!.insert(end)
        reverseAdjacencies[end]!.insert(start)
    }

    public mutating func mask (_ scheme: NetworkScheme<InnerNode>) {
        adjacencies.forEach { (node, neighbors) in
            for neighbor in neighbors where !scheme.containsEdge(from: node, to: neighbor) {
            removeEdge(from: node, to: neighbor)
            }
        }
    }
}

extension UnweightedNetwork: FlowNetworkProtocol {
    public var nodes: Set<FlowNode<InnerNode>> {
        return Set(adjacencies.keys)
    }
    
    public func neighbors(of node: Node) -> [Node] {
        return Array<Node>(adjacencies[node]!)
    }
    
    public func reverseNeighbors(of node: Node) -> [Node] {
        return Array(reverseAdjacencies[node]!)
    }
}
