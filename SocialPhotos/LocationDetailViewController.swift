//
//  LocationDetailViewController.swift
//  SocialPhotos
//
//  Created by Blake Lockley on 16/02/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationDetailViewController: UIViewController, UITextViewDelegate {

  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!

  var savedLocation: SavedLocation!

  //MARK: Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()

    guard savedLocation != nil else {
      fatalError("\(#function) called with no savedLocation member provided.")
    }

    title = savedLocation.name
    mapView.isScrollEnabled = false
    mapView.isZoomEnabled = false
    mapView.centerCoordinate = savedLocation.coordinate
    mapView.camera.altitude = 1000
    textView.text = savedLocation.notes
    textView.delegate = self

    //ui adjustments (nicer in code than KVC in storyboard)
    mapView.layer.cornerRadius = 5
    textView.layer.borderColor = UIColor.lightGray.cgColor
    textView.layer.borderWidth = 1
    textView.layer.cornerRadius = 5

    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
    let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pressedDone))
    toolbar.items = [flexible, done]

    textView.inputAccessoryView = toolbar

    NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: .UIKeyboardWillHide, object: nil)
  }

  //MARK: Methods
  func keyboardDidShow(notification: NSNotification) {
    let info = notification.userInfo!
    let value = info[UIKeyboardFrameEndUserInfoKey] as AnyObject
    let frame = value.cgRectValue!
    let keyboardFrame = view.convert(frame, from: nil)
    let keyboardHeight = keyboardFrame.height

    textViewBottomConstraint.constant = keyboardHeight + 20
    updateViewConstraints()
  }

  func keyboardDidHide(notification: NSNotification) {
    textViewBottomConstraint.constant = 20
    updateViewConstraints()
  }

  func pressedDone() {
    textView.resignFirstResponder()
  }

  //MARK: UITextViewDelegate
  func textViewDidEndEditing(_ textView: UITextView) {
    savedLocation = savedLocation.update(notes: textView.text)
    SavedLocationManager.sharedManager.update(location: savedLocation)
    try! SavedLocationManager.sharedManager.saveChanges()
  }
}
