//
//  PeripheralViewController.swift
//  BluetoothTest
//
//  Created by Ian Hirschfeld on 10/23/14.
//  Copyright (c) 2014 Ian Hirschfeld. All rights reserved.
//

import UIKit
import CoreBluetooth

class PeripheralViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

  var btpm: BTPeripheralManager!

  @IBOutlet var tfName: UITextField!
  @IBOutlet var tvBio: UITextView!

  override func viewDidLoad() {
    super.viewDidLoad()

//    if let name = (btManager.services[0].characteristics[0] as CBCharacteristic).value {
//      tfName.text = NSString(data: name, encoding: NSUTF8StringEncoding)
//    }
//
//    if let bio = (btManager.services[0].characteristics[1] as CBCharacteristic).value {
//      tvBio.text = NSString(data: bio, encoding: NSUTF8StringEncoding)
//    }

    let tapGesture = UITapGestureRecognizer(target: self, action: "closeKeyboard")
    view.addGestureRecognizer(tapGesture)
  }

  @IBAction func updatePress(sender: UIButton) {
//    var nameData: NSData = tfName.text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
//    var didSendName: Bool = btManager.peripheralManager.updateValue(nameData, forCharacteristic: btManager.services[0].characteristics[0] as CBMutableCharacteristic, onSubscribedCentrals: nil)
//    if didSendName {
//      (parentViewController as? ViewController)?.log("Name updated and sent.")
//    }
//
//    var bioData: NSData = tvBio.text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
//    var didSendBio: Bool = btManager.peripheralManager.updateValue(bioData, forCharacteristic: btManager.services[0].characteristics[2] as CBMutableCharacteristic, onSubscribedCentrals: nil)
//    if didSendBio {
//      (parentViewController as? ViewController)?.log("Bio updated and sent.")
//    }
  }

  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    closeKeyboard()
  }

  func closeKeyboard() {
    view.endEditing(true)
  }

}
