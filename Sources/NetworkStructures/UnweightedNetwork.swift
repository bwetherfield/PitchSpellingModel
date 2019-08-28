//
//  UnweightedNetwork.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/27/19.
//

public struct UnweightedNetwork<InnerNode: Hashable> {
    public typealias Node = FlowNode<InnerNode>
    
    public var adjacencies: [Node: Set<Node>] = [.source: [], .sink: []]
    private var reverseAdjacencies: [Node: [Node]] = [.source: [], .sink: []]
    
    public init() {}
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
        reverseAdjacencies[end]!.append(start)
    }
}

extension UnweightedNetwork {
    public mutating func mask (_ scheme: NetworkScheme<InnerNode>)
    {
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
    
    public func neighbors(of node: FlowNode<InnerNode>) -> [FlowNode<InnerNode>] {
        return Array(adjacencies[node]!)
    }
    
    
}
