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

    if let name = btpm.characteristics[0].value {
      tfName.text = NSString(data: name, encoding: NSUTF8StringEncoding)
    }

    if let bio = btpm.characteristics[1].value {
      tvBio.text = NSString(data: bio, encoding: NSUTF8StringEncoding)
    }

    let tapGesture = UITapGestureRecognizer(target: self, action: "closeKeyboard")
    view.addGestureRecognizer(tapGesture)
  }

  @IBAction func updatePress(sender: UIButton) {
    let nameData: NSData = tfName.text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    btpm.sendData(btpm.characteristics[0], data: nameData)

    let bioData: NSData = tvBio.text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    btpm.sendData(btpm.characteristics[1], data: bioData)
  }

  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    closeKeyboard()
  }

  func closeKeyboard() {
    view.endEditing(true)
  }

}
