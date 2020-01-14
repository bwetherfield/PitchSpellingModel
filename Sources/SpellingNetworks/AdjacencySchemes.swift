//
//  AdjacencySchemes.swift
//  SpellingNetworks
//
//  Created by Benjamin Wetherfield on 8/29/19.
//

import NetworkStructures
import Encodings
import DataStructures
import Pitch

typealias AssignedEdge = OrderedPair<AssignedNode>
typealias UnassignedEdge = OrderedPair<UnassignedNode>
public typealias PitchedNode = FlowNode<Cross<Pitch.Class, Tendency>>
public typealias PitchedEdge = UnorderedPair<PitchedNode>

typealias Connect = AdjacencySchemes

struct AdjacencySchemes {
    
    /// Adjacency scheme that connects `.up` tendencies to `.down` tendencies
    /// for sameInts
    static func upToDown <Index: Hashable> () -> NetworkScheme<Cross<Index, Tendency>> {
        return NetworkScheme<Tendency>(bind { edge in edge.a == .up && edge.b == .down })
            .pullback(get(\Cross.b))
    }
    
    /// Adjacency scheme that connects `.source` to `.down` tendencies and not pitch class `8`
    static let sourceToDown: NetworkScheme<Cross<Pitch.Class, Tendency>> =
        NetworkScheme<Pitch.Class> { edge in
            edge.a == .source && edge.b != .internal(8)
        }.pullback(get(\Cross.a))
            * NetworkScheme<Tendency> { edge in
                edge.a == .source && edge.b == .internal(.down)
            }.pullback(get(\Cross.b))
    
    /// Adjacency scheme that connects `.up` tendencies and not pitch class `8` to `.sink`
    static let upToSink: NetworkScheme<Cross<Pitch.Class, Tendency>> =
        NetworkScheme<Pitch.Class> { edge in
            edge.a != .internal(8) && edge.b == .sink
        }.pullback(get(\Cross.a))
            * NetworkScheme<Tendency> { edge in
                edge.a == .internal(.up) && edge.b == .sink
            }.pullback(get(\Cross.b))
    
    /// Adjacency scheme that connects nodes with the same `int` value
    static func sameIndices <Index: Hashable> () -> NetworkScheme<Cross<Index, Tendency>> {
        return NetworkScheme<Index> (bind { edge in edge.a == edge.b }).pullback(get(\Cross.a))
    }
    
    /// Adjacency scheme that connects nodes with different `int` values
    static func differentIndices <Index: Hashable> () -> NetworkScheme<Cross<Index, Tendency>> {
        return NetworkScheme<Index> (bind { edge in edge.a != edge.b }).pullback(get(\Cross.a))
    }
    
    /// Adjacency scheme that connects nodes with different `Tendency` values for the right `Pitch.Class` values
    static var differentTendenciesAppropriately: NetworkScheme<Cross<Pitch.Class, Tendency>> {
        return connectDifferentTendencies * connectPitchClassesForDifferentTendencies
    }
    
    /// Adjacency scheme that connects nodes with the same `Tendency` values for the right `Pitch.Class` values
    static var sameTendenciesAppropriately: NetworkScheme<Cross<Pitch.Class, Tendency>> {
        return connectSameTendencies * connectPitchClassesForSameTendencies
    }
    
    /// Adjacency scheme that connects `.up` tendencies to `.down` tendencies and vice versa
    static let connectDifferentTendencies: NetworkScheme<Cross<Pitch.Class, Tendency>> =
        NetworkScheme (bind { edge in
            edge.a.b != edge.b.b
                && PitchClassesForDifferentTendenciesLookup.contains(.init(edge.a.a, edge.b.a))
            })
    
    /// Adjacency scheme that connects nodes with the same tendency
    static let connectSameTendencies: NetworkScheme<Cross<Pitch.Class, Tendency>> =
        NetworkScheme (bind { edge in
        edge.a.b == edge.b.b
            && !PitchClassesForDifferentTendenciesLookup.contains(.init(edge.a.a, edge.b.a))
        })
    
    /// Adjacency scheme that connects nodes according to presence in lookup table
    /// `PitchClassesForDifferentTendenciesLookup`
    static let connectPitchClassesForDifferentTendencies: NetworkScheme<Cross<Pitch.Class, Tendency>> =
        NetworkScheme (bind { edge in
            PitchClassesForDifferentTendenciesLookup.contains(.init(edge.a.a, edge.b.a))
        })
    
    /// Adjacency scheme that connects nodes according to absence in lookup table
    /// `PitchClassesForDifferentTendenciesLookup`
    static let connectPitchClassesForSameTendencies: NetworkScheme<Cross<Pitch.Class, Tendency>> =
        NetworkScheme (bind { edge in
            return !PitchClassesForDifferentTendenciesLookup.contains(.init(edge.a.a, edge.b.a))
        })
    
    /// Pairs of pitch classes that have a different skew, such that `ModifierDirection.neutral` for one node is
    /// sharp or 'up' in absolute terms and for the other node it is down
    static let PitchClassesForDifferentTendenciesLookup: Set<UnorderedPair<Pitch.Class>> = [
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
}
