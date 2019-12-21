//
//  PitchSpellingNetworkTests.swift
//  SpellingNetworksTests
//
//  Created by Benjamin Wetherfield on 9/27/19.
//

import XCTest
import DataStructures
import Pitch
import Encodings
import SpelledPitch
import NetworkStructures
@testable import SpellingNetworks

class PitchSpellingNetworkTests: XCTestCase {
    
    var weightScheme: FlowNetworkScheme<Cross<Pitch.Class, Tendency>>!
    
    override func setUp() {
        let semitones: [Pitch.Spelling] = [
            .c,
            Pitch.Spelling(.d, .flat),
            Pitch.Spelling(.c, .sharp),
            .d,
            .d,
            Pitch.Spelling(.e, .flat),
            Pitch.Spelling(.d, .sharp),
            .e,
            .e,
            .f,
            .f,
            Pitch.Spelling(.g, .flat),
            Pitch.Spelling(.f, .sharp),
            .g,
            .g,
            Pitch.Spelling(.a, .flat),
            Pitch.Spelling(.g, .sharp),
            .a,
            .a,
            Pitch.Spelling(.b, .flat),
            Pitch.Spelling(.a, .sharp),
            .b,
            .b,
            .c
        ]
        let tones: [Pitch.Spelling] = [
            .c,
            .d,
            Pitch.Spelling(.d, .flat),
            Pitch.Spelling(.e, .flat),
            Pitch.Spelling(.c, .sharp),
            Pitch.Spelling(.d, .sharp),
            .d,
            .e,
            Pitch.Spelling(.e, .flat),
            .f,
            .e,
            Pitch.Spelling(.f, .sharp),
            .f,
            .g,
            Pitch.Spelling(.g, .flat),
            Pitch.Spelling(.a, .flat),
            Pitch.Spelling(.f, .sharp),
            Pitch.Spelling(.g, .sharp),
            .g,
            .a,
            Pitch.Spelling(.a, .flat),
            Pitch.Spelling(.b, .flat),
            Pitch.Spelling(.g, .sharp),
            Pitch.Spelling(.a, .sharp),
            .a,
            .b,
            Pitch.Spelling(.b, .flat),
            .c,
            .b,
            Pitch.Spelling(.c, .sharp)
        ]
        let minorThirds: [Pitch.Spelling] = [
            .c,
            Pitch.Spelling(.e, .flat),
            Pitch.Spelling(.c, .sharp),
            .e,
            .d,
            .f,
            Pitch.Spelling(.e, .flat),
            Pitch.Spelling(.g, .flat),
            Pitch.Spelling(.d, .sharp),
            Pitch.Spelling(.f, .sharp),
            .e,
            .g,
            .f,
            Pitch.Spelling(.a, .flat),
            Pitch.Spelling(.f, .sharp),
            .a,
            .g,
            Pitch.Spelling(.b, .flat),
            Pitch.Spelling(.g, .sharp),
            .b,
            .a,
            .c,
            Pitch.Spelling(.b, .flat),
            Pitch.Spelling(.d, .flat),
            Pitch.Spelling(.a, .sharp),
            Pitch.Spelling(.c, .sharp),
            .b,
            .d
        ]
        let majorThirds: [Pitch.Spelling] = [
            .c,
            .e,
            Pitch.Spelling(.d, .flat),
            .f,
            .d,
            Pitch.Spelling(.f, .sharp),
            Pitch.Spelling(.e, .flat),
            .g,
            .e,
            Pitch.Spelling(.g, .sharp),
            .f,
            .a,
            Pitch.Spelling(.g, .flat),
            Pitch.Spelling(.b, .flat),
            Pitch.Spelling(.f, .sharp),
            Pitch.Spelling(.a, .sharp),
            .g,
            .b,
            Pitch.Spelling(.a, .flat),
            .c,
            .a,
            Pitch.Spelling(.c, .sharp),
            Pitch.Spelling(.b, .flat),
            .d,
            .b,
            Pitch.Spelling(.d, .sharp)
        ]
        let perfectFourths: [Pitch.Spelling] = [
            .c,
            .f,
            Pitch.Spelling(.d, .flat),
            Pitch.Spelling(.g, .flat),
            .d,
            .g,
            Pitch.Spelling(.e, .flat),
            Pitch.Spelling(.a, .flat),
            .e,
            .a,
            .f,
            Pitch.Spelling(.b, .flat),
            Pitch.Spelling(.f, .sharp),
            .b,
            .g,
            .c,
            Pitch.Spelling(.a, .flat),
            Pitch.Spelling(.d, .flat),
            .a,
            .d,
            Pitch.Spelling(.b, .flat),
            Pitch.Spelling(.e, .flat),
            .b,
            .e
        ]
        let dyads = semitones + tones + minorThirds + majorThirds + perfectFourths
        var invertingSpellingNetwork = InvertingSpellingNetwork(spellings: dyads)
        let pairing = NetworkScheme<Int> { edge in
            switch (edge.a, edge.b) {
            case let (.internal(a), .internal(b)):
                return ((a % 2 == 0) && (b % 2 == 1) && (b - 1 == a)) ||
                    ((a % 2 == 1) && (b % 2 == 0) && (a - 1 == b))
            default: return true
            }
        }
        invertingSpellingNetwork.connect(via: pairing)
        let weights: [PitchedEdge: Double] = invertingSpellingNetwork.generateWeights()
        weightScheme = FlowNetworkScheme<Cross<Pitch.Class, Tendency>> { return weights[.init($0.a, $0.b)] }
    }
    
