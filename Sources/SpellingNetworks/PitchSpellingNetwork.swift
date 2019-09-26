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
    
    /// The unspelled `Pitch` values to be spelled.
    let pitch: (Int) -> Pitch
}

extension PitchSpellingNetwork {
    
    init(pitches: [Int: Pitch], weightScheme: FlowNetworkScheme<Cross<Pitch.Class, Tendency>>) {
        let pitch = { pitches[$0]! }
        let nodes: [Cross<Int, Tendency>] = pitches.keys.reduce(into: []) { list, int in
            list.append(.init(int, .down))
            list.append(.init(int, .up))
        }
        let betweenScheme: FlowNetworkScheme<Cross<Int, Tendency>> = weightScheme.pullback { cross in
            let pitchClass = pitch(cross.a).class
            return Cross(pitchClass, cross.b)
            }
        let withinScheme: FlowNetworkScheme<Cross<Int, Tendency>> = Double.infinity * (Connect.sameInts * Connect.upToDown)
        let combinedScheme: FlowNetworkScheme<Cross<Int, Tendency>> = withinScheme + betweenScheme
        self.flowNetwork = FlowNetwork(
            nodes: nodes,
            scheme: combinedScheme
            )
        self.pitch = pitch
    }
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
        let pitch = self.pitch(up.index.a)
        let tendencies = TendencyPair(up.assignment, down.assignment)
        let spelling = Pitch.Spelling(pitchClass: pitch.class, tendencies: tendencies)!
        return try! pitch.spelled(with: spelling)
    }
}
