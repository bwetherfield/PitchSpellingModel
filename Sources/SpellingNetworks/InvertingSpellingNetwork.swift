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

class InvertingSpellingNetwork {
    
    var network: UnweightedNetwork<AssignedInnerNode>
    let pitchClass: (Int) -> Pitch.Class?

    // MARK: - Initializers

    convenience init(spellings: [[Pitch.Spelling]]) {
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

    convenience init(spellings: [Pitch.Spelling]) {
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
    
    /// - Returns: A closure that generates a PitchSpellingNetwork from an indexed collection of `Pitch` values
    public func pitchSpellingNetworkFactory () -> PitchSpellingNetworkFactory {
        let weights = generateWeights()
        let weightScheme = FlowNetworkScheme { edge in
            weights[.init(edge.a, edge.b)]
        }
        return PitchSpellingNetworkFactory(weightScheme)
    }

    /// - Returns: A concrete distribution of weights to satisfy the weight relationships delimited by
    /// `weightDependencies` or `nil` if no such distribution is possible, i.e. there are cyclical
    /// dependencies between edge types. In the latter case, the spellings fed in are *inconsistent*.
    /// Weights are parametrized by `Pitch.Class` and `Tendency` values.
    public func generateWeights (_ preset: Memo<PitchedEdge>? = nil) -> [PitchedEdge: Double] {
        let pitchedDependencies = findDependencies()
        if pitchedDependencies.containsCycle() {
            return generateWeightsFromCycles(pitchedDependencies)
        }
        return generateWeights(from: pitchedDependencies, using: preset)
    }

    func generateWeightsFromCycles (
        _ dependencies: DiGraph<PitchedEdge>,
        _ preset: Memo<Set<PitchedEdge>>? = nil)
        -> [PitchedEdge: Double] {
            let directedAcyclicGraph = dependencies.DAGify()
            let groupedWeights: [Set<PitchedEdge>: Double] = generateWeights(from: directedAcyclicGraph)
            return groupedWeights.reduce(into: [PitchedEdge: Double]()) { runningWeights, pair in
                pair.key.forEach { pitchedEdge in
                    runningWeights[pitchedEdge] = pair.value
                }
            }
    }

    func generateWeights<Node> (
        from dependencies: DiGraph<Node>,
        using preset: Memo<Node>? = nil
    ) -> [Node: Double] {
        func dependenciesReducer (
            _ weights: inout [Node: Double],
            _ dependency: (key: Node, value: [Node])
            )
        {
            func getWeight (
                _ weights: inout [Node: Double],
                _ dependency: (key: Node, value: [Node])
                ) -> Double
            {
                if let weight = weights[dependency.key] {
                    return weight
                }
                let weight = preset?.weight(dependency.key) ??
                    dependency.value.reduce(1.0) { result, edge in
                        return result + getWeight(
                            &weights, (key: edge, value: dependencies.adjacencies[edge]!)
                        )
                    }
                weights[dependency.key] = weight
                return weight
            }
            let _ = getWeight(&weights, dependency)
        }
        return dependencies.adjacencies.reduce(into: [:], dependenciesReducer)
    }
    
    struct Memo<Node> {
        let weight: (Node) -> Double?
        
        init(_ weight: @escaping (Node) -> Double?) {
            self.weight = weight
        }
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
        return bind { Cross(self.pitchClass($0.a)!, $0.b) }
    }
}

extension InvertingSpellingNetwork {
    
    func partition (via indices: [Int: Int]) {
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
    
    func connect(via scheme: NetworkScheme<Int>) {
        let temp: NetworkScheme<Cross<Int, Tendency>>
            = (scheme + NetworkScheme<Int> { edge in edge.a == edge.b }).pullback { cross in cross.a }
        let mask: NetworkScheme<AssignedInnerNode> = temp.pullback { node in node.index }
        network.mask(mask)
    }
}

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
    let pitchCategory = Pitch.Spelling.Category[pitchSpelling.pitchClass]!
    let direction = pitchCategory.directionToModifier[value: pitchSpelling.modifier]!
    let tendencies = pitchCategory.tendenciesToDirection[value: direction]!
    return .init(index: .init(offset, index), assignment: index == .up ? tendencies.a : tendencies.b)
}

extension InvertingSpellingNetwork {
    
    // MARK: - Convenience Functions
    
    /// Convenience function for testing presence of a given node in the `flowNetwork`
    func contains (_ indexing: (index: Int, offset: Tendency), _ assignment: Tendency) -> Bool {
        return network.contains(
            .internal(.init(
                index: Cross(indexing.index, indexing.offset),
                assignment: assignment)
            )
        )
    }
    
    /// Convenience function for testing presence of an internal edge (ignoring assignments)
    func containsEdge (
        from source: (index: Int, offset: Tendency),
        to destination: (index: Int, offset: Tendency)
    ) -> Bool {
        return [
            (.up,.up),
            (.up,.down),
            (.down,.down),
            (.down,.up)
        ].reduce(false) { (accumulating: Bool, next: (Tendency, Tendency)) -> Bool in
            accumulating ||
            containsEdge(
                from: (source.index, source.offset, next.0),
                to: (destination.index, destination.offset, next.1)
            )
        }
    }
    
    /// Convenience function for testing presence of internal edge (with assignments)
    func containsEdge (
        from source: (index: Int, offset: Tendency, assignment: Tendency),
        to destination: (index: Int, offset: Tendency, assignment: Tendency)
    ) -> Bool {
        return network.containsEdge(
            from: .init(index: Cross(source.index, source.offset), assignment: source.assignment),
            to: .init(index: Cross(destination.index, destination.offset), assignment: destination.assignment)
        )
    }
    
    /// Convenience function for testing presence of edge from source (ignoring assignment)
    func containsSourceEdge (to destination: (index: Int, offset: Tendency)) -> Bool {
        return [.up, .down].reduce(false) { accumulating, next in
            accumulating || containsSourceEdge(
                to: (destination.index, destination.offset, next)
            )
        }
    }
    
    /// Convenience function for testing presence of edge to sink (ignoring assignment)
    func containsSinkEdge(from source: (index: Int, offset: Tendency)) -> Bool {
        return [.up, .down].reduce(false) { accumulating, next in
            accumulating || containsSinkEdge(
                from: (source.index, source.offset, next)
            )
        }
    }
    
    /// Convenience function for testing presence of edge from source (with assignments)
    func containsSourceEdge (
        to destination: (index: Int, offset: Tendency, assignment: Tendency)
    ) -> Bool {
        return network.containsSourceEdge(to: .init(
                index: Cross(destination.index, destination.offset),
                assignment: destination.assignment
            )
        )
}
    
    /// Convenience function for testing presence of edge to sink (with assignments)
    func containsSinkEdge (
        from source: (index: Int, offset: Tendency, assignment: Tendency)
    ) -> Bool {
        return network.containsSinkEdge(
            from: .init(
                index: Cross(source.index, source.offset),
                assignment: source.assignment
            )
        )
    }
}

extension InvertingSpellingNetwork.Memo where Node: Hashable {
    func pullback() -> InvertingSpellingNetwork.Memo<Set<Node>> {
        return InvertingSpellingNetwork.Memo<Set<Node>> ({
            let representative = $0.first!
            return self.weight(representative)
        })
    }
}
