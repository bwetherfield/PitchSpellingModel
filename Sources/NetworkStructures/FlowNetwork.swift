//
//  FlowNetwork.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/27/19.
//

struct FlowNetwork<InnerNode: Hashable> {
    typealias Node = FlowNode<InnerNode>

    private var weights: [Node: [(Node, Double)]] = [.source: [], .sink: []]
    private var reverseAdjacencies: [Node: [Node]] = [.source: [], .sink: []]
}
