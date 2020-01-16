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

/// Wraps flow network for deriving minimum cut and spelling pitches based on encoding system.
public class PitchSpellingNetwork {
    
    // MARK: - Associated Types
    
    // Supplements main (user) node index with index for phantom nodes
    enum Index {
        case primary(Int)
        case phantom(Int)
        
        // Prism for `.primary` case
        var primary: Int? {
            switch self {
            case .primary(let value):
                return value
            default:
                return nil
            }
        }
        
        // Prism for `.phantom` case
        var phantom: Int? {
            switch self {
            case .phantom(let value):
                return value
            default:
                return nil
            }
        }
        
        /// - Returns: `Cross` with `Index` mapped to `Int` if `node` is `.primary`, and `nil` if not
        static func downCast(_ node: Cross<Index,Tendency>) -> Cross<Int, Tendency>? {
            guard let int = node.a.primary else { return nil }
            return Cross(int, node.b)
        }
    }
    
    // MARK: - Instance Properties
    
    /// The `FlowNetwork` which will be manipulated in order to spell the unspelled `pitches`.
    var flowNetwork: FlowNetwork<Cross<Index,Tendency>>
        
    /// The unspelled `Pitch` values to be spelled.
    let pitch: (Index) -> Pitch?
    
    /// The masking scheme to be applied before spelling
    private var maskScheme: FlowNetworkScheme<Cross<Index,Tendency>>? = nil
    
    /// The underlying implementation of `maskScheme`
    private var _maskScheme: FlowNetworkScheme<Cross<Index,Tendency>> {
        get {
            return maskScheme ?? FlowNetworkScheme<Cross<Index, Tendency>> { _ in 1 }
        }
        set {
            maskScheme = newValue
        }
    }
    
    init(pitches: [Int: Pitch], weightScheme: FlowNetworkScheme<Cross<Pitch.Class, Tendency>>, phantomPitches: [Int: Pitch] = [:]) {
        
        // Return pitch assigned to `Index` value whether primary or phantom
        let pitch: (Index) -> Pitch? =
            get(\Index.primary) >>> { pitches[$0] } ||| get(\Index.phantom) >>> { phantomPitches[$0] }
        
        // Add two nodes to `flowNetwork` per input pitch; likewise for phantom pitches
        let nodes: [Cross<Index, Tendency>] = pitches.keys.reduce(into: []) { list, int in
            list.append(.init(.primary(int), .down))
            list.append(.init(.primary(int), .up))
        }
        let phantomPitches: [Cross<Index, Tendency>] = phantomPitches.keys.reduce(into: []) { list, int in
            list.append(.init(.phantom(int), .down))
            list.append(.init(.phantom(int), .up))
        }
        
        // Map node index to `Pitch.Class` equivalent
        let pitchClassMap: (Cross<Index, Tendency>) -> Cross<Pitch.Class, Tendency>? = { cross in
            guard let pitchClass = pitch(cross.a)?.class else { return nil }
            return Cross(pitchClass, cross.b)
        }
        
        // Pull back generic weight schemes for specific collection of pitches
        let differentIntScheme: FlowNetworkScheme<Cross<Index, Tendency>> =
             weightScheme.pullback(pitchClassMap)
                 * (
                    Connect.differentIndices()
                         + (Connect.sourceToDown + Connect.upToSink).pullback(pitchClassMap)
         )
        let sameIndices: NetworkScheme<Cross<Index, Tendency>> = Connect.sameIndices()
        let upToDown: NetworkScheme<Cross<Index, Tendency>> = Connect.upToDown()
        let sameIndexScheme: FlowNetworkScheme<Cross<Index, Tendency>> =
            Double.infinity * (sameIndices * upToDown)
        let combinedScheme: FlowNetworkScheme<Cross<Index, Tendency>> = sameIndexScheme + differentIntScheme
        
        // Initialize properties
        self.flowNetwork = FlowNetwork(
            nodes: nodes + phantomPitches,
            scheme: combinedScheme)
        self.pitch = pitch
    }
    
