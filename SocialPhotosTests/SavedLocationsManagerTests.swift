//
//  SavedLocationsManagerTests.swift
//  SocialPhotos
//
//  Created by Blake Lockley on 16/02/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import XCTest
import CoreLocation
@testable import SocialPhotos

class SavedLocationManagerTests: XCTestCase {
  let slm = SavedLocationManager.sharedManager //reference
  let fm = FileManager.default
  let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
  let assetPath = Bundle.main.path(forResource: "locations", ofType: "json")!
  var path: String!

  override func setUp() {
    //create test.json file
    path =  NSString(string: documents).appendingPathComponent("test.json") as String
    try! fm.copyItem(atPath: assetPath, toPath: path)
  }

  override func tearDown() {
    //remove test.json file
    try! fm.removeItem(atPath: path)
  }

  func testUpdate() {
    var oldCount, newCount: Int

    //calling update with a new savedlocation should increment the count
    oldCount = slm.locations.count
    let loc1 = SavedLocation(name: "test", lat: 0.0, lng: 0.0, notes: nil)
    slm.update(location: loc1)

    newCount = slm.locations.count
    XCTAssertGreaterThan(newCount, oldCount)

    //calling update with an existing savedLocation should not change the count
    oldCount = slm.locations.count
    let loc2 = loc1.update(notes: "foo")
    slm.update(location: loc2)

    newCount = slm.locations.count
    XCTAssertEqual(oldCount, newCount)
  }

  func testClosenessSorting() {
    var distance1, distance2: Double
    let locations = slm.locationsByClosenessTo(sydneyCBDLocation)

    distance1 = locations.first!.distanceTo(sydneyCBDLocation.coordinate)
    distance2 = locations.last!.distanceTo(sydneyCBDLocation.coordinate)

    XCTAssertLessThan(distance1, distance2)
  }
  
}
