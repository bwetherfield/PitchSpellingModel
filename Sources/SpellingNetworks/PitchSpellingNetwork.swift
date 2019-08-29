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

struct PitchSpellingNetwork {
    
    // MARK: - Instance Properties
    
    /// The `FlowNetwork` which will be manipulated in order to spell the unspelled `pitches`.
    var flowNetwork: FlowNetwork<Cross<Int,Tendency>>
    
    /// The unspelled `Pitch.Class` values to be spelled.
    let pitch: (Int) -> Pitch?
}
//
//extension PitchSpellingNetwork {
//
//    // MARK: - Initializers
//
//    /// Creates a `PitchSpeller` to spell the given `pitches`, with the given `parsimonyPivot`.
//    init(pitches: [Int: Pitch]) {
//        self.flowNetwork = FlowNetwork(internalNodes: internalNodes(pitches: pitches))
//        self.pitchClass = { pitches[$0]!.class }
//
//        let internalPitchClassTendency = { (cross: Cross<Int, Tendency>) in
//            Cross(pitches[cross.a]!.class, cross.b)
//        }
//        let pitchClassTendencyGetter = bind(internalPitchClassTendency)
//
//        let specificSourceEdges: WeightedDirectedGraphScheme<PitchSpellingNode.Index, Double> =
//            sourceEdges.pullback(pitchClassTendencyGetter)
//        let specificInternalEdges: WeightedDirectedGraphScheme<PitchSpellingNode.Index, Double> =
//            internalEdges.pullback(pitchClassTendencyGetter)
//        let specificSinkEdges: WeightedDirectedGraphScheme<PitchSpellingNode.Index, Double> =
//            sinkEdges.pullback(pitchClassTendencyGetter)
//
//        // All the connections that rely on pitch class specific information
//        let connections: WeightedDirectedGraphScheme<PitchSpellingNode.Index, Double> =
//            (connectDifferentInts * specificInternalEdges) + specificSourceEdges + specificSinkEdges
//
//        // Combination of pitch class specific information and connections within each `Int` index
//        // regardless of pitch class.
//        let maskArgument: WeightedDirectedGraphScheme<PitchSpellingNode.Index, Double> =
//            connections + bigMAssignment
//        flowNetwork.mask(maskArgument)
//    }
//}

extension PitchSpellingNetwork {

    // MARK: - Instance Methods

