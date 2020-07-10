//
//  PathGraph.swift
//  PedalNature
//
//  Created by Volkan Sahin on 4.03.2020.
//  Copyright © 2020 Volkan Sahin. All rights reserved.
//

import Foundation
import CoreLocation
import Foundation

public class PathGraph{
    var nodeList : [LocationNode]
    var edgeList : [WeightedEdge]
    
    init(nodeList : [LocationNode] , edgeList : [WeightedEdge]){
        self.nodeList = nodeList
        self.edgeList = edgeList
    }
    
    public func addNode(Node: LocationNode){
        if !(nodeList.contains(Node)){
            nodeList.append(Node)
        }
    }
    
    public func createEdge(){
        if nodeList.count > 1{
            for i in 0..<(nodeList.count - 1){
                let src = nodeList[i]
                let dest = nodeList[i+1]
                let dist = getDistanceFromLatLonInMeter(lat1: src.latitude, lon1: src.longitude, lat2: dest.latitude, lon2: dest.longitude)
                let velocity = calculateVelocity(distance: dist, startTime: src.starttime, endTime: dest.starttime)
                let edge = WeightedEdge(source: src, destination: dest, distance: dist, velocity: velocity)
                self.addEdge(edge: edge)
            }
        }
        
    }
    public func calculateVelocity(distance : Double, startTime : CFAbsoluteTime, endTime : CFAbsoluteTime) -> Double{
        let velocity =  distance / (endTime - startTime)
        return velocity
        
    }
    
    public func getDistanceFromLatLonInMeter(lat1 : Double, lon1 : Double,lat2: Double,lon2 : Double) -> Double{
        let R = Double(6371000); // Radius of the earth in m
        let dLat = (lat2-lat1) * Double.pi / 180;  // deg2rad below
        let dLon = (lon2-lon1) * Double.pi / 180;
        let a = sin(dLat/2) * sin(dLat/2) + cos(lat1 * Double.pi / 180) * cos(lat2 * Double.pi / 180) * sin(dLon/2) * sin(dLon/2)
        let c = 2 * atan2(a.squareRoot(), (1-a).squareRoot());
        let distance = R * c; // Distance in m
        return distance
    }

    public func addEdge(edge : WeightedEdge){
        let source = edge.getSource()
        let destination = edge.getDestination()
        if nodeList.contains(source) && nodeList.contains(destination){
            edgeList.append(edge)
        }
    }
    public func getNodes() -> [LocationNode]{
        return self.nodeList
    }
    
    public func printGraph(){
        var i = 0
        for node in nodeList{
            print("Node_\(i)")
            print("latitude : \(node.latitude)")
            print("longitude : \(node.longitude)")
            i = i + 1
        }
        for i in 0...nodeList.count-2{
            print("time : \(nodeList[i+1].starttime - nodeList[i].starttime)" )
        }
        for edge in edgeList{
            print("\(edge.distance) -- \(edge.velocity)")
        }
    }
    
    public func getVelocity() -> ([Double],Double){
        var velocities = [Double]()
        var totalVel = 0.0
        if edgeList.count > 3{
            for edge in edgeList[3...]{
                velocities.append((edge.velocity*10).rounded()/10)
                totalVel = totalVel + (edge.velocity * edge.distance)
            }
            return (velocities,((totalVel / totalDistance())*10).rounded()/10)
        }
        return ([0.0],0.0)
    }
    
    public func totalDistance() -> Double{
        var totalDistance = 0.0
        if edgeList.count > 3{
            for edge in edgeList[3...]{
                totalDistance = totalDistance + edge.distance
            }
            return (totalDistance*10).rounded()/10
        }
        return 0.0
    }
    
    public func getElevation() -> ([Double],Double){
        var elevations = [Double]()
        if nodeList.count > 3{
            for node in nodeList[3...]{
                elevations.append((node.altitude*10).rounded()/10)
            }
            let averEl = elevations.reduce(0, +) / Double(elevations.count)
            return (elevations,(averEl*10).rounded()/10)
        }
        return ([0.0],0)
    }
    
    public func getCoordinates() -> [CLLocationCoordinate2D]{
        var coordinates : [CLLocationCoordinate2D] = []
        if nodeList.count > 3{
            for coordinate in self.getNodes()[3...]{
                coordinates.append(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
            }
            return coordinates
        }
        return [CLLocationCoordinate2D()]
    }
}
