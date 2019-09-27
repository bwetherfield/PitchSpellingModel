//
//  FlowNetworkTests.swift
//  NetworkStructuresTests
//
//  Created by Benjamin Wetherfield on 9/27/19.
//

import XCTest
@testable import NetworkStructures

class FlowNetworkTests: XCTestCase {
    
    func testEdges() {
        var network = FlowNetwork<String>()
        network.insert("a")
        network.insert("b")
        network.edge(from: "a", to: "b", withWeight: 2)
        network.sourceEdge(to: "a", withWeight: 1)
        network.sinkEdge(from: "b", withWeight: 1)
        XCTAssertEqual(network.neighbors(of: .internal("b")), [.sink])
        XCTAssertEqual(network.neighbors(of: .internal("a")), [.internal("b")])
        XCTAssertEqual(network.neighbors(of: .source), [.internal("a")])
        XCTAssertEqual(network.neighbors(of: .sink), [])
    }
    
    func testRemoveEdges() {
        var network = FlowNetwork<String>()
        network.insert("a")
        network.insert("b")
        network.edge(from: "a", to: "b", withWeight: 2)
        network.sourceEdge(to: "a", withWeight: 1)
        network.sinkEdge(from: "b", withWeight: 1)
        network.removeEdge(from: .internal("a"), to: .internal("b"))
        XCTAssertEqual(network.neighbors(of: .internal("a")), [])
        XCTAssertEqual(network.reverseNeighbors(of: .internal("b")), [])
    }
}
