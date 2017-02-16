//
//  SavedLocationManager.swift
//  SocialPhotos
//
//  Created by Blake Lockley on 15/02/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import Foundation
import CoreLocation

enum SavedLocationManagerError: Error {
  case FailedJSONLookup
}

fileprivate let filename = "locations"
fileprivate let filetype = "json"

class SavedLocationManager {

  //Singleton instance
  static let sharedManager = SavedLocationManager()

  private var path: String!
  private(set) var locations: Set<SavedLocation>!

  //MARK: Init Methods
  private init(filename: String, filetype: String) {
    let fm = FileManager.default
    let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    let assetPath = Bundle.main.path(forResource: filename, ofType: filetype)!
    path = NSString(string: documents).appendingPathComponent("locations.json") as String

    if !fm.fileExists(atPath: path) {
      try! fm.copyItem(atPath: assetPath, toPath: path)
    }
  }

  private convenience init() {
    self.init(filename: filename, filetype: filetype)
    do {
      locations = Set(try loadLocations())
    } catch {
      fatalError("Could not load locations.")
    }
  }

  //MARK: Public Methods
  ///Make changes to existing location of add new location
  func update(location: SavedLocation) {
    locations.remove(location)
    locations.insert(location)
  }

  func saveChanges() throws {
    try save(locations: locations)
  }

  func locationsByClosenessTo(_ other: CLLocation) -> [SavedLocation] {
    return locations.sorted { (a, b) in
      a.distanceTo(other.coordinate) < b.distanceTo(other.coordinate)
    }
  }

  //MARK: Private Methods
  private func loadLocations() throws -> [SavedLocation] {
    let json = try loadJson() as! [String: Any]
    let locations = json["locations"] as! [[String: Any]]

    return try locations.map { entry in
      guard
        let name = entry["name"] as? String,
        let lat = entry["lat"] as? Double,
        let lng = entry["lng"] as? Double
        else { throw  SavedLocationManagerError.FailedJSONLookup }

      //in the original locations.json 'description' is not a field so the lack of an entry is valid
      let notes = entry["notes"] as? String

      return SavedLocation(name: name, lat: lat, lng: lng, notes: notes)
    }
  }

  private func loadJson() throws -> Any {
    let jsonData = try String(contentsOfFile: path).data(using: .utf8)!
    return try JSONSerialization.jsonObject(with: jsonData, options: [])
  }

  private func save(locations: Set<SavedLocation>) throws {
    let locationsArray: [[String: Any]] = locations.map { loc in
      var item = [String: Any]()
      item["name"] = loc.name
      item["lat"] = loc.coordinate.latitude as Double
      item["lng"] = loc.coordinate.longitude as Double
      item["notes"] = loc.notes
      return item
    }

    let dict: [String: Any] = ["locations": locationsArray,
                               "updated": generateTimeStamp()]
    try save(json: dict)
  }

  private func save(json: Any) throws {
    let os = OutputStream(toFileAtPath: path, append: false)!

    os.open()
    JSONSerialization.writeJSONObject(json, to: os, options: .prettyPrinted, error: nil)
    os.close()
  }

  private func generateTimeStamp() -> String {
    //example: "2016-12-01T06:52:08Z"
    //Z suffix for zulu as in UTC time

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

    let now = Date()
    return dateFormatter.string(from: now)
  }
}
