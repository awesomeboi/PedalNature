//
//  SavePathScreen.swift
//  PedalNature
//
//  Created by Volkan Sahin on 17.03.2020.
//  Copyright © 2020 Volkan Sahin. All rights reserved.
//

import UIKit
import MapKit

class SavePathScreen: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var pathMap: MKMapView!
    var graphSave = PathGraph(nodeList: [], edgeList: [])
    var distanceValue = String()
    var maxSpeedValue = String()
    var aveSpeedValue = String()
    var aveEleValue = String()
    var maxEleValue = String()
    var minEleValue = String()
    var averageSpeed = Double()
    @IBOutlet weak var distanceField: UITextField!
    @IBOutlet weak var maxSpeedField: UITextField!
    @IBOutlet weak var aveSpeedField: UITextField!
    @IBOutlet weak var maxEleField: UITextField!
    @IBOutlet weak var minEleField: UITextField!
    @IBOutlet weak var aveEleField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var activityTypeField: UITextField!
    @IBOutlet weak var pathTypeField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    var cityName = String()
    var countryName = String()
    
    var pathList = ["Striped Bike Lanes","Urban","Off-Road","Paved","Dirt and Rock"]
    override func viewDidLoad() {
        super.viewDidLoad()
        drawpolygon()
        let nodeLocation = graphSave.nodeList[3].locationvalue
        CLGeocoder().reverseGeocodeLocation(nodeLocation) { placemark, error in
            guard error == nil,
                let placemark = placemark
            else
            {
                // TODO: Handle error
                return
            }

            if placemark.count > 0 {
                let place = placemark[0]
                self.cityName = place.locality!
                self.countryName = place.country!
                self.cityField.text = self.cityName
                self.countryField.text = self.countryName
            }
        }
        
        pathMap.delegate = self
        pathTypeField.loadDropdownData(data: pathList)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        let dateVar = Date(timeIntervalSinceReferenceDate: graphSave.nodeList[0].starttime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateField.text = dateFormatter.string(from:dateVar)
        distanceField.text = distanceValue
        maxSpeedField.text = maxSpeedValue
        aveSpeedField.text = aveSpeedValue
        maxEleField.text = maxEleValue
        minEleField.text = minEleValue
        aveEleField.text = aveEleValue
        let avSpeed = ((averageSpeed*10).rounded()/10)
        if avSpeed < 3.0{
            activityTypeField.text = "Walk"
        }
        else if avSpeed < 14.0{
            activityTypeField.text = "Bicycle"
        }
        else{
            activityTypeField.text = "Car"
        }
        dateField.backgroundColor = .lightGray
        dateField.isUserInteractionEnabled = false
        distanceField.backgroundColor = .lightGray
        distanceField.isUserInteractionEnabled = false
        maxSpeedField.backgroundColor = .lightGray
        maxSpeedField.isUserInteractionEnabled = false
        aveSpeedField.backgroundColor = .lightGray
        aveSpeedField.isUserInteractionEnabled = false
        maxEleField.backgroundColor = .lightGray
        maxEleField.isUserInteractionEnabled = false
        minEleField.backgroundColor = .lightGray
        minEleField.isUserInteractionEnabled = false
        aveEleField.backgroundColor = .lightGray
        aveEleField.isUserInteractionEnabled = false
        cityField.backgroundColor = .lightGray
        cityField.isUserInteractionEnabled = false
        countryField.backgroundColor = .lightGray
        countryField.isUserInteractionEnabled = false
        activityTypeField.backgroundColor = .lightGray
        activityTypeField.isUserInteractionEnabled = false
        
    }
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @IBAction func saveButton(_ sender: UIButton) {
    }
    func drawpolygon(){
        let coordinates = graphSave.getCoordinates()
        let polyLine = MKPolyline(coordinates: coordinates, count: coordinates.count)
        var spanLat = abs(coordinates[coordinates.count-1].latitude - coordinates[0].latitude)
        var spanLon = abs(coordinates[coordinates.count-1].longitude - coordinates[0].longitude)
        let startNode = graphSave.getNodes()[3]
        
        startNode.title = "Start"
        startNode.pinImage = #imageLiteral(resourceName: "start")
        let finishNode = graphSave.getNodes().last
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
        pathMap.setRegion(region, animated: true)
        pathMap.addOverlay(polyLine)
        pathMap.addAnnotations(graphSave.nodeList)
    }
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
    
}
