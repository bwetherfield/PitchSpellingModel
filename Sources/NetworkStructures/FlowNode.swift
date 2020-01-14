//
//  FlowNode.swift
//  PitchSpeller
//
//  Created by Benjamin Wetherfield on 6/4/19.
//

import DataStructures

// `FlowNetworkProtocol` `Node` monad wrapper
public enum FlowNode<Index>: Hashable where Index: Hashable {
    case `internal`(Index)
    case source
    case sink
}

/// - Returns: function over `FlowNode` types that derives `internal` return value from `f`
public func bind <S: Hashable, A: Hashable> (_ f: @escaping (S) -> A) -> (FlowNode<S>) -> FlowNode<A> {
    return { flowNodeS in
        switch flowNodeS {
        case .internal(let index): return .internal(f(index))
        case .source: return .source
        case .sink: return .sink
        }
    }
}

/// - Returns: function over `FlowNode` types that derives `internal` return value from `f`, with optional return values.
public func bind <S: Hashable, A: Hashable> (_ f: @escaping (S) -> A?) -> (FlowNode<S>) -> FlowNode<A>? {
    return { flowNodeS in
        switch flowNodeS {
        case .internal(let index):
            guard let index = f(index) else { return nil }
            return .internal(index)
        case .source:
            return .source
        case .sink:
            return .sink
        }
    }
}

/// - Returns: predicate on `Edge` type lifted to `FlowNode` layer
public func lift <A: Hashable> (
    includesSourceAndSinkEdges: Bool = false,
    _ f: @escaping (OrderedPair<A>) -> Bool
) -> (OrderedPair<FlowNode<A>>) -> Bool {
        return { edge in
            switch (edge.a, edge.b) {
            case let (.internal(a), .internal(b)):
                return f(OrderedPair(a, b))
            case (.source, .internal), (.internal, .sink):
                return includesSourceAndSinkEdges
            default:
                return false
            }
    }
}

extension FlowNode: Codable where Index: Codable {
    
    // MARK: - Codable
    
    private enum CodingKeys: String, CodingKey {
        case external
        case `internal`
    }
    enum CodingError: Error {
        case decoding(String)
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let node = try? values.decode(Index.self, forKey: .internal) {
            self = .internal(node)
            return
        } else if let node = try? values.decode(String.self, forKey: .external) {
            self = (node == "source") ? .source : .sink
            return
        }
        throw CodingError.decoding("Decoding Error: \(dump(values))")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .internal(let node):
            try container.encode(node, forKey: .internal)
        case .source:
            try container.encode("source", forKey: .external)
        case .sink:
            try container.encode("sink", forKey: .external)
        }
    }
}