    convenience init(pitches: [[Pitch]], weightScheme: FlowNetworkScheme<Cross<Pitch.Class, Tendency>>, phantomPitches: [Int: Pitch] = [:]) {
        // Initialize without subarry structure
        let flattenedPitches: [Pitch] = pitches.reduce(into: []) { flattened, list in
            list.forEach { flattened.append($0) }
        }
        self.init(pitches: flattenedPitches, weightScheme: weightScheme, phantomPitches: phantomPitches)
        
        // Apply partitioning based on subarray structure
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
    
    convenience init(pitches: [Pitch], weightScheme: FlowNetworkScheme<Cross<Pitch.Class, Tendency>>, phantomPitches: [Int: Pitch] = [:]) {
        // Enumerate supplied pitches
        let indexed: [Int: Pitch] = pitches.enumerated().reduce(into: [:]) { indexedPitches, indexedPitch in
            let (index, pitch) = indexedPitch
            indexedPitches[index] = pitch
        }
        self.init(pitches: indexed, weightScheme: weightScheme, phantomPitches: phantomPitches)
    }
}

extension PitchSpellingNetwork {
    
    public enum Preference {
        case sharps
        case flats
    }

    // MARK: - Instance Methods
    
    // Adjusts edge weights based on an external scaling rule
    public func mask <T> (scheme: FlowNetworkScheme<T>, _ lens: @escaping (Int) -> T) {
        _maskScheme *= scheme.pullback(Index.downCast >>> get(\.a) >>> lens)
    }
    
    // Masks in or out edges according to the `Int` index of the node
    public func adjacencyMask (scheme: UnweightedGraphScheme<Int>) {
        let flowScheme: FlowNetworkScheme<Int> = 1.0 * scheme.lifted
        _maskScheme *= flowScheme.pullback(Index.downCast >>> get(\.a))
    }

    /// - Returns: An array of `SpelledPitch` values with the same indices as the original
    /// unspelled `Pitch` values.
    public func spell(preferring preference: Preference = .sharps) -> [Int: SpelledPitch] {
        if let scheme = maskScheme {
            flowNetwork.mask(scheme)
            maskScheme = nil
        }
        var assignedNodes: [AssignedNode] {
            var (sourceSide, sinkSide): (
            Set<FlowNode<Cross<Index, Tendency>>>,
            Set<FlowNode<Cross<Index, Tendency>>>
            )
            (sourceSide, sinkSide) = (preference == .sharps) ? flowNetwork.sinkWeightedMinimumCut : flowNetwork.sourceWeightedMinimumCut
            let downNodes: [AssignedNode] = sourceSide
                .compactMap(bind(Index.downCast >>> { index in
                .init(index: index, assignment: .down)
            }))
            let upNodes: [AssignedNode] = sinkSide
                .compactMap(bind(Index.downCast >>> { index in
                .init(index: index, assignment: .up)
            }))
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

    /// - Returns: `SpelledPitch` corresponding to the `Pitch` and `Tendency` values of `up` and `down`
    private func spellPitch(
        _ up: AssignedInnerNode,
        _ down: AssignedInnerNode
        ) -> SpelledPitch
    {
        let pitch = self.pitch(.primary(up.index.a))!
        let tendencies = TendencyPair(up.assignment, down.assignment)
        let spelling = Pitch.Spelling(pitchClass: pitch.class, tendencies: tendencies)!
        return try! pitch.spelled(with: spelling)
    }
}

extension PitchSpellingNetwork {
    
    /// Connects indices that share the same associated value
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
    
    /// Connects `.primary` nodes based on `scheme`
    func connect(via scheme: FlowNetworkScheme<Int>) {
        let mask: FlowNetworkScheme<Cross<Index, Tendency>>
            = (scheme + FlowNetworkScheme<Int> { edge in
                (edge.a == edge.b ? 1 : 0)
                }).pullback (get(\Cross.a) >>> get(\Index.primary))
        flowNetwork.mask(mask)
    }
}

extension PitchSpellingNetwork.Index: Hashable {}
