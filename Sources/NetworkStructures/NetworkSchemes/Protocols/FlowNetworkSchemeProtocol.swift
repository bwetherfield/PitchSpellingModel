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
