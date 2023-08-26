//
//  ViewController.swift
//  Project16
//
//  Created by Prarthana Das on 26/08/23.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
  

    

    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        let kolkata = Capital(title: "Kolkata", coordinate: CLLocationCoordinate2D(latitude: 22.5726, longitude: 88.3639), info: "The City of Joy")
        
        mapView.addAnnotations([london, rome, oslo, paris, washington, kolkata])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change Map View", style: .plain, target: self, action: #selector(changeMapType))

    }
    
    @objc func changeMapType() {
        let ac = UIAlertController(title: "Map Type", message: "Please enter a map type", preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default){ [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }

    func submit(_ answer: String){
        if(answer.lowercased() == "satellite"){
            mapView.mapType = .satellite
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else {return nil}
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.tintColor = .cyan
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
            
        
            
        } else {
            annotationView?.tintColor = .cyan
            annotationView?.annotation = annotation
        }
        
        return annotationView
        
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else {return}
        let placeName = capital.title
        let placeInfo = capital.info
        
        if let dvc = storyboard?.instantiateViewController(identifier: "webContent") as? DetailViewController{
            navigationController?.pushViewController(dvc, animated: true)
        }
        
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "Okay", style: .default))
//        present(ac, animated: true)
    }

}

