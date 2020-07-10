//
//  DrawScreen.swift
//  PedalNature
//
//  Created by Volkan Sahin on 10.03.2020.
//  Copyright © 2020 Volkan Sahin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class customPin : NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: UIImage
    
    init(pinTitle : String, pinCoordinate : CLLocationCoordinate2D, image: UIImage){
        self.title = pinTitle
        self.coordinate = pinCoordinate
        self.image = image
    }
}

class DrawScreen: UIViewController, MKMapViewDelegate {
    
    var graphDraw = PathGraph(nodeList: [], edgeList: [])
    @IBOutlet weak var drawMapView: MKMapView!
    @IBOutlet weak var distancelabel: UILabel!
    @IBOutlet weak var aveVel: UILabel!
    @IBOutlet weak var aveEl: UILabel!
    @IBOutlet weak var maxEl: UILabel!
    @IBOutlet weak var minEl: UILabel!
    @IBOutlet weak var maxVel: UILabel!
    //Variables for animation
    let startValue = 0.0
    let animationDuration = 1.5
    let animationStartDate = Date()
    var distance = 0.0
    var maxSpeed = 0.0
    var maxElevation = 0.0
    var averageSpeed = 0.0
    var averageElevation = 0.0
    var minElevation = 0.0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawMapView.delegate = self
    }
    //Draw path button
    @IBAction func drawButton(_ sender: Any) {
        drawpolygon()
    }
    
    //Draw user's location history on map
    func drawpolygon(){
        let coordinates = graphDraw.getCoordinates()
        let polyLine = MKPolyline(coordinates: coordinates, count: coordinates.count)
        var spanLat = abs(coordinates[coordinates.count-1].latitude - coordinates[0].latitude)
        var spanLon = abs(coordinates[coordinates.count-1].longitude - coordinates[0].longitude)
        let startNode = graphDraw.getNodes()[3]
        startNode.title = "Start"
        startNode.pinImage = #imageLiteral(resourceName: "start")
        let finishNode = graphDraw.getNodes().last
        finishNode!.pinImage = #imageLiteral(resourceName: "finish")
        finishNode?.title = "Finish"
        if spanLat == 0{
            spanLat = 0.003
        }
        if spanLon == 0{
            spanLon = 0.003
        }
        let span = MKCoordinateSpan(latitudeDelta: spanLat*2, longitudeDelta: spanLon*2)
        let region = MKCoordinateRegion(center: coordinates[coordinates.count/2], span: span)
        drawMapView.setRegion(region, animated: true)
        drawMapView.addOverlay(polyLine)
        drawMapView.addAnnotations(graphDraw.nodeList)
        var (velocities,avVel) = graphDraw.getVelocity()
        distance = graphDraw.totalDistance()
        var (elevations,averEl) = graphDraw.getElevation()
        if elevations.count == 0{
            elevations.append(0.0)
            averEl = 0.0
        }
        if velocities.count == 0{
            velocities.append(0.0)
            avVel = 0.0
        }
        maxSpeed = velocities.max()!
        maxElevation = elevations.max()!
        minElevation = elevations.min()!
        averageSpeed = avVel
        averageElevation = averEl
        let displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink.add(to: .main, forMode: .default)
        

        //graphDraw.printGraph()
        
    }
    
    //Counting effect of Labels
    @objc func handleUpdate(){
        let distanceEndValue = distance
        let maxSpeedEndValue = maxSpeed
        let aveSpeedEndValue = averageSpeed
        let aveElEendValue = averageElevation
        let maxEleEndValue = maxElevation
        let minEleEndValue = minElevation
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        if elapsedTime > animationDuration{
            distancelabel.text = "\(distanceEndValue) m"
            maxVel.text = "\(maxSpeedEndValue) m/s"
            aveVel.text = "\(aveSpeedEndValue) m/s"
            aveEl.text = "\(aveElEendValue) m"
            maxEl.text = "\(maxEleEndValue) m"
            minEl.text = "\(minEleEndValue) m"
        }else{
            let percentage = elapsedTime / animationDuration
            let distanceValue = percentage * (distanceEndValue - startValue)
            let maxSpeedValue = percentage * (maxSpeedEndValue - startValue)
            let aveSpeedValue = percentage * (aveSpeedEndValue - startValue)
            let aveEleValue = percentage * (aveElEendValue - startValue)
            let maxEleValue = percentage * (maxEleEndValue - startValue)
            let minEleValue = percentage * (minEleEndValue - startValue)
            distancelabel.text = "\((distanceValue*10).rounded()/10) m"
            maxVel.text = "\((maxSpeedValue*10).rounded()/10) m/s"
            aveVel.text = "\((aveSpeedValue*10).rounded()/10) m/s"
            aveEl.text = "\((aveEleValue*10).rounded()/10) m"
            maxEl.text = "\((maxEleValue*10).rounded()/10) m"
            minEl.text = "\((minEleValue*10).rounded()/10) m"
        }
    }

    //Draw polygons between every location points
    func mapView(_ drawMapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if(overlay is MKPolyline){
            let polylineRender  = MKPolylineRenderer(overlay: overlay)
            polylineRender.strokeColor = UIColor.red.withAlphaComponent(0.5)
            polylineRender.lineWidth = 5
            return polylineRender
        }
        return MKOverlayRenderer()
    }

    func mapView(_ drawMapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if (annotation is MKUserLocation) {
                return nil
            }
            // Photos taken by user
            let AnnotationIdentifier = "AnnotationIdentifier"
        
            let myAnnotation1 = (annotation as! LocationNode)

            let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: AnnotationIdentifier)
            pinView.canShowCallout = true
            
            myAnnotation1.pinImage = imageResize(with: myAnnotation1.pinImage!, scaledTo: CGSize(width: 48.0, height: 48.0))
            
            pinView.image = myAnnotation1.pinImage
            return pinView
        }
        
    func imageResize(with image: UIImage, scaledTo newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1)
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height/2))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage ?? UIImage()
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "savePath" {
            if let destinationVC = segue.destination as? SavePathScreen {
                destinationVC.graphSave = graphDraw
                destinationVC.distanceValue = distancelabel.text!
                destinationVC.maxSpeedValue = maxVel.text!
                destinationVC.aveSpeedValue = aveVel.text!
                destinationVC.aveEleValue = aveEl.text!
                destinationVC.maxEleValue = maxEl.text!
                destinationVC.minEleValue = minEl.text!
                destinationVC.averageSpeed = averageSpeed
            }
        }
    }

}
