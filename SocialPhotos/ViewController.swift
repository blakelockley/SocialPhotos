//
//  ViewController.swift
//  SocialPhotos
//
//  Created by Blake Lockley on 15/02/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import UIKit
import MapKit

//prevents typos in string literals
fileprivate enum Segue: String {
  case detail
}

class ViewController: UIViewController, MKMapViewDelegate {

  //MARK: IBOutlets
  @IBOutlet weak var mapView: MKMapView!

  //MARK: Members
  private var locations: [SavedLocation]!
  private var selectedLocation: SavedLocation!

  //MARK: Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()

    mapView.delegate = self

    let radius: Double = 20000.0
    let region = MKCoordinateRegionMakeWithDistance(sydneyCBDLocation.coordinate, radius, radius)
    mapView.region = region

    locations = SavedLocationManager.sharedManager.locationsByClosenessTo(sydneyCBDLocation)

    for loc in locations {
      let annotation = LocationAnnotation()
      annotation.title = loc.name
      annotation.coordinate = loc.coordinate
      annotation.savedLocation = loc
      mapView.addAnnotation(annotation)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? LocationDetailViewController {
      vc.savedLocation = selectedLocation
    }
  }

  //MARK: IBActions
  @IBAction func pressedAddButton(_ sender: Any) {
    createNewLocation()
  }

  //MARK: Methods
  private func createNewLocation() {
    let inputBox = UIAlertController(title: "New Location", message: "Add the current centre of the map as a new location on the map.", preferredStyle: .alert)

    var textfield: UITextField!

    inputBox.addTextField(configurationHandler: { tf in
      tf.placeholder = "Name"
      textfield = tf //save reference outside of closure so we can change the placeholder elsewhere, slightly more convinent than using inputBox.textFields!.first!
    })

    inputBox.addAction(UIAlertAction(title: "Add", style: .default) { action in

      if (textfield.text!.isEmpty) {
        //incase no name is provided we don't want to add an empty pin so we redisplay the box with a new message
        inputBox.message = "Please include a name for the new location."
        self.present(inputBox, animated: true, completion: nil)
      }

      let loc = SavedLocation(name: textfield.text!,
                              lat: self.mapView.centerCoordinate.latitude,
                              lng: self.mapView.centerCoordinate.longitude,
                              notes: nil)

      let annotation = LocationAnnotation()
      annotation.title = loc.name
      annotation.coordinate = loc.coordinate
      annotation.savedLocation = loc
      self.mapView.addAnnotation(annotation)

      SavedLocationManager.sharedManager.update(location: loc)
      do {
        try SavedLocationManager.sharedManager.saveChanges()
      } catch {
        print(error)
      }
    })

    inputBox.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    present(inputBox, animated: true, completion: nil)
  }

  //MARK: MKMapViewDelegate
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    selectedLocation = (view.annotation as! LocationAnnotation).savedLocation
    performSegue(withIdentifier: Segue.detail.rawValue, sender: nil)
  }
}
