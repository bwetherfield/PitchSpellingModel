//
//  FlowNetworkProtocol.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/28/19.
//

import DataStructures

public protocol FlowNetworkProtocol where InnerNode: Hashable {
    associatedtype InnerNode
    typealias Node = FlowNode<InnerNode>
    
    var nodes: Set<Node> { get }
    
    func neighbors(of node: Node) -> [Node]
    func reverseNeighbors(of node: Node) -> [Node]
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
    
    @inlinable
    public func sourceSearch() -> [Node] {
        var visited: [Node] = []
        var queue = Queue<Node>()
        queue.enqueue(.source)
        visited.append(.source)
        while !queue.isEmpty {
            let node = queue.dequeue()
            for neighbor in neighbors(of: node) where !visited.contains(neighbor) {
                queue.enqueue(neighbor)
                visited.append(neighbor)
                if neighbor == .sink { return visited }
            }
        }
        return visited
    }
    
    @inlinable
    public func sinkSearch() -> [Node] {
        var visited: [Node] = []
        var queue = Queue<Node>()
        queue.enqueue(.sink)
        visited.append(.sink)
        while !queue.isEmpty {
            let node = queue.dequeue()
            for neighbor in reverseNeighbors(of: node) where !visited.contains(neighbor) {
                queue.enqueue(neighbor)
                visited.append(neighbor)
                if neighbor == .source { return visited }
            }
        }
        return visited
    }
}
