//
//  UnweightedNetworkSchemeProtocol.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/28/19.
//

import GraphSchemes

protocol UnweightedNetworkSchemeProtocol: NetworkSchemeProtocol, UnweightedGraphSchemeProtocol { }

extension UnweightedNetworkSchemeProtocol {
    func pullback<H>(_ f: @escaping (H.InnerNode) -> InnerNode) -> H where H: UnweightedNetworkSchemeProtocol {
        return pullback(bind(f))
    }
}
