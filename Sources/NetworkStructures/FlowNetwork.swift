//
//  FlowNetwork.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/27/19.
//

struct FlowNetwork<InnerNode: Hashable> {
    typealias Node = FlowNode<InnerNode>

    private var weights: [Node: [Node: Double]] = [.source: [:], .sink: [:]]
    private var reverseAdjacencies: [Node: [Node]] = [.source: [], .sink: []]
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
        _insertEdge(from: .internal(start), to: .internal(end), withWeight: weight)
    }
    
    mutating func sourceEdge(to end: InnerNode, withWeight weight: Double) {
        _insertEdge(from: .source, to: .internal(end), withWeight: weight)
    }
    
    mutating func sinkEdge(from start: InnerNode, withWeight weight: Double) {
        _insertEdge(from: .internal(start), to: .sink, withWeight: weight)
    }
    
    private mutating func _insertEdge(from start: Node, to end: Node, withWeight weight: Double) {
        insert(start)
        insert(end)
        weights[start]![end] = weight
        reverseAdjacencies[end]!.append(start)
    }
}
