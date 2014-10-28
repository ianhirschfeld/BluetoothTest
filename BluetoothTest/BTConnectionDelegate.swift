//
//  BTConnectionDelegate.swift
//  BluetoothTest
//
//  Created by Ian Hirschfeld on 10/27/14.
//  Copyright (c) 2014 Ian Hirschfeld. All rights reserved.
//

import CoreBluetooth

protocol BTConnectionDelegate {

  func didDiscoverServices()
  func didSubscribe()
  func didUnsubscribe()
  func didUpdateValue(characteristic: CBCharacteristic)

}
