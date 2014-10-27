//
//  BTCentralDelegate.swift
//  BluetoothTest
//
//  Created by Ian Hirschfeld on 10/24/14.
//  Copyright (c) 2014 Ian Hirschfeld. All rights reserved.
//

import CoreBluetooth

protocol BTCentralDelegate {

  func didDiscoverConnection(connection: BTConnection)
  func didConnectConnection(connection: BTConnection)

}
