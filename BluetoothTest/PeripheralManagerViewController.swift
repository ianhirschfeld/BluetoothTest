//
//  PeripheralManagerViewController.swift
//  BluetoothTest
//
//  Created by Ian Hirschfeld on 10/24/14.
//  Copyright (c) 2014 Ian Hirschfeld. All rights reserved.
//

import UIKit
import CoreBluetooth

class PeripheralManagerViewController: UIViewController, BTPeripheralDelegate {

  @IBOutlet var btnAdvertise: UIButton!

  var btpm: BTPeripheralManager!

  override func viewDidLoad() {
    super.viewDidLoad()
    btpm = BTPeripheralManager(delegate: self)
    btpm.serviceUUID = servicePlayerUUID
    btpm.characteristicUUIDs = [characteristciPlayerNameUUID, characteristciPlayerBioUUID]
  }

  @IBAction func btnAdvertisePress(sender: UIButton) {
    if btpm.isAdvertising {
      btpm.stopAdvertising()
      btnAdvertise.setTitle("Advertise", forState: UIControlState.Normal)
    } else {
      btpm.startAdvertising()
      btnAdvertise.setTitle("Stop Advertising", forState: UIControlState.Normal)
    }
  }

  func didSubscribe() {
    performSegueWithIdentifier("peripheralSegue", sender: nil)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "peripheralSegue" {
      let nextViewController = segue.destinationViewController as PeripheralViewController
      nextViewController.btpm = btpm
    }
  }

}
