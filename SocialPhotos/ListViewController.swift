//
//  ListViewController.swift
//  SocialPhotos
//
//  Created by Blake Lockley on 16/02/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import Foundation
import UIKit

//Obviously, this technique is more effective with multiple segues and cells identifiers.
fileprivate enum Segue: String {
  case show
}

fileprivate enum Cell: String {
  case cell
}

class ListViewController: UITableViewController {

  var locations: [SavedLocation]!
  private var selectedLocation: SavedLocation!

  //MARK: Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    locations = SavedLocationManager.sharedManager.locationsByClosenessTo(sydneyCBDLocation)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    locations = SavedLocationManager.sharedManager.locationsByClosenessTo(sydneyCBDLocation)
    tableView.reloadData()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? LocationDetailViewController {
      vc.savedLocation = selectedLocation
    }
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return SavedLocationManager.sharedManager.locations.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Cell.cell.rawValue) as! LocationTableViewCell
    cell.configureCellWith(location: locations[indexPath.row])
    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedLocation = locations[indexPath.row]
    performSegue(withIdentifier: Segue.show.rawValue, sender: nil)
  }
}
