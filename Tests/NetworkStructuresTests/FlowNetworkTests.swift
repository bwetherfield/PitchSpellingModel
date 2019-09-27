//
//  FlowNetworkTests.swift
//  NetworkStructuresTests
//
//  Created by Benjamin Wetherfield on 9/27/19.
//

import XCTest
@testable import NetworkStructures

class FlowNetworkTests: XCTestCase {
    
    var network: FlowNetwork<String>!
    
    override func setUp() {
        network = FlowNetwork<String>()
        network.insert("a")
        network.insert("b")
        network.edge(from: "a", to: "b", withWeight: 2)
        network.sourceEdge(to: "a", withWeight: 1)
        network.sinkEdge(from: "b", withWeight: 1)
    }
    
    func testEdges() {
        XCTAssertEqual(network.neighbors(of: .internal("b")), [.sink])
        XCTAssertEqual(network.neighbors(of: .internal("a")), [.internal("b")])
        XCTAssertEqual(network.neighbors(of: .source), [.internal("a")])
        XCTAssertEqual(network.neighbors(of: .sink), [])
    }
    
    func testRemoveEdges() {
        network.removeEdge(from: .internal("a"), to: .internal("b"))
        XCTAssertEqual(network.neighbors(of: .internal("a")), [])
        XCTAssertEqual(network.reverseNeighbors(of: .internal("b")), [])
    }
    
    func testPushFlow() {
        network.pushFlow(from: .internal("a"), to: .internal("b"), by: 1)
        XCTAssertEqual(network.weights[.internal("a")]![.internal("b")], 1)
    }
    
    override func tearDown() {
        network = nil
    }
}
