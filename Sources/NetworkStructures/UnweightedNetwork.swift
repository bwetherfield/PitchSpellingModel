//
//  UnweightedNetwork.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/27/19.
//

struct UnweightedNetwork<InnerNode: Hashable> {
    typealias Node = FlowNode<InnerNode>
    
    let adjacencies: [Node: [Node]]
    let reverseAdjacencies: [Node: [Node]]
}
