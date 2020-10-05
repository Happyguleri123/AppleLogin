//
//  GoogleMapVC.swift
//  AppleLogin
//
//  Created by Vivek Dharmani on 9/17/20.
//  Copyright © 2020 Vivek Dharmani. All rights reserved.
//

import UIKit
import GoogleMaps


class GoogleMapVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
               // Do any additional setup after loading the view.
               // Create a GMSCameraPosition that tells the map to display the
               // coordinate -33.86,151.20 at zoom level 6.
               let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
               let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
               self.view.addSubview(mapView)

               // Creates a marker in the center of the map.
               let marker = GMSMarker()
               marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
               marker.title = "Sydney"
               marker.snippet = "Australia"
               marker.map = mapView

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
