//
//  WeightedEdge.swift
//  PedalNature
//
//  Created by Volkan Sahin on 4.03.2020.
//  Copyright © 2020 Volkan Sahin. All rights reserved.
//

import Foundation

public class WeightedEdge{
    let source : LocationNode
    let destination : LocationNode
    let distance : Double
    let velocity : Double
    
    init(source : LocationNode, destination : LocationNode, distance : Double, velocity: Double) {
        self.source = source
        self.destination = destination
        self.distance = distance
        self.velocity = velocity
    }
    
    public func getSource() -> LocationNode{
        return self.source
    }
    
    public func getDestination() -> LocationNode{
        return self.destination
    }
    
    public func getDistance() -> Double{
        return self.distance
    }
}
