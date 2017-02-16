//
//  SavedLocationTests.swift
//  SocialPhotos
//
//  Created by Blake Lockley on 16/02/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import XCTest
import CoreLocation
@testable import SocialPhotos

class SavedLocationTests: XCTestCase {

  func testInit() {
    let loc1 = SavedLocation(name: "test", lat: 0.0, lng: 2.5, notes: nil)
    XCTAssertEqual(loc1.name, "test")
    XCTAssertEqual(loc1.coordinate.latitude, 0.0)
    XCTAssertEqual(loc1.coordinate.longitude, 2.5)
    XCTAssertEqual(loc1.notes, nil)

    let coord = CLLocationCoordinate2D(latitude: -10.0, longitude: -90.0)
    let loc2 = SavedLocation(name: "test", location: coord, notes: "foo")
    XCTAssertEqual(loc2.coordinate.latitude, coord.latitude)
    XCTAssertEqual(loc2.coordinate.longitude, coord.longitude)
    XCTAssertEqual(loc2.notes, "foo")
  }

  func testUpdate() {
    let loc1 = SavedLocation(name: "test", lat: 0.0, lng: 0.0, notes: nil)
    let loc2 = loc1.update(notes: "foo")

    XCTAssertEqual(loc1.notes, nil)
    XCTAssertEqual(loc2.notes, "foo")
  }

  func testDistanceTo() {
    var distance1, distance2: Double

    //equal distances
    let loc1 = SavedLocation(name: "test1", lat: 0.0, lng: 0.0, notes: nil)
    distance1 = loc1.distanceTo(sydneyCBDLocation.coordinate)
    distance2 = CLLocation(latitude: loc1.coordinate.latitude, longitude: loc1.coordinate.longitude).distance(from: sydneyCBDLocation)
    XCTAssertEqual(distance1, distance2)

    let loc2 = SavedLocation(name: "test2", lat: 90.0, lng: 90.0, notes: nil)
    distance2 = loc2.distanceTo(sydneyCBDLocation.coordinate)
    XCTAssertNotEqual(distance1, distance2)
  }

  func testEquatable() {
    let loc1 = SavedLocation(name: "", lat: 0.0, lng: 0.0, notes: nil)
    XCTAssertEqual(loc1, loc1)

    //SavedLocations with different notes should still be considered equal
    let loc2 = loc1.update(notes: "foo")
    XCTAssertEqual(loc1, loc2)
  }

}
