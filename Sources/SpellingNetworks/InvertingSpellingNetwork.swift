//
//  InvertingSpellingNetwork.swift
//  SpellingNetworks
//
//  Created by Benjamin Wetherfield on 8/27/19.
//

import NetworkStructures
import Encodings
import DataStructures
import Pitch
import SpelledPitch

struct InvertingSpellingNetwork {
    
    var network: UnweightedNetwork<AssignedInnerNode>
    let pitchClass: (Int) -> Pitch.Class?
}

extension InvertingSpellingNetwork {

    // MARK: - Initializers

    public init(spellings: [[Pitch.Spelling]]) {
        let flattenedSpellings: [Pitch.Spelling] = spellings.reduce(into: []) { flattened, list in
            list.forEach { flattened.append($0) }
        }
        self.init(spellings: flattenedSpellings)
        var runningCount = 0
        var indexing: [Int: Int] = [:]
        for (index, container) in spellings.enumerated() {
            for (i,_) in container.enumerated() {
                indexing[i + runningCount] = index
            }
            runningCount += container.count
        }
        self.partition(via: indexing)
    }

    init(spellings: [Pitch.Spelling]) {
        let indexed: [Int: Pitch.Spelling] = spellings.enumerated().reduce(into: [:]) { indexedSpellings, indexedSpelling in
            let (index, spelling) = indexedSpelling
            indexedSpellings[index] = spelling
        }
        self.init(spellings: indexed)
    }

    init(spellings: [Int: Pitch.Spelling]) {
        self.network = UnweightedNetwork(internalNodes: internalNodes(spellings: spellings))
        self.pitchClass = { int in spellings[int]?.pitchClass }

        let specificEdgeScheme: NetworkScheme<UnassignedInnerNode> =
            (Connect.sameTendenciesAppropriately +
                Connect.differentTendenciesAppropriately).pullback(nodeMapper)
            * Connect.differentInts

        let sameIntEdgesScheme: NetworkScheme<UnassignedInnerNode> =
            Connect.upToDown * Connect.sameInts

        let specificSourceScheme: NetworkScheme<UnassignedInnerNode> =
            Connect.sourceToDown.pullback(nodeMapper)

        let specificSinkScheme: NetworkScheme<UnassignedInnerNode> =
            Connect.upToSink.pullback(nodeMapper)

        let allSchemes: [NetworkScheme<UnassignedInnerNode>] = [
            specificEdgeScheme,
            sameIntEdgesScheme,
            specificSourceScheme,
            specificSinkScheme
        ]

        let maskScheme: NetworkScheme<AssignedInnerNode> = allSchemes
            .reduce(NetworkScheme { _ in false }, +)
            .pullback({ $0.unassigned })

        // Apply masking of specific manifestations of the general global adjacency schemes
        self.network.mask(maskScheme)
    }
}

extension InvertingSpellingNetwork {

    /// - Returns: A concrete distribution of weights to satisfy the weight relationships delimited by
    /// `weightDependencies` or `nil` if no such distribution is possible, i.e. there are cyclical
    /// dependencies between edge types. In the latter case, the spellings fed in are *inconsistent*.
    /// Weights are parametrized by `Pitch.Class` and `Tendency` values.
    public func generateWeights () -> [PitchedEdge: Double] {
        let pitchedDependencies = findDependencies()
        if pitchedDependencies.containsCycle() {
            return generateWeightsFromCycles(pitchedDependencies)
        }
        func dependeciesReducer (
            _ weights: inout [PitchedEdge: Double],
            _ dependency: (key: PitchedEdge, value: [PitchedEdge])
            )
        {
            func recursiveReducer (
                _ weights: inout [PitchedEdge: Double],
                _ dependency: (key: PitchedEdge, value: [PitchedEdge])
                ) -> Double
            {
                let weight = dependency.value.reduce(1.0) { result, edge in
                    if let edgeWeight = weights[edge] { return result + edgeWeight }
                    return (
                        result +
                            recursiveReducer(&weights, (key: edge, value: pitchedDependencies.adjacencies[edge]!))
                    )
                }
                weights[dependency.key] = weight
                return weight
            }
            let _ = recursiveReducer(&weights, dependency)
        }
        return pitchedDependencies.adjacencies.reduce(into: [:], dependeciesReducer)
    }

    func generateWeightsFromCycles (_ dependencies: DiGraph<PitchedEdge>)
        -> [PitchedEdge: Double] {
            let directedAcyclicGraph = dependencies.DAGify()
            let groupedWeights: [Set<PitchedEdge>: Double] = generateWeights(from: directedAcyclicGraph)
            return groupedWeights.reduce(into: [PitchedEdge: Double]()) { runningWeights, pair in
                pair.key.forEach { pitchedEdge in
                    runningWeights[pitchedEdge] = pair.value
                }
            }
    }

