//
//  InvertingSpellingNetworkTests.swift
//  SpellingNetworksTests
//
//  Created by Benjamin Wetherfield on 9/26/19.
//

import XCTest
import DataStructures
import Pitch
import SpelledPitch
import NetworkStructures
import Encodings
@testable import SpellingNetworks

class InvertingSpellingNetworkTests: XCTestCase {
    
    func testInvertingSpellingNetworkPitchClass0() {
        let invertingSpellingNetworkNeutral = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.c)])
        let invertingSpellingNetworkUp = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.b,.sharp)])
        let invertingSpellingNetworkDown = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.d,.doubleFlat)])
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.down),.down))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.down),.up))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.up),.down))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.down),.down))
    }
    
    func testInvertingSpellingNetworkPitchClass1() {
        let invertingSpellingNetworkNeutral = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.c, .sharp)])
        let invertingSpellingNetworkUp = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.b,.doubleSharp)])
        let invertingSpellingNetworkDown = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.d,.flat)])
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.down),.down))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.down),.up))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.up),.down))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.down),.down))
    }
    
    func testInvertingSpellingNetworkPitchClass2() {
        let invertingSpellingNetworkNeutral = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.d)])
        let invertingSpellingNetworkUp = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.c,.doubleSharp)])
        let invertingSpellingNetworkDown = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.e,.doubleFlat)])
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.down),.down))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.down),.up))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.up),.down))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.down),.down))
    }
    
    func testInvertingSpellingNetworkPitchClass3() {
        let invertingSpellingNetworkNeutral = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.e,.flat)])
        let invertingSpellingNetworkUp = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.d,.sharp)])
        let invertingSpellingNetworkDown = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.f,.doubleFlat)])
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.down),.down))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.down),.up))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.up),.down))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.down),.down))
    }
    
    func testInvertingSpellingNetworkPitchClass4() {
        let invertingSpellingNetworkNeutral = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.e,.natural)])
        let invertingSpellingNetworkUp = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.d,.doubleSharp)])
        let invertingSpellingNetworkDown = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.f,.flat)])
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.down),.down))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.down),.up))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.up),.down))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.down),.down))
    }
    
    func testInvertingSpellingNetworkPitchClass5() {
        let invertingSpellingNetworkNeutral = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.f,.natural)])
        let invertingSpellingNetworkUp = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.e,.sharp)])
        let invertingSpellingNetworkDown = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.g,.doubleFlat)])
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.down),.down))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.down),.up))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.up),.down))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.down),.down))
    }
    
    func testInvertingSpellingNetworkPitchClass6() {
        let invertingSpellingNetworkNeutral = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.f,.sharp)])
        let invertingSpellingNetworkUp = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.e,.doubleSharp)])
        let invertingSpellingNetworkDown = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.g,.flat)])
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.down),.down))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.down),.up))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.up),.down))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.down),.down))
    }
    
    func testInvertingSpellingNetworkPitchClass7() {
        let invertingSpellingNetworkNeutral = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.g,.natural)])
        let invertingSpellingNetworkUp = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.f,.doubleSharp)])
        let invertingSpellingNetworkDown = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.a,.doubleFlat)])
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.down),.down))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.down),.up))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.up),.down))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.down),.down))
    }
    
    func testInvertingSpellingNetworkPitchClass8() {
        let invertingSpellingNetworkDown = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.a,.flat)])
        let invertingSpellingNetworkUp = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.g,.sharp)])
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.up),.down))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.down),.up))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.down),.up))
    }
    
    func testInvertingSpellingNetworkPitchClass9() {
        let invertingSpellingNetworkNeutral = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.a,.natural)])
        let invertingSpellingNetworkUp = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.g,.doubleSharp)])
        let invertingSpellingNetworkDown = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.b,.doubleFlat)])
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.down),.down))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.down),.up))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.up),.down))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.down),.down))
    }
    
    func testInvertingSpellingNetworkPitchClass10() {
        let invertingSpellingNetworkNeutral = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.b,.flat)])
        let invertingSpellingNetworkUp = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.a,.sharp)])
        let invertingSpellingNetworkDown = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.c,.doubleFlat)])
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.down),.down))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.down),.up))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.up),.down))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.down),.down))
    }
    
    func testInvertingSpellingNetworkPitchClass11() {
        let invertingSpellingNetworkNeutral = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.b,.natural)])
        let invertingSpellingNetworkUp = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.a,.doubleSharp)])
        let invertingSpellingNetworkDown = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.c,.flat)])
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkNeutral.contains((1,.down),.down))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.up),.up))
        XCTAssertTrue(invertingSpellingNetworkUp.contains((1,.down),.up))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.up),.down))
        XCTAssertTrue(invertingSpellingNetworkDown.contains((1,.down),.down))
    }
    
    func testInvertingSpellingNetworkEdgesPitchClass11() {
        let invertingSpellingNetworkNeutral = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.b,.natural)])
        let invertingSpellingNetworkUp = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.a,.doubleSharp)])
        let invertingSpellingNetworkDown = InvertingSpellingNetwork(spellings: [1: Pitch.Spelling(.c,.flat)])
        XCTAssertTrue(invertingSpellingNetworkNeutral.containsEdge(from: (1, .up), to: (1, .down)))
        XCTAssertTrue(invertingSpellingNetworkUp.containsEdge(from: (1, .up), to: (1, .down)))
        XCTAssertTrue(invertingSpellingNetworkDown.containsEdge(from: (1, .up), to: (1, .down)))
        XCTAssertTrue(invertingSpellingNetworkNeutral.containsSourceEdge(to: (1, .down)))
        XCTAssertTrue(invertingSpellingNetworkUp.containsSourceEdge(to: (1, .down)))
        XCTAssertTrue(invertingSpellingNetworkDown.containsSourceEdge(to: (1, .down)))
        XCTAssertTrue(invertingSpellingNetworkNeutral.containsSinkEdge(from: (1,.up)))
        XCTAssertTrue(invertingSpellingNetworkUp.containsSinkEdge(from: (1,.up)))
        XCTAssertTrue(invertingSpellingNetworkDown.containsSinkEdge(from: (1,.up)))
    }
    
    func testInvertingSpellingNetworkAdjacenciesFSharpASharp() {
        let invertingSpellingNetwork = InvertingSpellingNetwork(spellings: [
            1: Pitch.Spelling(.f,.sharp),
            2: Pitch.Spelling(.a, .sharp)
            ])
        XCTAssertTrue(invertingSpellingNetwork.containsEdge(from: (1, .up), to: (1, .down)))
        XCTAssertTrue(invertingSpellingNetwork.containsSourceEdge(to: (1, .down)))
        XCTAssertTrue(invertingSpellingNetwork.containsSinkEdge(from: (1,.up)))
        
        XCTAssertTrue(invertingSpellingNetwork.containsEdge(from: (2, .up), to: (2, .down)))
        XCTAssertFalse(invertingSpellingNetwork.containsEdge(from: (2, .down), to: (2, .up)))
        XCTAssertTrue(invertingSpellingNetwork.containsSourceEdge(to: (2, .down)))
        XCTAssertTrue(invertingSpellingNetwork.containsSinkEdge(from: (2,.up)))
        
        XCTAssertTrue(invertingSpellingNetwork.containsEdge(from: (1, .up), to: (2, .down)))
        XCTAssertTrue(invertingSpellingNetwork.containsEdge(from: (2, .up), to: (1, .down)))
        XCTAssertTrue(invertingSpellingNetwork.containsEdge(from: (1, .down), to: (2, .up)))
        XCTAssertTrue(invertingSpellingNetwork.containsEdge(from: (2, .down), to: (1, .up)))

        XCTAssertFalse(invertingSpellingNetwork.containsEdge(from: (1, .up), to: (2, .up)))
        XCTAssertFalse(invertingSpellingNetwork.containsEdge(from: (2, .up), to: (1, .up)))
        XCTAssertFalse(invertingSpellingNetwork.containsEdge(from: (1, .down), to: (2, .down)))
        XCTAssertFalse(invertingSpellingNetwork.containsEdge(from: (2, .down), to: (1, .down)))
    }
    
    func testDependenciesFSharpASharp() {
        let invertingSpellingNetwork = InvertingSpellingNetwork(spellings: [
            1: Pitch.Spelling(.f,.sharp),
            2: Pitch.Spelling(.a, .sharp)
            ])
        let dependencies = invertingSpellingNetwork.findDependencies()
        XCTAssertEqual(Set(dependencies.adjacencies[PitchedEdge(
            .internal(Cross<Pitch.Class, Tendency>(6, .down)),
            .internal(Cross<Pitch.Class, Tendency>(10, .up))
        )]!), Set([]))
        XCTAssertEqual(Set(dependencies.adjacencies[PitchedEdge(
            .source,
            .internal(Cross<Pitch.Class, Tendency>(10, .down))
        )]!), Set([]))
        
        XCTAssertEqual(Set(dependencies.adjacencies[PitchedEdge(
            .source,
            .internal(Cross<Pitch.Class, Tendency>(6, .down))
        )]!), Set([PitchedEdge(
            .internal(Cross<Pitch.Class, Tendency>(6, .down)),
            .internal(Cross<Pitch.Class, Tendency>(10, .up))
            )]
        ))
        XCTAssertEqual(Set(dependencies.adjacencies[PitchedEdge(
            .internal(Cross<Pitch.Class, Tendency>(10, .up)),
            .sink
        )]!), Set([PitchedEdge(
            .internal(Cross<Pitch.Class, Tendency>(6, .down)),
            .internal(Cross<Pitch.Class, Tendency>(10, .up))
            )]
        ))
        
        XCTAssertEqual(Set(dependencies.adjacencies[PitchedEdge(
            .internal(Cross<Pitch.Class, Tendency>(10, .down)),
            .internal(Cross<Pitch.Class, Tendency>(6, .up))
        )]!), Set([PitchedEdge(
            .source,
            .internal(Cross<Pitch.Class, Tendency>(10, .down))
            )]
        ))
        XCTAssertEqual(Set(dependencies.adjacencies[PitchedEdge(
            .internal(Cross<Pitch.Class, Tendency>(6, .up)),
            .sink
        )]!), Set([PitchedEdge(
            .source,
            .internal(Cross<Pitch.Class, Tendency>(10, .down))
            )]
        ))
    }
    
    func testWeightsFSharpASharp() {
        let invertingSpellingNetwork = InvertingSpellingNetwork(spellings: [
            1: Pitch.Spelling(.f,.sharp),
            2: Pitch.Spelling(.a, .sharp)
            ])
        let weights = invertingSpellingNetwork.generateWeights()
        XCTAssertEqual(weights[PitchedEdge(
            .internal(Cross<Pitch.Class, Tendency>(6, .down)),
            .internal(Cross<Pitch.Class, Tendency>(10, .up))
        )], 1)
        XCTAssertEqual(weights[PitchedEdge(
            .source,
            .internal(Cross<Pitch.Class, Tendency>(10, .down))
        )], 1)
        
        XCTAssertEqual(weights[PitchedEdge(
            .source,
            .internal(Cross<Pitch.Class, Tendency>(6, .down))
        )], 2)
        XCTAssertEqual(weights[PitchedEdge(
            .internal(Cross<Pitch.Class, Tendency>(10, .up)),
            .sink
        )], 2)
        
        XCTAssertEqual(weights[PitchedEdge(
            .internal(Cross<Pitch.Class, Tendency>(10, .down)),
            .internal(Cross<Pitch.Class, Tendency>(6, .up))
        )], 2)
        XCTAssertEqual(weights[PitchedEdge(
            .internal(Cross<Pitch.Class, Tendency>(6, .up)),
            .sink
        )], 2)
    }
    
    func testCycleCheckFSharpASharpGFlatBFlat() {
        let invertingSpellingNetwork = InvertingSpellingNetwork(spellings: [
            1: Pitch.Spelling(.f,.sharp),
            2: Pitch.Spelling(.a,.sharp),
            3: Pitch.Spelling(.g,.flat),
            4: Pitch.Spelling(.b,.flat)
            ])
        let scheme = NetworkScheme<Int> { edge in
            (edge.contains(.internal(1)) && edge.contains(.internal(2)))
                || (edge.contains(.internal(3)) && edge.contains(.internal(4)))
            || edge.contains(.sink) || edge.contains(.source)
        }
        invertingSpellingNetwork.connect(via: scheme)
        XCTAssertTrue(invertingSpellingNetwork.findDependencies().containsCycle())
    }
    
    func testCycleCheckFSharpASharpGFlatBFlatSubGraphs() {
        let invertingSpellingNetwork = InvertingSpellingNetwork(spellings: [
            1: Pitch.Spelling(.f,.sharp),
            2: Pitch.Spelling(.a,.sharp),
            3: Pitch.Spelling(.g,.flat),
            4: Pitch.Spelling(.b,.flat)
            ])
        invertingSpellingNetwork.partition(via: [1:0, 2:0, 3:1, 4:1])
        XCTAssertTrue(invertingSpellingNetwork.findDependencies().containsCycle())
    }
    
    func testConsistentBasicExample() {
        let invertingSpellingNetwork = InvertingSpellingNetwork(spellings: [
            1: Pitch.Spelling(.f, .sharp),
            2: Pitch.Spelling(.a, .sharp),
            3: Pitch.Spelling(.f, .sharp),
            4: Pitch.Spelling(.a, .sharp),
            5: Pitch.Spelling(.c, .sharp)
            ])
        invertingSpellingNetwork.partition(via: [
            1: 0,
            2: 0,
            3: 1,
            4: 1,
            5: 1
            ])
        XCTAssertFalse(invertingSpellingNetwork.findDependencies().containsCycle())
    }
    
    func testSemitones() {
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
        let invertingSpellingNetwork = InvertingSpellingNetwork(spellings: semitones)
        let pairing = NetworkScheme<Int> { edge in
            switch (edge.a, edge.b) {
            case let (.internal(a), .internal(b)):
                return ((a % 2 == 0) && (b % 2 == 1) && (b - 1 == a)) ||
                    ((a % 2 == 1) && (b % 2 == 0) && (a - 1 == b))
            default: return true
            }
        }
        invertingSpellingNetwork.connect(via: pairing)
        XCTAssertFalse(invertingSpellingNetwork.findDependencies().containsCycle())
    }
    
    func testTones() {
        let tones: [Pitch.Spelling] = [
            .c,
            .d,
            Pitch.Spelling(.d, .flat),
            Pitch.Spelling(.e, .flat),
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
            .g,
            .a,
            Pitch.Spelling(.a, .flat),
            Pitch.Spelling(.b, .flat),
            .a,
            .b,
            Pitch.Spelling(.b, .flat),
            .c,
            .b,
            Pitch.Spelling(.c, .sharp)
        ]
        let invertingSpellingNetwork = InvertingSpellingNetwork(spellings: tones)
        let pairing = NetworkScheme<Int> { edge in
            switch (edge.a, edge.b) {
            case let (.internal(a), .internal(b)):
                return ((a % 2 == 0) && (b % 2 == 1) && (b - 1 == a)) ||
                    ((a % 2 == 1) && (b % 2 == 0) && (a - 1 == b))
            default: return true
            }
        }
        invertingSpellingNetwork.connect(via: pairing)
        XCTAssertFalse(invertingSpellingNetwork.findDependencies().containsCycle())
    }
    
    func testMinorThirds() {
        let minorThirds: [Pitch.Spelling] = [
            .c,
            Pitch.Spelling(.e, .flat),
            Pitch.Spelling(.c, .sharp),
            .e,
            .d,
            .f,
            Pitch.Spelling(.e, .flat),
            Pitch.Spelling(.g, .flat),
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
            .b,
            .d
        ]
        let invertingSpellingNetwork = InvertingSpellingNetwork(spellings: minorThirds)
        let pairing = NetworkScheme<Int> { edge in
            switch (edge.a, edge.b) {
            case let (.internal(a), .internal(b)):
                return ((a % 2 == 0) && (b % 2 == 1) && (b - 1 == a)) ||
                    ((a % 2 == 1) && (b % 2 == 0) && (a - 1 == b))
            default: return true
            }
        }
        invertingSpellingNetwork.connect(via: pairing)
        XCTAssertFalse(invertingSpellingNetwork.findDependencies().containsCycle())
    }
    
    func testMajorThirds() {
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
        let invertingSpellingNetwork = InvertingSpellingNetwork(spellings: majorThirds)
        let pairing = NetworkScheme<Int> { edge in
            switch (edge.a, edge.b) {
            case let (.internal(a), .internal(b)):
                return ((a % 2 == 0) && (b % 2 == 1) && (b - 1 == a)) ||
                    ((a % 2 == 1) && (b % 2 == 0) && (a - 1 == b))
            default: return true
            }
        }
        invertingSpellingNetwork.connect(via: pairing)
        XCTAssertFalse(invertingSpellingNetwork.findDependencies().containsCycle())
    }
    
    func testPerfectFourths() {
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
        let invertingSpellingNetwork = InvertingSpellingNetwork(spellings: perfectFourths)
        let pairing = NetworkScheme<Int> { edge in
            switch (edge.a, edge.b) {
            case let (.internal(a), .internal(b)):
                return ((a % 2 == 0) && (b % 2 == 1) && (b - 1 == a)) ||
                    ((a % 2 == 1) && (b % 2 == 0) && (a - 1 == b))
            default: return true
            }
        }
        invertingSpellingNetwork.connect(via: pairing)
        XCTAssertFalse(invertingSpellingNetwork.findDependencies().containsCycle())
    }
    
    func testLargeSetOfDyadsWithoutCycles() {
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
//            Pitch.Spelling(.d, .flat),
//            Pitch.Spelling(.e, .flat),
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
            .g,
            .a,
            Pitch.Spelling(.a, .flat),
            Pitch.Spelling(.b, .flat),
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
//            Pitch.Spelling(.e, .flat),
//            Pitch.Spelling(.g, .flat),
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
//            Pitch.Spelling(.b, .flat),
//            Pitch.Spelling(.d, .flat),
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
//            Pitch.Spelling(.g, .flat),
//            Pitch.Spelling(.b, .flat),
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
        let invertingSpellingNetwork = InvertingSpellingNetwork(spellings: dyads)
        let pairing = NetworkScheme<Int> { edge in
            switch (edge.a, edge.b) {
            case let (.internal(a), .internal(b)):
                return ((a % 2 == 0) && (b % 2 == 1) && (b - 1 == a)) ||
                    ((a % 2 == 1) && (b % 2 == 0) && (a - 1 == b))
            default: return true
            }
        }
        invertingSpellingNetwork.connect(via: pairing)
        XCTAssertFalse(invertingSpellingNetwork.findDependencies().containsCycle())
    }
    
    func testCycleCheckFSharpASharpGFlatBFlatSubGraphsAfterStronglyConnectedComponentsClumped() {
        let invertingSpellingNetwork = InvertingSpellingNetwork(spellings: [
            1: Pitch.Spelling(.f,.sharp),
            2: Pitch.Spelling(.a,.sharp),
            3: Pitch.Spelling(.g,.flat),
            4: Pitch.Spelling(.b,.flat)
            ])
        invertingSpellingNetwork.partition(via: [1:0, 2:0, 3:1, 4:1])
        XCTAssertFalse(invertingSpellingNetwork.findDependencies().DAGify().containsCycle())
    }
    
    func testWeightsDerivationWithSimpleCycle() {
        let invertingSpellingNetwork = InvertingSpellingNetwork(spellings: [
            1: Pitch.Spelling(.f,.sharp),
            2: Pitch.Spelling(.a,.sharp),
            3: Pitch.Spelling(.g,.flat),
            4: Pitch.Spelling(.b,.flat)
            ])
        invertingSpellingNetwork.partition(via: [1:0, 2:0, 3:1, 4:1])
        let weights = invertingSpellingNetwork.generateWeights()
        XCTAssertEqual(weights[PitchedEdge(
            .internal(Cross<Pitch.Class, Tendency>(6, .up)),
            .sink
        )], weights[PitchedEdge(
            .source,
            .internal(Cross<Pitch.Class, Tendency>(10, .down))
            )])
        XCTAssertLessThan(weights[PitchedEdge(
            .internal(Cross<Pitch.Class, Tendency>(6, .up)),
            .sink
        )]!, weights[PitchedEdge(
            .internal(Cross<Pitch.Class, Tendency>(6, .up)),
            .internal(Cross<Pitch.Class, Tendency>(10, .down))
        )]!)

        XCTAssertLessThan(weights[PitchedEdge(
            .internal(Cross<Pitch.Class, Tendency>(6, .down)),
            .internal(Cross<Pitch.Class, Tendency>(10, .up))
        )]!, weights[PitchedEdge(
            .internal(Cross<Pitch.Class, Tendency>(10, .up)),
            .sink
        )]!)
        XCTAssertLessThan(weights[PitchedEdge(
            .internal(Cross<Pitch.Class, Tendency>(6, .down)),
            .internal(Cross<Pitch.Class, Tendency>(10, .up))
        )]!, weights[PitchedEdge(
            .source,
            .internal(Cross<Pitch.Class, Tendency>(6, .down))
        )]!)

    }
    
    func testGroupBuilderSimple() {
        let invertingSpellingNetwork1 = InvertingSpellingNetwork(spellings: [.c])
        let invertingSpellingNetwork2 = InvertingSpellingNetwork(spellings: [[.c]])
        XCTAssertEqual(invertingSpellingNetwork1.network.nodes, invertingSpellingNetwork2.network.nodes)
        XCTAssertEqual(invertingSpellingNetwork1.network.adjacencies, invertingSpellingNetwork2.network.adjacencies)
    }
    
    func testGroupBuilderSimple2() {
        let invertingSpellingNetwork1 = InvertingSpellingNetwork(spellings: [.c, .d])
        let invertingSpellingNetwork2 = InvertingSpellingNetwork(spellings: [[.c, .d]])
        XCTAssertEqual(invertingSpellingNetwork1.network.nodes, invertingSpellingNetwork2.network.nodes)
        XCTAssertEqual(invertingSpellingNetwork1.network.adjacencies, invertingSpellingNetwork2.network.adjacencies)
    }
    
    func testGroupBuilderTwoGroups() {
        let invertingSpellingNetwork1 = InvertingSpellingNetwork(spellings: [.c, .d])
        let mask = NetworkScheme<Int> { edge in
            switch (edge.a, edge.b) {
            case (.internal, .internal):
                return false
            default: return true
            }
        }
        invertingSpellingNetwork1.connect(via: mask)
        let invertingSpellingNetwork2 = InvertingSpellingNetwork(spellings: [[.c], [.d]])
        XCTAssertEqual(invertingSpellingNetwork1.network.nodes, invertingSpellingNetwork2.network.nodes)
        XCTAssertEqual(invertingSpellingNetwork1.network.adjacencies, invertingSpellingNetwork2.network.adjacencies)
    }
    
    func testGroupBuilderTwoGroupsMoreComplicated() {
        let invertingSpellingNetwork1 = InvertingSpellingNetwork(spellings: [.c, .d, .e])
        let mask = NetworkScheme<Int> { edge in
            (edge.contains(.internal(1)) && edge.contains(.internal(2))) || edge.contains(.source) || edge.contains(.sink)
        }
        invertingSpellingNetwork1.connect(via: mask)
        let invertingSpellingNetwork2 = InvertingSpellingNetwork(spellings: [[.c], [.d, .e]])
        XCTAssertEqual(invertingSpellingNetwork1.network.nodes, invertingSpellingNetwork2.network.nodes)
    }
    
    func testGroupBuilderThreeGroupsMoreComplicated() {
        let invertingSpellingNetwork1 = InvertingSpellingNetwork(spellings: [.c, .d, .e, .f])
        let mask = NetworkScheme<Int> { edge in
            (edge.contains(.internal(1)) && edge.contains(.internal(2))) || edge.contains(.source) || edge.contains(.sink)
        }
        invertingSpellingNetwork1.connect(via: mask)
        let invertingSpellingNetwork2 = InvertingSpellingNetwork(spellings: [[.c], [.d, .e], [.f]])
        XCTAssertEqual(invertingSpellingNetwork1.network.nodes, invertingSpellingNetwork2.network.nodes)
    }
    
    func testGroupBuilderThreeGroupsMoreComplicatedPartitionSyntax() {
        let invertingSpellingNetwork1 = InvertingSpellingNetwork(spellings: [.c, .d, .e, .f])
        invertingSpellingNetwork1.partition(via: [
            0: 0,
            1: 1,
            2: 1,
            3: 2
            ])
        let invertingSpellingNetwork2 = InvertingSpellingNetwork(spellings: [[.c], [.d, .e], [.f]])
        XCTAssertEqual(invertingSpellingNetwork1.network.nodes, invertingSpellingNetwork2.network.nodes)
    }
    
    func testPitchSpellingNetworkFactoryMethod () {
        let invertingSpellingNetwork = InvertingSpellingNetwork(spellings: [
            1: Pitch.Spelling(.f,.sharp),
            2: Pitch.Spelling(.a,.sharp),
            ])
        let factory = invertingSpellingNetwork.pitchSpellingNetworkFactory()
        let pitchSpellingNetwork = factory.build(from: [1: 6, 2: 10])
        let spellings = pitchSpellingNetwork.spell()
        XCTAssertEqual(spellings[1]!.spelling, .fSharp)
        XCTAssertEqual(spellings[2]!.spelling, .aSharp)
    }
    
    func testPitchSpellingNetworkFactoryMethodBuildWithNoIndices () {
        let invertingSpellingNetwork = InvertingSpellingNetwork(spellings: [
            1: Pitch.Spelling(.f,.sharp),
            2: Pitch.Spelling(.a,.sharp),
            ])
        let factory = invertingSpellingNetwork.pitchSpellingNetworkFactory()
        let pitchSpellingNetwork = factory.build(from: [6, 10])
        let spellings = pitchSpellingNetwork.spell()
        XCTAssertEqual(spellings[0]!.spelling, .fSharp)
        XCTAssertEqual(spellings[1]!.spelling, .aSharp)
    }
    
    func testPitchSpellingNetworkFactoryMethodBuildWithPartition () {
        let invertingSpellingNetwork = InvertingSpellingNetwork(spellings: [
            1: Pitch.Spelling(.f,.sharp),
            2: Pitch.Spelling(.a,.sharp),
            ])
        let factory = invertingSpellingNetwork.pitchSpellingNetworkFactory()
        let pitchSpellingNetwork = factory.build(from: [[6, 10]])
        let spellings = pitchSpellingNetwork.spell()
        XCTAssertEqual(spellings[0]!.spelling, .fSharp)
        XCTAssertEqual(spellings[1]!.spelling, .aSharp)
    }
    
    func testInverseCounterExample () {
        let semitones: [[Pitch.Spelling]] = [
            [
            .c,
            Pitch.Spelling(.d, .flat),
            ],
            [
            Pitch.Spelling(.c, .sharp),
            .d,
            ],
            [
            .d,
            Pitch.Spelling(.e, .flat),
            ],
            [
            Pitch.Spelling(.d, .sharp),
            .e,
            ],
            [
            .e,
            .f,
            ],
            [
            .f,
            Pitch.Spelling(.g, .flat),
            ],
            [
            Pitch.Spelling(.f, .sharp),
            .g,
            ],
            [
            .g,
            Pitch.Spelling(.a, .flat),
            ],
            [
            Pitch.Spelling(.g, .sharp),
            .a,
            ],
            [
            .a,
            Pitch.Spelling(.b, .flat),
            ],
            [
            Pitch.Spelling(.a, .sharp),
            .b,
            ],
            [
            .b,
            .c
                ]
        ]
        let tones: [[Pitch.Spelling]] = [
            [
            .c,
            .d,
            ],
            [
            Pitch.Spelling(.d, .flat),
            Pitch.Spelling(.e, .flat),
            ],[
            .d,
            .e,
            ],[
            Pitch.Spelling(.e, .flat),
            .f,
            ],[
            .e,
            Pitch.Spelling(.f, .sharp),
            ],[
            .f,
            .g,
            ],[
            Pitch.Spelling(.g, .flat),
            Pitch.Spelling(.a, .flat),
            ],[
            .g,
            .a,
            ],[
            Pitch.Spelling(.a, .flat),
            Pitch.Spelling(.b, .flat),
            ],[
            .a,
            .b,
            ],[
            Pitch.Spelling(.b, .flat),
            .c,
            ],[
            .b,
            Pitch.Spelling(.c, .sharp)
                ]
        ]
        let minorThirds: [[Pitch.Spelling]] = [
            [
            .c,
            Pitch.Spelling(.e, .flat),
            ],[
            Pitch.Spelling(.c, .sharp),
            .e,
            ],[
            .d,
            .f,
            ],[
            Pitch.Spelling(.e, .flat),
            Pitch.Spelling(.g, .flat),
            ],[
            .e,
            .g,
            ],[
            .f,
            Pitch.Spelling(.a, .flat),
            ],[
            Pitch.Spelling(.f, .sharp),
            .a,
            ],[
            .g,
            Pitch.Spelling(.b, .flat),
            ],[
            Pitch.Spelling(.g, .sharp),
            .b,
            ],[
            .a,
            .c,
            ],[
            Pitch.Spelling(.b, .flat),
            Pitch.Spelling(.d, .flat),
            ],[
            .b,
            .d
                ]
        ]
        let majorThirds: [[Pitch.Spelling]] = [
            [
            .c,
            .e,
            ],[
            Pitch.Spelling(.d, .flat),
            .f,
            ],[
            .d,
            Pitch.Spelling(.f, .sharp),
            ],[
            Pitch.Spelling(.e, .flat),
            .g,
            ],[
            .e,
            Pitch.Spelling(.g, .sharp),
            ],[
            .f,
            .a,
            ],[
            Pitch.Spelling(.g, .flat),
            Pitch.Spelling(.b, .flat),
            ],[
            .g,
            .b,
            ],[
            Pitch.Spelling(.a, .flat),
            .c,
            ],[
            .a,
            Pitch.Spelling(.c, .sharp),
            ],[
            Pitch.Spelling(.b, .flat),
            .d,
            ],[
            .b,
            Pitch.Spelling(.d, .sharp)
                ]
        ]
        let perfectFourths: [[Pitch.Spelling]] = [
            [
            .c,
            .f,
            ],[
            Pitch.Spelling(.d, .flat),
            Pitch.Spelling(.g, .flat),
            ],[
            .d,
            .g,
            ],[
            Pitch.Spelling(.e, .flat),
            Pitch.Spelling(.a, .flat),
            ],[
            .e,
            .a,
            ],[
            .f,
            Pitch.Spelling(.b, .flat),
            ],[
            Pitch.Spelling(.f, .sharp),
            .b,
            ],[
            .g,
            .c,
            ],[
            Pitch.Spelling(.a, .flat),
            Pitch.Spelling(.d, .flat),
            ],[
            .a,
            .d,
            ],[
            Pitch.Spelling(.b, .flat),
            Pitch.Spelling(.e, .flat),
            ],[
            .b,
            .e
                ]
        ]
        let dyads = semitones + tones + minorThirds + majorThirds + perfectFourths
        let invertingSpellingNetwork = InvertingSpellingNetwork(spellings: [
            [
            .gFlat,
            .bFlat,
            .dFlat,
            ],
            [
            .fSharp,
            .aSharp,
            .cSharp,
            ],
        ]
            + dyads
        )
        let factory = invertingSpellingNetwork.pitchSpellingNetworkFactory(sets: [
            [
                PitchedEdge(.source, .internal(.init(1, .down))),
                PitchedEdge(.source, .internal(.init(6, .down))),
                PitchedEdge(.internal(.init(3, .up)), .sink),
                PitchedEdge(.internal(.init(10, .up)), .sink),
            ],
            [
                PitchedEdge(.internal(.init(1, .up)), .sink),
                PitchedEdge(.internal(.init(6, .up)), .sink),
                PitchedEdge(.source, .internal(.init(3, .down))),
                PitchedEdge(.source, .internal(.init(10, .down))),
            ],
            [
                PitchedEdge(.source, .internal(.init(4, .down))),
                PitchedEdge(.source, .internal(.init(11, .down))),
                PitchedEdge(.internal(.init(0, .up)), .sink),
                PitchedEdge(.internal(.init(5, .up)), .sink),
            ],
            [
                PitchedEdge(.internal(.init(4, .up)), .sink),
                PitchedEdge(.internal(.init(11, .up)), .sink),
                PitchedEdge(.source, .internal(.init(0, .down))),
                PitchedEdge(.source, .internal(.init(5, .down))),
            ],
            [
                PitchedEdge(.source, .internal(.init(2, .down))),
                PitchedEdge(.internal(.init(2, .up)), .sink),
                PitchedEdge(.source, .internal(.init(7, .down))),
                PitchedEdge(.internal(.init(7, .up)), .sink),
                PitchedEdge(.source, .internal(.init(9, .down))),
                PitchedEdge(.internal(.init(9, .up)), .sink),
            ]
        ])
        let pitchSpellingNetwork = factory.build(from: [6,10,1], withPhantomPitches: [0])
        let spellings = pitchSpellingNetwork.spell(preferring: .flats)
        XCTAssertEqual(spellings[0]!.spelling, .gFlat)
        XCTAssertEqual(spellings[1]!.spelling, .bFlat)
        XCTAssertEqual(spellings[2]!.spelling, .dFlat)
    }
    
    func testInverseCounterExampleTwoPhantoms () {
        let semitones: [[Pitch.Spelling]] = [
            [
            .c,
            Pitch.Spelling(.d, .flat),
            ],
            [
            Pitch.Spelling(.c, .sharp),
            .d,
            ],
            [
            .d,
            Pitch.Spelling(.e, .flat),
            ],
            [
            Pitch.Spelling(.d, .sharp),
            .e,
            ],
            [
            .e,
            .f,
            ],
            [
            .f,
            Pitch.Spelling(.g, .flat),
            ],
            [
            Pitch.Spelling(.f, .sharp),
            .g,
            ],
            [
            .g,
            Pitch.Spelling(.a, .flat),
            ],
            [
            Pitch.Spelling(.g, .sharp),
            .a,
            ],
            [
            .a,
            Pitch.Spelling(.b, .flat),
            ],
            [
            Pitch.Spelling(.a, .sharp),
            .b,
            ],
            [
            .b,
            .c
                ]
        ]
        let tones: [[Pitch.Spelling]] = [
            [
            .c,
            .d,
            ],
            [
            Pitch.Spelling(.d, .flat),
            Pitch.Spelling(.e, .flat),
            ],[
            .d,
            .e,
            ],[
            Pitch.Spelling(.e, .flat),
            .f,
            ],[
            .e,
            Pitch.Spelling(.f, .sharp),
            ],[
            .f,
            .g,
            ],[
            Pitch.Spelling(.g, .flat),
            Pitch.Spelling(.a, .flat),
            ],[
            .g,
            .a,
            ],[
            Pitch.Spelling(.a, .flat),
            Pitch.Spelling(.b, .flat),
            ],[
            .a,
            .b,
            ],[
            Pitch.Spelling(.b, .flat),
            .c,
            ],[
            .b,
            Pitch.Spelling(.c, .sharp)
                ]
        ]
        let minorThirds: [[Pitch.Spelling]] = [
            [
            .c,
            Pitch.Spelling(.e, .flat),
            ],[
            Pitch.Spelling(.c, .sharp),
            .e,
            ],[
            .d,
            .f,
            ],[
            Pitch.Spelling(.e, .flat),
            Pitch.Spelling(.g, .flat),
            ],[
            .e,
            .g,
            ],[
            .f,
            Pitch.Spelling(.a, .flat),
            ],[
            Pitch.Spelling(.f, .sharp),
            .a,
            ],[
            .g,
            Pitch.Spelling(.b, .flat),
            ],[
            Pitch.Spelling(.g, .sharp),
            .b,
            ],[
            .a,
            .c,
            ],[
            Pitch.Spelling(.b, .flat),
            Pitch.Spelling(.d, .flat),
            ],[
            .b,
            .d
                ]
        ]
        let majorThirds: [[Pitch.Spelling]] = [
            [
            .c,
            .e,
            ],[
            Pitch.Spelling(.d, .flat),
            .f,
            ],[
            .d,
            Pitch.Spelling(.f, .sharp),
            ],[
            Pitch.Spelling(.e, .flat),
            .g,
            ],[
            .e,
            Pitch.Spelling(.g, .sharp),
            ],[
            .f,
            .a,
            ],[
            Pitch.Spelling(.g, .flat),
            Pitch.Spelling(.b, .flat),
            ],[
            .g,
            .b,
            ],[
            Pitch.Spelling(.a, .flat),
            .c,
            ],[
            .a,
            Pitch.Spelling(.c, .sharp),
            ],[
            Pitch.Spelling(.b, .flat),
            .d,
            ],[
            .b,
            Pitch.Spelling(.d, .sharp)
                ]
        ]
        let perfectFourths: [[Pitch.Spelling]] = [
            [
            .c,
            .f,
            ],[
            Pitch.Spelling(.d, .flat),
            Pitch.Spelling(.g, .flat),
            ],[
            .d,
            .g,
            ],[
            Pitch.Spelling(.e, .flat),
            Pitch.Spelling(.a, .flat),
            ],[
            .e,
            .a,
            ],[
            .f,
            Pitch.Spelling(.b, .flat),
            ],[
            Pitch.Spelling(.f, .sharp),
            .b,
            ],[
            .g,
            .c,
            ],[
            Pitch.Spelling(.a, .flat),
            Pitch.Spelling(.d, .flat),
            ],[
            .a,
            .d,
            ],[
            Pitch.Spelling(.b, .flat),
            Pitch.Spelling(.e, .flat),
            ],[
            .b,
            .e
                ]
        ]
        let dyads = semitones + tones + minorThirds + majorThirds + perfectFourths
        let invertingSpellingNetwork = InvertingSpellingNetwork(spellings: [
            [
            .gFlat,
            .bFlat,
            .dFlat,
            ],
            [
            .fSharp,
            .aSharp,
            .cSharp,
            ],
        ]
            + dyads
        )
        let factory = invertingSpellingNetwork.pitchSpellingNetworkFactory(
            sets: [
            [
                PitchedEdge(.source, .internal(.init(1, .down))),
                PitchedEdge(.source, .internal(.init(6, .down))),
                PitchedEdge(.internal(.init(3, .up)), .sink),
                PitchedEdge(.internal(.init(10, .up)), .sink),
            ],
            [
                PitchedEdge(.internal(.init(1, .up)), .sink),
                PitchedEdge(.internal(.init(6, .up)), .sink),
                PitchedEdge(.source, .internal(.init(3, .down))),
                PitchedEdge(.source, .internal(.init(10, .down))),
            ],
            [
                PitchedEdge(.source, .internal(.init(4, .down))),
                PitchedEdge(.source, .internal(.init(11, .down))),
                PitchedEdge(.internal(.init(0, .up)), .sink),
                PitchedEdge(.internal(.init(5, .up)), .sink),
            ],
            [
                PitchedEdge(.internal(.init(4, .up)), .sink),
                PitchedEdge(.internal(.init(11, .up)), .sink),
                PitchedEdge(.source, .internal(.init(0, .down))),
                PitchedEdge(.source, .internal(.init(5, .down))),
            ],
            [
                PitchedEdge(.source, .internal(.init(2, .down))),
                PitchedEdge(.internal(.init(2, .up)), .sink),
                PitchedEdge(.source, .internal(.init(7, .down))),
                PitchedEdge(.internal(.init(7, .up)), .sink),
                PitchedEdge(.source, .internal(.init(9, .down))),
                PitchedEdge(.internal(.init(9, .up)), .sink),
            ]
        ]
        )
        let pitchSpellingNetwork = factory.build(from: [6,10,1], withPhantomPitches: [0,4])
        let pitchSpellingNetwork2 = factory.build(from: [6,10,1], withPhantomPitches: [0,4])
        let flatSpellings = pitchSpellingNetwork.spell(preferring: .flats)
        let sharpSpellings = pitchSpellingNetwork2.spell(preferring: .sharps)
        XCTAssertEqual(flatSpellings[0]!.spelling, .gFlat)
        XCTAssertEqual(flatSpellings[1]!.spelling, .bFlat)
        XCTAssertEqual(flatSpellings[2]!.spelling, .dFlat)
        XCTAssertEqual(sharpSpellings[0]!.spelling, .fSharp)
        XCTAssertEqual(sharpSpellings[1]!.spelling, .aSharp)
        XCTAssertEqual(sharpSpellings[2]!.spelling, .cSharp)
    }
}
