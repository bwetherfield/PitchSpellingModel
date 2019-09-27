//
//  AdjacencySchemesTests.swift
//  SpellingNetworksTests
//
//  Created by Benjamin Wetherfield on 9/27/19.
//

import XCTest
@testable import SpellingNetworks

class AdjacencySchemesTests:XCTestCase {
    
    func testExternalToExternalNodes() {
        XCTAssertFalse(Connect.connectPitchClassesForSameTendencies.containsEdge(from: .source, to: .sink))
        XCTAssertFalse(Connect.connectSameTendencies.containsEdge(from: .source, to: .sink))
        XCTAssertFalse(Connect.sameInts.containsEdge(from: .source, to: .sink))
        XCTAssertFalse(Connect.differentInts.containsEdge(from: .source, to: .sink))
    }
    
    func testExternalToInternalNodes() {
        XCTAssertFalse(Connect.connectPitchClassesForSameTendencies
            .containsEdge(from: .source, to: .internal(.init(0,.down)))
        )
        XCTAssertFalse(Connect.connectPitchClassesForDifferentTendencies
            .containsEdge(from: .source, to: .internal(.init(0,.down)))
        )
        XCTAssertFalse(Connect.sameInts
            .containsEdge(from: .source, to: .internal(.init(0,.down)))
        )
        XCTAssertFalse(Connect.differentInts
            .containsEdge(from: .source, to: .internal(.init(0,.down)))
        )
    }
}
