//
//  UnweightedNetwork.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/27/19.
//

struct UnweightedNetwork<InnerNode: Hashable> {
    typealias Node = FlowNode<InnerNode>
    
    private var adjacencies: [Node: [Node]] = [.source: [], .sink: []]
    private var reverseAdjacencies: [Node: [Node]] = [.source: [], .sink: []]
}

extension UnweightedNetwork {
    mutating func insert(_ node: InnerNode) {
        insert(.internal(node))
    }
    
    mutating func insert(_ node: Node) {
        if !adjacencies.keys.contains(node) {
            adjacencies[node] = []
            reverseAdjacencies[node] = []
        }
    }
    
    mutating func edge(from start: InnerNode, to end: InnerNode) {
        _insertEdge(from: .internal(start), to: .internal(end))
    }
    
    mutating func sourceEdge(to end: InnerNode) {
        _insertEdge(from: .source, to: .internal(end))
    }
    
    mutating func sinkEdge(from start: InnerNode) {
        _insertEdge(from: .internal(start), to: .sink)
    }
    
    private mutating func _insertEdge(from start: Node, to end: Node) {
        insert(start)
        insert(end)
        adjacencies[start]!.append(end)
        reverseAdjacencies[end]!.append(start)
    }
}
