//
//  NetworkSchemeProtocol.swift
//  NetworkStructures
//
//  Created by Benjamin Wetherfield on 8/28/19.
//

import GraphSchemes

protocol NetworkSchemeProtocol: DirectedGraphSchemeProtocol where Node == FlowNode<InnerNode>, InnerNode: Hashable {
    associatedtype InnerNode
}