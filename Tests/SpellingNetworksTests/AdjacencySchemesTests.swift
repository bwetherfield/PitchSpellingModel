//
//  AdjacencySchemesTests.swift
//  SpellingNetworksTests
//
//  Created by Benjamin Wetherfield on 9/27/19.
//

import XCTest
import DataStructures
import NetworkStructures
import Encodings
@testable import SpellingNetworks

class AdjacencySchemesTests:XCTestCase {
    
    func testSourceToDown() {
        XCTAssert(Connect.sourceToDown.containsEdge(from: .source, to: .internal(.init(9, .down))))
    }
    
    func testExternalToExternalNodes() {
        XCTAssertFalse(Connect.connectPitchClassesForSameTendencies.containsEdge(from: .source, to: .sink))
        XCTAssertFalse(Connect.connectSameTendencies.containsEdge(from: .source, to: .sink))
        let sameIndices: NetworkScheme<Cross<Int, Tendency>> = Connect.sameIndices()
        let differentIndices: NetworkScheme<Cross<Int, Tendency>> = Connect.differentIndices()
        XCTAssertFalse(sameIndices.containsEdge(from: .source, to: .sink))
        XCTAssertFalse(differentIndices.containsEdge(from: .source, to: .sink))
    }
    
    func testExternalToInternalNodes() {
        XCTAssertFalse(Connect.connectPitchClassesForSameTendencies
            .containsEdge(from: .source, to: .internal(.init(0,.down)))
        )
        XCTAssertFalse(Connect.connectPitchClassesForDifferentTendencies
            .containsEdge(from: .source, to: .internal(.init(0,.down)))
        )
        let sameIndices: NetworkScheme<Cross<Int, Tendency>> = Connect.sameIndices()
        let differentIndices: NetworkScheme<Cross<Int, Tendency>> = Connect.differentIndices()
        XCTAssertFalse(sameIndices
            .containsEdge(from: .source, to: .internal(.init(0,.down)))
        )
        XCTAssertFalse(differentIndices
            .containsEdge(from: .source, to: .internal(.init(0,.down)))
        )
    }
}
