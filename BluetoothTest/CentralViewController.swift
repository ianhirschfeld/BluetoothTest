//
//  CentralViewController.swift
//  BluetoothTest
//
//  Created by Ian Hirschfeld on 10/23/14.
//  Copyright (c) 2014 Ian Hirschfeld. All rights reserved.
//

import UIKit
import CoreBluetooth

class CentralViewController: UIViewController, BTConnectionDelegate {

  @IBOutlet var lblName: UILabel!
  @IBOutlet var lblPlayerName: UILabel!
  @IBOutlet var tvPlayerBio: UITextView!

  var btcm: BTCentralManager!
  var connection: BTConnection!

  override func viewDidLoad() {
    super.viewDidLoad()

    connection.delegate = self

    lblName.text = connection.name
    connection.subscribeAll()
  }

  func didDiscoverServices() {}

  func didSubscribe() {
    println("Subscribed!")
  }

  func didUnsubscribe() {
    println("Unsubscribed!")
  }

  func didUpdateValue(characteristic: CBCharacteristic) {
    let value = NSString(data: characteristic.value, encoding: NSUTF8StringEncoding)

    if characteristic.UUID == characteristciPlayerNameUUID {
      lblPlayerName.text = value
    } else if characteristic.UUID == characteristciPlayerBioUUID {
      tvPlayerBio.text = value
    }
  }

}