    func testTrivialPitchSpellingNetwork() {
        let pitchSpellingNetwork = PitchSpellingNetwork(pitches: [0: 0], weightScheme: weightScheme!)
        let spelledPitches = pitchSpellingNetwork.spell()
        XCTAssertEqual(spelledPitches[0]!.spelling, .c)
    }
    
    func testDyadSpellingEFlatG() {
        let pitchSpellingNetwork = PitchSpellingNetwork(pitches: [0: 3, 1: 7], weightScheme: weightScheme!)
        let spelledPitches = pitchSpellingNetwork.spell()
        XCTAssertEqual(spelledPitches[0]!.spelling, .eFlat)
        XCTAssertEqual(spelledPitches[1]!.spelling, .g)
    }
    
    func testDyadSpellingCSharpDSharp() {
        let pitchSpellingNetwork = PitchSpellingNetwork(pitches: [0: 1, 1: 3], weightScheme: weightScheme!)
        let spelledPitches = pitchSpellingNetwork.spell(preferring: .sharps)
        XCTAssertEqual(spelledPitches[0]!.spelling, .cSharp)
        XCTAssertEqual(spelledPitches[1]!.spelling, .dSharp)
    }
    
    func testDyadSpellingDFlatEFlat() {
        let pitchSpellingNetwork = PitchSpellingNetwork(pitches: [0: 1, 1: 3], weightScheme: weightScheme!)
        let spelledPitches = pitchSpellingNetwork.spell(preferring: .flats)
        XCTAssertEqual(spelledPitches[0]!.spelling, .dFlat)
        XCTAssertEqual(spelledPitches[1]!.spelling, .eFlat)
    }
    
    func testTriadSpellingEFlatBFlatD() {
        let pitchSpellingNetwork = PitchSpellingNetwork(pitches: [0: 3, 1: 10, 2: 2], weightScheme: weightScheme!)
        let spelledPitches = pitchSpellingNetwork.spell()
        XCTAssertEqual(spelledPitches[0]!.spelling, .eFlat)
        XCTAssertEqual(spelledPitches[1]!.spelling, .bFlat)
        XCTAssertEqual(spelledPitches[2]!.spelling, .d)
    }
    
    func testTriadCDFlatENatural() {
        let pitchSpellingNetwork = PitchSpellingNetwork(pitches: [0: 0, 1: 1, 2: 4], weightScheme: weightScheme!)
        let spelledPitches = pitchSpellingNetwork.spell()
        dump(spelledPitches)
    }
    
    override func tearDown() {
        weightScheme = nil
        super.tearDown()
    }
}
