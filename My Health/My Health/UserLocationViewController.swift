//
//  UserLocationViewController.swift
//  My Health
//
//  Created by Ron Mauldin on 11/16/14.
//  Copyright (c) 2014 maulr. All rights reserved.
//
import UIKit
import Foundation
import CoreLocation

class UserLocationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var streetLbl: UILabel!
    @IBOutlet weak var houseNumberLbl: UILabel!
    
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var zipCodeLbl: UILabel!

    let locationManager = CLLocationManager()

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations:
        [AnyObject]!) {
            CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in

                if (error != nil) {
                    println("Reverse geocoder failed \(error.localizedDescription)")

                    return
                }

                if placemarks.count > 0 {
                    println("what is the count? \(placemarks.count)")
                    let pm = placemarks[0] as CLPlacemark
                    self.displayLocationInfo(pm)
                } else {
                    println("Problem with info from geocoder")
 //                   println(“Problem with the data received from geocoder”)
                }
            })
    }

    func displayLocationInfo(placemark: CLPlacemark!) {
        if placemark != nil {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            self.houseNumberLbl.text = ("\(placemark.subThoroughfare)")
            println(placemark.subThoroughfare)
            self.streetLbl.text = ("\(placemark.thoroughfare)")
            println(placemark.thoroughfare)
            self.cityLbl.text = ("\(placemark.locality)")
            println(placemark.locality)
            self.zipCodeLbl.text = ("\(placemark.postalCode)")
            println(placemark.postalCode)
            self.stateLbl.text = ("\(placemark.administrativeArea)")
            println(placemark.administrativeArea)
            println(placemark.country)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func myLocation(sender: AnyObject) {
        println("Button pressed for location")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

    }

    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    




    }