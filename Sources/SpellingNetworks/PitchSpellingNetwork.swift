//
//  PitchSpellingNetwork.swift
//  SpellingNetworks
//
//  Created by Benjamin Wetherfield on 8/27/19.
//

import DataStructures
import NetworkStructures
import Encodings
import Pitch
import SpelledPitch

class PitchSpellingNetwork {
    
    enum Node {
        case primary(Cross<Int, Tendency>)
        case phantom(Cross<Pitch.Class, Tendency>)
        
        var primary: Cross<Int, Tendency>? {
            switch self {
            case .primary(let value):
                return value
            default:
                return nil
            }
        }
        
        var phantom: Cross<Pitch.Class, Tendency>? {
            switch self {
            case .phantom(let value):
                return value
            default:
                return nil
            }
        }
        
        static func bind (_ f: @escaping (Cross<Int, Tendency>) -> Cross<Pitch.Class, Tendency>)
            ->  (Node) -> Cross<Pitch.Class, Tendency> {
            return { switch $0 {
            case .primary(let value):
                return f(value)
            case .phantom(let value):
                return value
                }
            }
        }
    }
    
    // MARK: - Instance Properties
    
    /// The `FlowNetwork` which will be manipulated in order to spell the unspelled `pitches`.
    var flowNetwork: FlowNetwork<Cross<Int,Tendency>>
        
    /// The unspelled `Pitch` values to be spelled.
    let pitch: (Int) -> Pitch
    
    /// The masking scheme to be applied before spelling
    private var maskScheme: FlowNetworkScheme<Cross<Int,Tendency>>? = nil
    
    /// The underlying implementation of `maskScheme`
    private var _maskScheme: FlowNetworkScheme<Cross<Int,Tendency>> {
        get {
            return maskScheme ?? FlowNetworkScheme<Cross<Int, Tendency>> { _ in 1 }
        }
        set {
            maskScheme = newValue
        }
    }
    
    init(pitches: [Int: Pitch], weightScheme: FlowNetworkScheme<Cross<Pitch.Class, Tendency>>) {
        let pitch = { pitches[$0]! }
        let nodes: [Cross<Int, Tendency>] = pitches.keys.reduce(into: []) { list, int in
            list.append(.init(int, .down))
            list.append(.init(int, .up))
        }
        let pitchClassMap: (Cross<Int, Tendency>) -> Cross<Pitch.Class, Tendency> = { cross in
            let pitchClass = pitch(cross.a).class
            return Cross(pitchClass, cross.b)
        }
        let differentIntScheme: FlowNetworkScheme<Cross<Int, Tendency>> =
            weightScheme.pullback(pitchClassMap)
                * (
                    Connect.differentInts
                        + (Connect.sourceToDown + Connect.upToSink).pullback(pitchClassMap)
        )
        let sameIntScheme: FlowNetworkScheme<Cross<Int, Tendency>> = Double.infinity * (Connect.sameInts * Connect.upToDown)
        let combinedScheme: FlowNetworkScheme<Cross<Int, Tendency>> = sameIntScheme + differentIntScheme
        self.flowNetwork = FlowNetwork(
            nodes: nodes,
            scheme: combinedScheme
            )
        self.pitch = pitch
    }
    
    convenience init(pitches: [[Pitch]], weightScheme: FlowNetworkScheme<Cross<Pitch.Class, Tendency>>) {
        let flattenedPitches: [Pitch] = pitches.reduce(into: []) { flattened, list in
            list.forEach { flattened.append($0) }
        }
        self.init(pitches: flattenedPitches, weightScheme: weightScheme)
        var runningCount = 0
        var indexing: [Int: Int] = [:]
        for (index, container) in pitches.enumerated() {
            for (i,_) in container.enumerated() {
                indexing[i + runningCount] = index
            }
            runningCount += container.count
        }
        self.partition(via: indexing)
    }
    
    convenience init(pitches: [Pitch], weightScheme: FlowNetworkScheme<Cross<Pitch.Class, Tendency>>) {
        let indexed: [Int: Pitch] = pitches.enumerated().reduce(into: [:]) { indexedPitches, indexedPitch in
            let (index, pitch) = indexedPitch
            indexedPitches[index] = pitch
        }
        self.init(pitches: indexed, weightScheme: weightScheme)
    }
}

extension PitchSpellingNetwork {
    
    enum Preference {
        case sharps
        case flats
    }

    // MARK: - Instance Methods
    
    // Adjusts edge weights based on an external scaling rule
    func mask <T> (scheme: FlowNetworkScheme<T>, _ lens: @escaping (Int) -> T) {
        _maskScheme *= scheme.pullback { lens($0.a) }
    }

    /// - Returns: An array of `SpelledPitch` values with the same indices as the original
    /// unspelled `Pitch` values.
    func spell(preferring preference: Preference = .sharps) -> [Int: SpelledPitch] {
        if let scheme = maskScheme {
            flowNetwork.mask(scheme)
            maskScheme = nil
        }
        var assignedNodes: [AssignedNode] {
            var (sourceSide, sinkSide): (
            Set<FlowNode<Cross<Int, Tendency>>>,
            Set<FlowNode<Cross<Int, Tendency>>>
            )
            (sourceSide, sinkSide) = (preference == .sharps) ? flowNetwork.sinkWeightedMinimumCut : flowNetwork.sourceWeightedMinimumCut
            let downNodes: [AssignedNode] = sourceSide.map(bind { index in
                .init(index: index, assignment: .down)
            })
            let upNodes: [AssignedNode] = sinkSide.map(bind { index in
                .init(index: index, assignment: .up)
            })
            return downNodes + upNodes
        }
        return assignedNodes
            .compactMap { (assignedNode) -> AssignedInnerNode? in
                switch assignedNode {
                case .source, .sink:
                    return nil
                case .internal(let assignedInnerNode):
                    return assignedInnerNode
                }
            }
            .reduce(into: [Int: (AssignedInnerNode, AssignedInnerNode)]()) { pairs, node in
                if !pairs.keys.contains(node.index.a) {
                    pairs[node.index.a] = (node, node)
                } else {
                    switch node.index.b {
                    case .up: pairs[node.index.a]!.0 = node
                    case .down: pairs[node.index.a]!.1 = node
                    }
                }
            }.mapValues(spellPitch)
    }

    private func spellPitch(
        _ up: AssignedInnerNode,
        _ down: AssignedInnerNode
        ) -> SpelledPitch
    {
        let pitch = self.pitch(up.index.a)
        let tendencies = TendencyPair(up.assignment, down.assignment)
        let spelling = Pitch.Spelling(pitchClass: pitch.class, tendencies: tendencies)!
        return try! pitch.spelled(with: spelling)
    }
}

extension PitchSpellingNetwork {
    
    func partition (via indices: [Int: Int]) {
        let adjacencyScheme = FlowNetworkScheme<Int> { edge in
            switch (edge.a, edge.b) {
            case let (.internal(a), .internal(b)):
                return (indices[a] == indices[b] ? 1 : 0)
            default:
                return 1
            }
        }
        connect(via: adjacencyScheme)
    }
    
    func connect(via scheme: FlowNetworkScheme<Int>) {
        let mask: FlowNetworkScheme<Cross<Int, Tendency>>
            = (scheme + FlowNetworkScheme<Int> { edge in
                (edge.a == edge.b ? 1 : 0)
                }).pullback { cross in cross.a }
        flowNetwork.mask(mask)
    }
}

extension PitchSpellingNetwork.Node: Hashable {}
