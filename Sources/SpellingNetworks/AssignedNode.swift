//
//  AssignedNode.swift
//  SpellingNetworks
//
//  Created by Benjamin Wetherfield on 8/27/19.
//

import Encodings
import NetworkStructures
import DataStructures

typealias AssignedNode = FlowNode<AssignedInnerNode>

struct AssignedInnerNode: Hashable {
    let index: Cross<Int, Tendency>
    let assignment: Tendency
}
