//
//  TendencyTests.swift
//  EncodingsTests
//
//  Created by Benjamin Wetherfield on 9/27/19.
//

import XCTest
import Pitch
import SpelledPitch
@testable import Encodings

class TendencyTests: XCTestCase {
    
    func testPitchSpellingFromTendenciesCNatural() {
        let cNatural = Pitch.Spelling(pitchClass: 0, tendencies: .init(.up, .down))
        XCTAssertEqual(cNatural, .c)
    }
    
    func testPitchSpellingFromTendenciesBSharp() {
        let bSharp = Pitch.Spelling(pitchClass: 0, tendencies: .init(.up, .up))
        XCTAssertEqual(bSharp, .bSharp)
    }
    
    func testPitchSpellingFromTendenciesDDoubleFlat() {
        let dDoubleFlat = Pitch.Spelling(pitchClass: 0, tendencies: .init(.down, .down))
        XCTAssertEqual(dDoubleFlat, .dDoubleFlat)
    }
}
