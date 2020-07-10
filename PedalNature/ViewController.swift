//
//  ViewController.swift
//  PedalNature
//
//  Created by Volkan Sahin on 4.03.2020.
//  Copyright © 2020 Volkan Sahin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Foundation

class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    let graph = PathGraph(nodeList: [], edgeList: [])
    let locationManager = CLLocationManager()
    var location = LocationNode(latitude: 0, longitude: 0, image: UIImage(), coordinate: CLLocationCoordinate2D(), starttime: CFAbsoluteTime(), altitude: 0, pinImage: UIImage(), locationval: CLLocation())
    var takenImage = UIImage()
    var startLocationFlag = 0
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //Unable update location on background
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        if startLocationFlag == 1{
            startLocation()
        }
    }
    //Location Data Create
    func locationManager(_ manager : CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let locValue : CLLocationCoordinate2D = manager.location?.coordinate else{ return }
        guard let altitude = manager.location?.altitude else{ return }
        guard let locationValue : CLLocation = manager.location else { return }
        let time = CFAbsoluteTimeGetCurrent()
        location = LocationNode(latitude: locValue.latitude, longitude: locValue.longitude, image: UIImage(),coordinate: locValue, starttime: time, altitude : altitude, pinImage: UIImage(),locationval: locationValue)
        // Create nodes for every location data
        graph.addNode(Node: location)
        //Show user location on map
        showMap(location: locValue)
    }
    //User Location Display on Map
    func showMap(location : CLLocationCoordinate2D){
        let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
    }
    //Start location update button
    func startLocation() {
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    //Stop location update button
    @IBAction func stopLocation(_ sender: UIButton) {
        locationManager.stopUpdatingLocation()
        graph.createEdge()
    }
    //Take picture button
    @IBAction func takePicture(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    //Image taking function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let takenImage = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        UIImageWriteToSavedPhotosAlbum(takenImage, nil, nil, nil)
        location.pinImage = #imageLiteral(resourceName: "photoCapture")
        location.image = takenImage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDrawScreen" {
            if let destinationVC = segue.destination as? DrawScreen {
                destinationVC.graphDraw = graph
            }
        }
    }
}