    /// - Returns: An array of `SpelledPitch` values with the same indices as the original
    /// unspelled `Pitch` values.
    func spell() -> [Int: SpelledPitch] {

        var assignedNodes: [AssignedNode] {
            var (sourceSide, sinkSide) = flowNetwork.sourceWeightedMinimumCut
            sourceSide.remove(.source)
            sinkSide.remove(.sink)
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
        let pitch = self.pitch(up.index.a)!
        let tendencies = TendencyPair(up.assignment, down.assignment)
        let spelling = Pitch.Spelling(pitchClass: pitch.class, tendencies: tendencies)!
        return try! pitch.spelled(with: spelling)
    }
}

//private let connectUpToDown: DirectedGraphScheme<PitchSpellingNode.Index> =
//    DirectedGraphScheme<Tendency> { edge in edge.a == .up && edge.b == .down }
//        .pullback { node in node.tendency }
//
//private let bigMAdjacency: DirectedGraphScheme<PitchSpellingNode.Index> =
//    connectSameInts * connectUpToDown
//
//private let bigMAssignment: WeightedDirectedGraphScheme<PitchSpellingNode.Index, Double> =
//    Double.infinity * bigMAdjacency
//
//private let connectSameInts: GraphScheme<PitchSpellingNode.Index> =
//    GraphScheme<Int?> { edge in edge.a == edge.b && edge.a != nil }.pullback { node in node.int }
//
//private let connectDifferentInts: GraphScheme<PitchSpellingNode.Index> =
//    GraphScheme<Int?> { edge in !(edge.a == edge.b && edge.a != nil) }.pullback { node in node.int }
//
//private let sourceEdges =
//    WeightedDirectedGraphScheme<FlowNode<Cross<Pitch.Class, Tendency>>, Double> { edge in
//        (edge.a == .source && edge.b.tendency == .down)
//            ? edge.b.pitchClass.flatMap { index in sourceEdgeLookup[index] }
//            : nil
//}
//
//// Default weights:
//let heavyWeight: Double = 3
//let middleWeight: Double = 2
//// welterWeight (if necessary)
//let lightWeight: Double = 1.5
//let featherWeight: Double = 1
//// bantamWeight (if necessary)
//let flyWeight: Double = 0.5
//
//private let sourceEdgeLookup: [Pitch.Class: Double] = [
//    00: middleWeight,
//    01: heavyWeight,
//    02: heavyWeight,
//    03: featherWeight,
//    04: heavyWeight,
//    05: middleWeight,
//    06: heavyWeight,
//    07: heavyWeight,
//
//    09: heavyWeight,
//    10: featherWeight,
//    11: heavyWeight,
//]
//
//private let sinkEdges =
//    WeightedDirectedGraphScheme<FlowNode<Cross<Pitch.Class, Tendency>>, Double> { edge in
//        (edge.b == .sink && edge.a.tendency == .up)
//            ? edge.a.pitchClass.flatMap { index in sinkEdgeLookup[index] }
//            : nil
//}
//
//private let sinkEdgeLookup: [Pitch.Class: Double] = [
//    00: heavyWeight,
//    01: featherWeight,
//    02: middleWeight,
//    03: heavyWeight,
//    04: heavyWeight,
//    05: heavyWeight,
//    06: featherWeight,
//    07: heavyWeight,
//
//    09: heavyWeight,
//    10: heavyWeight,
//    11: middleWeight,
//]
//
//private let internalEdges: WeightedDirectedGraphScheme<FlowNode<Cross<Pitch.Class, Tendency>>, Double> =
//    WeightedGraphScheme { edge in
//        switch (edge.a, edge.b) {
//        case (.internal(let source), .internal(let destination)):
//            return internalEdgeLookup[.init(source, destination)]
//        default: return nil
//        }
//        }.directed
//
//private let internalEdgeLookup: [UnorderedPair<Cross<Pitch.Class, Tendency>>: Double] = [
//
//    // Replacement for eightTendencyLink
//    .init(.init(00, .down), .init(08,   .up)): featherWeight,
//    .init(.init(01,   .up), .init(08,   .up)): featherWeight,
//    .init(.init(03, .down), .init(08,   .up)): featherWeight,
//    .init(.init(04,   .up), .init(08,   .up)): featherWeight,
//    .init(.init(05, .down), .init(08,   .up)): featherWeight,
//    .init(.init(06,   .up), .init(08,   .up)): featherWeight,
//    .init(.init(07, .down), .init(08,   .up)): featherWeight,
//    .init(.init(08,   .up), .init(08,   .up)): featherWeight,
//    .init(.init(09,   .up), .init(08,   .up)): featherWeight,
//    .init(.init(10, .down), .init(08,   .up)): featherWeight,
//    .init(.init(11,   .up), .init(08,   .up)): featherWeight,
//
//    .init(.init(00, .down), .init(01,   .up)): lightWeight,
//    .init(.init(00,   .up), .init(01, .down)): flyWeight,
//
//    .init(.init(01, .down), .init(03,   .up)): featherWeight,
//    .init(.init(01,   .up), .init(03, .down)): featherWeight,
//
//    .init(.init(01, .down), .init(05,   .up)): flyWeight,
//    .init(.init(01,   .up), .init(05, .down)): lightWeight
//]
//
//extension FlowNetwork where InnerNode == Cross<Int,Tendency>, Weight == Double {
//
//    /// Create a `FlowNetwork` which is hooked up as neccesary for the Wetherfield pitch-spelling
//    /// process.
//    init(internalNodes: [Cross<Int,Tendency>]) {
//        self.init()
//        for internalNode in internalNodes {
//            let node = FlowNode.internal(internalNode)
//            insertEdge(from: .source, to: node, weight: featherWeight)
//            insertEdge(from: node, to: .sink, weight: featherWeight)
//            for internalOther in internalNodes.lazy.filter({ $0 != internalNode }) {
//                let other = FlowNode.internal(internalOther)
//                insertEdge(from: node, to: other, weight: featherWeight)
//            }
//        }
//    }
//
//    /// Creates an empty `FlowNetwork` ready to be used incrementally constructed for the purposes
//    /// of pitch spelling.
//    init() {
//        self.nodes = []
//        self.weights = [:]
//    }
//}
//
///// - Returns: An array of nodes, each representing the index of the unassigned node in
///// `pitchNodes`.
//private func internalNodes(pitches: [Int: Pitch]) -> [Cross<Int,Tendency>] {
//    return pitches.keys.flatMap { offset in [.down,.up].map { index in .init(offset, index) } }
//}
//
///// - Returns: The value of a node at the given offset (index of a `Pitch` within `pitches`),
///// and an index (either `0` or `1`, which of the two nodes in the `FlowNetwork` that represent
///// the given `Pitch`.)
//private func node(_ offset: Int, _ index: Tendency) -> Cross<Int,Tendency> {
//    return .init(offset, index)
//}
//
//extension FlowNode: CustomStringConvertible {
//
//    // MARK: - CustomStringConvertible
//
//    /// Printable description of `FlowNode`.
//    public var description: String {
//        switch self {
//        case .source:
//            return "source"
//        case .sink:
//            return "sink"
//        case .internal(let index):
//            return "\(index)"
//        }
//    }
//}
