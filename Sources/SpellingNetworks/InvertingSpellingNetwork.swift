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
    
    typealias AssignedEdge = OrderedPair<AssignedNode>
    typealias UnassignedEdge = OrderedPair<UnassignedNode>
    public typealias PitchedNode = FlowNode<Cross<Pitch.Class, Tendency>>
    public typealias PitchedEdge = UnorderedPair<PitchedNode>
}

//public struct SpellingInverter {
//
//    // MARK: - Instance Properties
//
//    // The pre-assigned `DirectedGraph` which stands in for the `FlowNetwork` that
//    // would solve to the set of spellings passed into the `SpellingInverter`.
//    var flowNetwork: DirectedGraph<PitchSpeller.AssignedNode>
//
//    let pitchClass: (Int) -> Pitch.Class?
//}
//
//extension SpellingInverter {
//
//    // MARK: - Type Aliases
//
//    typealias AssignedEdge = OrderedPair<PitchSpeller.AssignedNode>
//    typealias UnassignedEdge = OrderedPair<PitchSpeller.UnassignedNode>
//    public typealias PitchedEdge = UnorderedPair<FlowNode<Cross<Pitch.Class,Tendency>>>
//}
//
//extension SpellingInverter {
//
//    // MARK: - Initializers
//
//    public init(spellings: [[Pitch.Spelling]], parsimonyPivot: Pitch.Spelling = .d) {
//        let flattenedSpellings: [Pitch.Spelling] = spellings.reduce(into: []) { flattened, list in
//            list.forEach { flattened.append($0) }
//        }
//        self.init(spellings: flattenedSpellings, parsimonyPivot: parsimonyPivot)
//        var runningCount = 0
//        var indexing: [Int: Int] = [:]
//        for (index, container) in spellings.enumerated() {
//            for (i,_) in container.enumerated() {
//                indexing[i + runningCount] = index
//            }
//            runningCount += container.count
//        }
//        self.partition(via: indexing)
//    }
//
//    init(spellings: [Pitch.Spelling], parsimonyPivot: Pitch.Spelling = .d) {
//        let indexed: [Int: Pitch.Spelling] = spellings.enumerated().reduce(into: [:]) { indexedSpellings, indexedSpelling in
//            let (index, spelling) = indexedSpelling
//            indexedSpellings[index] = spelling
//        }
//        self.init(spellings: indexed, parsimonyPivot: parsimonyPivot)
//    }
//
//    init(spellings: [Int: Pitch.Spelling], parsimonyPivot: Pitch.Spelling = .d) {
//        self.flowNetwork = DirectedGraph(internalNodes: internalNodes(spellings: spellings))
//        self.pitchClass = { int in spellings[int]?.pitchClass }
//
//        let specificEdgeScheme: DirectedGraphScheme<PitchSpeller.UnassignedNode> = (upDownEdgeScheme.pullback(nodeMapper) + sameEdgeScheme.pullback(nodeMapper))
//            * connectDifferentInts
//
//        let sameIntEdgesScheme: DirectedGraphScheme<PitchSpeller.UnassignedNode> =
//            sameIntsScheme * connectSameInts
//
//        let specificSourceScheme: DirectedGraphScheme<PitchSpeller.UnassignedNode> =
//            sourceEdgeLookupScheme.pullback(nodeMapper)
//
//        let specificSinkScheme: DirectedGraphScheme<PitchSpeller.UnassignedNode> =
//            sinkEdgeLookupScheme.pullback(nodeMapper)
//
//        let allSchemes: [DirectedGraphScheme<PitchSpeller.UnassignedNode>] = [
//            specificEdgeScheme,
//            sameIntEdgesScheme,
//            specificSourceScheme,
//            specificSinkScheme
//        ]
//
//        let maskScheme: DirectedGraphScheme<PitchSpeller.AssignedNode> = allSchemes
//            .reduce(DirectedGraphScheme { _ in false }, +)
//            .pullback({ $0.unassigned })
//
//        // Apply masking of specific manifestations of the general global adjacency schemes
//        self.flowNetwork.mask(maskScheme)
//    }
//}
//
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
    
    /// - Returns: getter from a `PitchSpeller.UnassignedNode` to a flow network pitched node
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
//
//extension SpellingInverter {
//
//    // MARK: - Instance Methods
//
//    mutating func partition (via indices: [Int: Int]) {
//        let adjacencyScheme = GraphScheme<FlowNode<Int>> { edge in
//            switch (edge.a, edge.b) {
//            case let (.internal(a), .internal(b)):
//                return indices[a] == indices[b]
//            default:
//                return true
//            }
//        }
//        connect(via: adjacencyScheme)
//    }
//
//    mutating func connect (via adjacencyScheme: GraphScheme<FlowNode<Int>>) {
//        let temp: GraphScheme<FlowNode<Cross<Int, Tendency>>>
//            = (adjacencyScheme + GraphScheme<FlowNode<Int>> { edge in
//                edge.a == edge.b
//                }).pullback(bind { cross in cross.a})
//        let mask: GraphScheme<PitchSpeller.AssignedNode> = temp.pullback { node in node.index }
//        flowNetwork.mask(mask)
//    }
//}
//
//extension SpellingInverter {
//
//    // MARK: - Convenience Functions
//
//    /// Convenience function for testing presence of a given node in the `flowNetwork`
//    func contains (_ indexing: (index: Int, offset: Tendency), _ assignment: Tendency) -> Bool {
//        return flowNetwork.contains(
//            PitchSpeller.AssignedNode(.internal(Cross(indexing.index, indexing.offset)), assignment)
//        )
//    }
//
//    /// Convenience function for testing presence of an internal edge (ignoring assignments)
//    func containsEdge (
//        from source: (index: Int, offset: Tendency),
//        to destination: (index: Int, offset: Tendency)
//        ) -> Bool {
//        return [
//            (.up,.up),
//            (.up,.down),
//            (.down,.down),
//            (.down,.up)
//            ].reduce(false) { (accumulating: Bool, next: (Tendency, Tendency)) -> Bool in
//                accumulating ||
//                    containsEdge(
//                        from: (source.index, source.offset, next.0),
//                        to: (destination.index, destination.offset, next.1)
//                )
//        }
//    }
//
//    /// Convenience function for testing presence of internal edge (with assignments)
//    func containsEdge (
//        from source: (index: Int, offset: Tendency, assignment: Tendency),
//        to destination: (index: Int, offset: Tendency, assignment: Tendency)
//        ) -> Bool {
//        return flowNetwork.containsEdge(
//            from: PitchSpeller.AssignedNode(
//                .internal(Cross(source.index, source.offset)), source.assignment
//            ),
//            to: PitchSpeller.AssignedNode(
//                .internal(Cross(destination.index, destination.offset)), destination.assignment
//            )
//        )
//    }
//
//    /// Convenience function for testing presence of edge from source (ignoring assignment)
//    func containsSourceEdge (to destination: (index: Int, offset: Tendency)) -> Bool {
//        return [.up, .down].reduce(false) { accumulating, next in
//            accumulating || containsSourceEdge(
//                from: .down,
//                to: (destination.index, destination.offset, next)
//            )
//        }
//    }
//
//    /// Convenience function for testing presence of edge to sink (ignoring assignment)
//    func containsSinkEdge(from source: (index: Int, offset: Tendency)) -> Bool {
//        return [.up, .down].reduce(false) { accumulating, next in
//            accumulating || containsSinkEdge(
//                from: (source.index, source.offset, next),
//                to: .up
//            )
//        }
//    }
//
//    /// Convenience function for testing presence of edge from source (with assignments)
//    func containsSourceEdge (
//        from sourceTendency: Tendency,
//        to destination: (index: Int, offset: Tendency, assignment: Tendency)
//        ) -> Bool {
//        return flowNetwork.containsEdge(
//            from: PitchSpeller.AssignedNode(.source, sourceTendency),
//            to: PitchSpeller.AssignedNode(
//                .internal(Cross(destination.index, destination.offset)), destination.assignment
//            )
//        )
//    }
//
//    /// Convenience function for testing presence of edge to sink (with assignments)
//    func containsSinkEdge (
//        from source: (index: Int, offset: Tendency, assignment: Tendency),
//        to destinationTendency: Tendency
//        ) -> Bool {
//        return flowNetwork.containsEdge(
//            from: PitchSpeller.AssignedNode(
//                .internal(Cross(source.index, source.offset)), source.assignment
//            ),
//            to: PitchSpeller.AssignedNode(.sink, destinationTendency)
//        )
//    }
//}
//
///// Adjacency scheme that connects `.up` tendencies to `.down` tendencies
//private let sameIntsScheme: DirectedGraphScheme<PitchSpeller.UnassignedNode> =
//    DirectedGraphScheme<Tendency?> { edge in edge.a == .up && edge.b == .down }
//        .pullback { node in node.index.tendency}
//
///// Adjacency scheme that connects `.source` to `.down` tendencies and not pitch class `8`
//private let sourceEdgeLookupScheme: DirectedGraphScheme<FlowNode<Cross<Pitch.Class, Tendency>>> =
//    DirectedGraphScheme<FlowNode<Pitch.Class>> { edge in
//        edge.a == .source && edge.b != .internal(8)
//        }.pullback(bind({ cross in cross.a }))
//        * DirectedGraphScheme<FlowNode<Tendency>> { edge in
//            edge.a == .source && edge.b == .internal(.down)
//            }.pullback(bind ({ cross in cross.b }))
//
///// Adjacency scheme that connects `.up` tendencies and not pitch class `8` to `.sink`
//private let sinkEdgeLookupScheme: DirectedGraphScheme<FlowNode<Cross<Pitch.Class, Tendency>>> =
//    DirectedGraphScheme<FlowNode<Pitch.Class>> { edge in
//        edge.a != .internal(8) && edge.b == .sink
//        }.pullback(bind({ cross in cross.a }))
//        * DirectedGraphScheme<FlowNode<Tendency>> { edge in
//            edge.a == .internal(.up) && edge.b == .sink
//            }.pullback(bind ({ cross in cross.b }))
//
///// Adjacency scheme that connects nodes with the same `int` value
//private let connectSameInts: GraphScheme<PitchSpeller.UnassignedNode> =
//    GraphScheme<Int> { edge in edge.a == edge.b }.pullback { node in node.index.int! }
//
///// Adjacency scheme that connects nodes with different `int` values
//private let connectDifferentInts: GraphScheme<PitchSpeller.UnassignedNode> =
//    GraphScheme<Int> { edge in edge.a != edge.b }.pullback { node in node.index.int! }
//
///// Adjacency scheme that connects `.up` tendencies to `.down` tendencies and vice versa provided
///// the pitch classes of the nodes are connected per `upDownEdgeLookup`
//private let upDownEdgeScheme: DirectedGraphScheme<FlowNode<Cross<Pitch.Class, Tendency>>> =
//    GraphScheme { edge in
//        switch (edge.a, edge.b) {
//        case (.internal(let source), .internal(let destination)):
//            return (
//                source.b != destination.b &&
//                    upDownEdgeLookup.contains(.init(source.a, destination.a))
//            )
//        default:
//            return false
//        }
//        }.directed
//
///// Adjacency scheme that connects nodes with the same tendency provided the pitch classes of the nodes
///// are *not* connected per `upDownEdgeLookup`
//private let sameEdgeScheme: DirectedGraphScheme<FlowNode<Cross<Pitch.Class, Tendency>>> =
//    GraphScheme { edge in
//        switch (edge.a, edge.b) {
//        case (.internal(let source), .internal(let destination)):
//            return (
//                source.b == destination.b &&
//                    !upDownEdgeLookup.contains(.init(source.a, destination.a))
//            )
//        default:
//            return false
//        }
//        }.directed
//
///// Pairs of pitch classes that have a different skew, such that `ModifierDirection.neutral` for one node is
///// sharp or 'up' in absolute terms and for the other node it is down
//private let upDownEdgeLookup: [UnorderedPair<Pitch.Class>] = [
//    .init(00, 01),
//    .init(00, 04),
//    .init(00, 08),
//    .init(01, 03),
//    .init(01, 05),
//    .init(01, 10),
//    .init(03, 04),
//    .init(03, 06),
//    .init(03, 08),
//    .init(03, 11),
//    .init(04, 05),
//    .init(05, 06),
//    .init(05, 08),
//    .init(05, 11),
//    .init(06, 10),
//    .init(07, 08),
//    .init(08, 10),
//    .init(10, 11)
//]
//
//extension DirectedGraph where Node == PitchSpeller.AssignedNode {
//
//    // MARK: - Initializers
//
//    /// Create a `DirectedGraph` which is hooked up as neccesary for the Wetherfield inverse-spelling
//    /// process.
//    init(internalNodes: [PitchSpeller.InternalAssignedNode]) {
//        self.init()
//        let source = PitchSpeller.AssignedNode(.source, .down)
//        let sink = PitchSpeller.AssignedNode(.sink, .up)
//        self.insert(source)
//        self.insert(sink)
//
//        var mapInternal: (PitchSpeller.InternalAssignedNode) -> PitchSpeller.AssignedNode {
//            return { .init(.internal($0.index), $0.assignment) }
//        }
//
//        for internalNode in internalNodes {
//            let node = mapInternal(internalNode)
//            insert(node)
//            insertEdge(from: source, to: node)
//            insertEdge(from: node, to: sink)
//            for otherInternalNode in internalNodes where otherInternalNode != internalNode {
//                let other = mapInternal(otherInternalNode)
//                insertEdge(from: node, to: other)
//            }
//        }
//    }
//
//    // MARK: - Instance Methods
//
//    /// Lazily removes adjacencies from the `flowNetwork` according to `adjacencyScheme`
//    mutating func mask <Scheme: UnweightedGraphSchemeProtocol> (_ adjacencyScheme: Scheme) where
//        Scheme.Node == Node
//    {
//        for edge in edges where !adjacencyScheme.containsEdge(from: edge.a, to: edge.b) {
//            remove(edge)
//        }
//    }
//}
//
///// - Returns: Index and assignment of all internal nodes of the `flowNetwork`.
//private func internalNodes (spellings: [Int: Pitch.Spelling]) -> [PitchSpeller.InternalAssignedNode] {
//    return spellings
//        .map { offset, spelling in [.down,.up].map { index in node(offset, index, spelling) } }
//        .reduce([], +)
//}
//
///// - Returns: The value of a node at the given offset (index of a `Pitch.Spelling` within `spellings`),
///// and an index (either `0` or `1`, which of the two nodes in the `FlowNetwork` that represent
///// the given `Pitch.Spelling`.)
//private func node (_ offset: Int, _ index: Tendency, _ pitchSpelling: Pitch.Spelling)
//    -> PitchSpeller.InternalAssignedNode
//{
//    let pitchCategory = Pitch.Spelling.Category.category(for: pitchSpelling.pitchClass)!
//    let direction = pitchCategory.directionToModifier[value: pitchSpelling.modifier]!
//    let tendencies = pitchCategory.tendenciesToDirection[value: direction]!
//    return .init(.init(offset, index), index == .up ? tendencies.a : tendencies.b)
//}
