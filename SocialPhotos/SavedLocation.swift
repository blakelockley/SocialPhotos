//
//  SavedLocation.swift
//  SocialPhotos
//
//  Created by Blake Lockley on 15/02/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import Foundation
import CoreLocation

class SavedLocation: Equatable, Hashable {
  let name: String
  let coordinate: CLLocationCoordinate2D
  let notes: String?

  init(name: String, location: CLLocationCoordinate2D, notes: String?) {
    self.name = name
    self.coordinate = location
    self.notes = notes
  }

  convenience init(name: String, lat: Double, lng: Double, notes: String?) {
    self.init(name: name,
              location: CLLocationCoordinate2D(latitude: lat, longitude: lng),
              notes: notes)
  }

  //imutable objects for more thread safety (not important in this case though)
  func update(notes: String) -> SavedLocation {
    return SavedLocation(name: name, location: coordinate, notes: notes)
  }

  func distanceTo(_ other: CLLocationCoordinate2D) -> CLLocationDistance {
    let a = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    let b = CLLocation(latitude: other.latitude, longitude: other.longitude)

    return a.distance(from: b)
  }

  //MARK: Hashable
  var hashValue: Int {
    return name.hash &+ coordinate.longitude.hashValue &+ coordinate.latitude.hashValue
  }
}

//MARK: Equatable
func ==(lhs: SavedLocation, rhs: SavedLocation) -> Bool {
  return lhs.name == rhs.name
    && lhs.coordinate.latitude == rhs.coordinate.latitude
  	&& lhs.coordinate.longitude == rhs.coordinate.longitude
}
