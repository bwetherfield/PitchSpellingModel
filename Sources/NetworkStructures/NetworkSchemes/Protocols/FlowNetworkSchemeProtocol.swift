//
//  FlowNetworkSchemeProtocol.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/28/19.
//

public protocol FlowNetworkSchemeProtocol: NetworkSchemeProtocol, WeightedGraphSchemeProtocol { }

extension FlowNetworkSchemeProtocol {
    public func pullback<H>(_ f: @escaping (H.InnerNode) -> InnerNode) -> H where H: FlowNetworkSchemeProtocol, H.Weight == Weight {
        return pullback(bind(f))
    }
}

extension FlowNetworkSchemeProtocol {

    public static func + (lhs: Self, rhs: Self) -> Self {
        return Self { edge in
            guard let left = lhs.weight(edge) else {
                return rhs.weight(edge)
            }
            guard let right = rhs.weight(edge) else {
                return left
            }
            return left + right
        }
    }

    public static func * (lhs: Self, rhs: Self) -> Self {
        return Self { edge in
            if let left = lhs.weight(edge), let right = rhs.weight(edge) {
                return left * right
            } else {
                return nil
            }
        }
    }
}