    func generateWeights<Node> (from dependencies: DiGraph<Node>) -> [Node: Double] {
        func dependeciesReducer (
            _ weights: inout [Node: Double],
            _ dependency: (key: Node, value: [Node])
            )
        {
            func recursiveReducer (
                _ weights: inout [Node: Double],
                _ dependency: (key: Node, value: [Node])
                ) -> Double
            {
                let weight = dependency.value.reduce(1.0) { result, edge in
                    if weights[edge] != nil { return result + weights[edge]! }
                    return result + recursiveReducer(
                        &weights, (key: edge, value: dependencies.adjacencies[edge]!)
                    )
                }
                weights[dependency.key] = weight
                return weight
            }
            let _ = recursiveReducer(&weights, dependency)
        }
        return dependencies.adjacencies.reduce(into: [:], dependeciesReducer)
    }

    /// - Returns: For each `Edge`, a `Set` of `Edge` values, the sum of whose weights the edge's weight
    /// must be greater than for the inverse spelling procedure to be valid.
    func findDependencies () -> DiGraph<PitchedEdge> {
        var residualNetwork = network
        var weightDependencies: [PitchedEdge: [PitchedEdge]] = network.adjacencies
            .reduce(into: [:]) { dependencies, adjacencyForNode in
                adjacencyForNode.1.forEach { dependencies[
                    PitchedEdge(
                        nodeMapper(adjacencyForNode.0.unassigned),
                        nodeMapper($0.unassigned))
                    ] = [] }
        }
        while let augmentingPath = residualNetwork.augmentingPath() {
            let preCutIndex = augmentingPath.lastIndex { $0.assignment == .down }!
            let cutEdge = AssignedEdge(augmentingPath[preCutIndex], augmentingPath[preCutIndex+1])
            for edge in augmentingPath.pairs.map(AssignedEdge.init) where edge != cutEdge {
                weightDependencies[
                    PitchedEdge(
                        self.nodeMapper(edge.a.unassigned),
                        self.nodeMapper(edge.b.unassigned)
                    )
                    ]!.append(
                        PitchedEdge(
                            self.nodeMapper(cutEdge.a.unassigned),
                            self.nodeMapper(cutEdge.b.unassigned)
                        )
                )
            }
            residualNetwork.removeEdge(from: cutEdge.a, to: cutEdge.b)
            residualNetwork.edge(from: cutEdge.b, to: cutEdge.a)
        }
        return DiGraph(weightDependencies)
    }
    
    /// - Returns: getter from an `UnassignedNode` value to a flow network pitched node
    var nodeMapper: (UnassignedNode) -> PitchedNode {
        return bind { Cross(self.pitchClass($0.index.a)!, $0.index.b) }
    }
}

extension InvertingSpellingNetwork {
    
    mutating func partition (via indices: [Int: Int]) {
        let adjacencyScheme = NetworkScheme<Int> { edge in
            switch (edge.a, edge.b) {
            case let (.internal(a), .internal(b)):
                return indices[a] == indices[b]
            default:
                return true
            }
        }
        connect(via: adjacencyScheme)
    }
    
    mutating func connect(via scheme: NetworkScheme<Int>) {
        let temp: NetworkScheme<Cross<Int, Tendency>>
            = (scheme + NetworkScheme<Int> { edge in edge.a == edge.b }).pullback { cross in cross.a }
        let mask: NetworkScheme<AssignedInnerNode> = temp.pullback { node in node.index }
        network.mask(mask)
    }
}

/// Adjacency scheme that connects `.up` tendencies to `.down` tendencies
private let sameIntsScheme: NetworkScheme<UnassignedInnerNode> =
    NetworkScheme<Tendency> { edge in
        switch (edge.a, edge.b) {
        case let (.internal(a), .internal(b)):
            return a == .up && b == .down
        default:
            return false
        }
    }.pullback { node in node.index.b }


/// Adjacency scheme that connects `.source` to `.down` tendencies and not pitch class `8`
private let sourceEdgeLookupScheme: NetworkScheme<Cross<Pitch.Class, Tendency>> =
    NetworkScheme<Pitch.Class> { edge in
        edge.a == .source && edge.b != .internal(8)
        }.pullback { cross in cross.a }
    * NetworkScheme<Tendency> { edge in
        edge.a == .source && edge.b == .internal(.down)
        }.pullback { cross in cross.b }

