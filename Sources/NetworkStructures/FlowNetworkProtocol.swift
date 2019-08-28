//
//  FlowNetworkProtocol.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/28/19.
//

public protocol FlowNetworkProtocol where InnerNode: Hashable {
    associatedtype InnerNode
    typealias Node = FlowNode<InnerNode>
    
    var nodes: Set<Node> { get }
    
    func neighbors(of node: Node) -> [Node]
}

extension FlowNetworkProtocol {

    public func augmentingPath() -> [Node]? {
        var breadcrumbs: [Node: Node] = [:]

        func backtrace() -> [Node] {
            var path = [Node.sink]
            var cursor = Node.sink
            while cursor != Node.source {
                path.insert(breadcrumbs[cursor]!, at: 0)
                cursor = breadcrumbs[cursor]!
            }
            return path
        }

        var unvisited = nodes
        var queue = [Node.source]
        while !queue.isEmpty {
            let node = queue.removeFirst()
            for neighbor in neighbors(of: node) where unvisited.contains(neighbor) {
                queue.append(neighbor)
                unvisited.remove(neighbor)
                breadcrumbs[neighbor] = node
                if neighbor == Node.sink { return backtrace() }
            }
        }
        return nil
    }
}
