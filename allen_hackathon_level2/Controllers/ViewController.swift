//
//  ViewController.swift
//  allen_hackathon_level2
//
//  Created by 권승용 on 2022/10/05.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController {
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    @IBOutlet weak var grantLocationPermissionButton: UIButton!
    
    @IBOutlet weak var searchLocationButton: UIButton!
    
    @IBOutlet weak var locationMapView: MKMapView!
    
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.requestWhenInUseAuthorization()
    }

    @IBAction func grantLocationButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func searchLocationButtonTapped(_ sender: Any) {
    }
    
}