/// Adjacency scheme that connects `.up` tendencies and not pitch class `8` to `.sink`
private let sinkEdgeLookupScheme: NetworkScheme<Cross<Pitch.Class, Tendency>> =
    NetworkScheme<Pitch.Class> { edge in
        edge.a != .internal(8) && edge.b == .sink
        }.pullback { cross in cross.a }
    * NetworkScheme<Tendency> { edge in
        edge.a == .internal(.up) && edge.b == .sink
        }.pullback { cross in cross.b }

/// Adjacency scheme that connects nodes with the same `int` value
private let connectSameInts: NetworkScheme<UnassignedInnerNode> =
    NetworkScheme<Int> { edge in
        switch (edge.a, edge.b) {
        case let (.internal(a), .internal(b)):
            return a == b
        default:
            return false
        }
    }.pullback { node in node.index.a }

/// Adjacency scheme that connects nodes with different `int` values
private let connectDifferentInts: NetworkScheme<UnassignedInnerNode> =
    NetworkScheme<Int> { edge in
        switch (edge.a, edge.b) {
        case let (.internal(a), .internal(b)):
            return a != b
        default:
            return false
        }
    }.pullback { node in node.index.a }

/// Adjacency scheme that connects `.up` tendencies to `.down` tendencies and vice versa provided
/// the pitch classes of the nodes are connected per `upDownEdgeLookup`
private let upDownEdgeScheme: NetworkScheme<Cross<Pitch.Class, Tendency>> =
    NetworkScheme { edge in
        switch (edge.a, edge.b) {
        case let (.internal(source), .internal(destination)):
            return (
                source.b != destination.b
                    && upDownEdgeLookup.contains(.init(source.a, destination.a))
            )
        default:
            return false
        }
    }

/// Adjacency scheme that connects nodes with the same tendency provided the pitch classes of the nodes
/// are *not* connected per `upDownEdgeLookup`
private let sameEdgeScheme: NetworkScheme<Cross<Pitch.Class, Tendency>> =
    NetworkScheme { edge in
        switch (edge.a, edge.b) {
        case (.internal(let source), .internal(let destination)):
            return (
                source.b == destination.b
                    && !upDownEdgeLookup.contains(.init(source.a, destination.a))
            )
        default:
            return false
        }
    }

/// Pairs of pitch classes that have a different skew, such that `ModifierDirection.neutral` for one node is
/// sharp or 'up' in absolute terms and for the other node it is down
private let upDownEdgeLookup: Set<UnorderedPair<Pitch.Class>> = [
    .init(00, 01),
    .init(00, 04),
    .init(00, 08),
    .init(01, 03),
    .init(01, 05),
    .init(01, 10),
    .init(03, 04),
    .init(03, 06),
    .init(03, 08),
    .init(03, 11),
    .init(04, 05),
    .init(05, 06),
    .init(05, 08),
    .init(05, 11),
    .init(06, 10),
    .init(07, 08),
    .init(08, 10),
    .init(10, 11)
]

extension UnweightedNetwork where InnerNode == AssignedInnerNode {

    // MARK: - Initializers

    /// Create a `DirectedGraph` which is hooked up as neccesary for the Wetherfield inverse-spelling
    /// process.
    init(internalNodes: [AssignedInnerNode]) {
        self.init()
        for node in internalNodes {
            self.insert(node)
            self.sourceEdge(to: node)
            self.sinkEdge(from: node)
            for other in internalNodes where other != node {
                self.internalEdge(from: node, to: other)
            }
        }
    }
}

/// - Returns: Index and assignment of all internal nodes of the `network`.
private func internalNodes (spellings: [Int: Pitch.Spelling]) -> [AssignedInnerNode] {
    return spellings
        .map { offset, spelling in [.down,.up].map { index in node(offset, index, spelling) } }
        .reduce([], +)
}

/// - Returns: The value of a node at the given offset (index of a `Pitch.Spelling` within `spellings`),
/// and an index (either `0` or `1`, which of the two nodes in the `FlowNetwork` that represent
/// the given `Pitch.Spelling`.)
private func node (_ offset: Int, _ index: Tendency, _ pitchSpelling: Pitch.Spelling)
    -> AssignedInnerNode
{
    let pitchCategory = Pitch.Spelling.Category.category(for: pitchSpelling.pitchClass)!
    let direction = pitchCategory.directionToModifier[value: pitchSpelling.modifier]!
    let tendencies = pitchCategory.tendenciesToDirection[value: direction]!
    return .init(index: .init(offset, index), assignment: index == .up ? tendencies.a : tendencies.b)
}
