//
//  LocationTableViewCell.swift
//  SocialPhotos
//
//  Created by Blake Lockley on 16/02/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationTableViewCell: UITableViewCell {

  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var notes: UILabel!

  func configureCellWith(location: SavedLocation) {
    self.name.text = location.name
    if let notes = location.notes {
      self.notes.text = notes
    } else {
      self.notes.text = "(no notes for this location)"
    }

    mapView.isScrollEnabled = false
    mapView.isZoomEnabled = false
    mapView.centerCoordinate = location.coordinate
    mapView.camera.altitude = 1000
  }

}
