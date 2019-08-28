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

extension FlowNode where Index == AssignedInnerNode {
    var unassigned: UnassignedNode {
        return bind { $0.unassigned }(self)
    }
}

struct AssignedInnerNode: Hashable {
    let index: Cross<Int, Tendency>
    let assignment: Tendency
}

extension AssignedInnerNode {
    var unassigned: UnassignedInnerNode {
        return .init(index: index)
    }
}
