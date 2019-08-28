//
//  FlowNode.swift
//  PitchSpeller
//
//  Created by Benjamin Wetherfield on 6/4/19.
//

public enum FlowNode<Index>: Hashable where Index: Hashable {
    case `internal`(Index)
    case source
    case sink
}

public func bind <S: Hashable, A: Hashable> (_ f: @escaping (S) -> A) -> (FlowNode<S>) -> FlowNode<A> {
    return { flowNodeS in
        switch flowNodeS {
        case .internal(let index): return .internal(f(index))
        case .source: return .source
        case .sink: return .sink
        }
    }
}

extension FlowNode: Codable where Index: Codable {
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
