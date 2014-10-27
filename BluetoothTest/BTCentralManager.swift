//
//  BTCentralManager.swift
//  BluetoothTest
//
//  Created by Ian Hirschfeld on 10/24/14.
//  Copyright (c) 2014 Ian Hirschfeld. All rights reserved.
//

import Foundation
import CoreBluetooth

class BTCentralManager: NSObject, CBCentralManagerDelegate {

  // Properties
  var serviceUUIDs = [CBUUID]()
  var connections = [BTConnection]()
  var scanWhenReady = false
  var isScanning = false

  var hasConnections: Bool {
    return connections.filter { $0.isConnected }.count > 0
  }

  var delegate: BTCentralDelegate!
  var manager: CBCentralManager!

  // Initializer
  init(delegate: BTCentralDelegate) {
    super.init()

    self.delegate = delegate
    self.manager = CBCentralManager(delegate: self, queue: nil)
  }

  func startScanning() {
    if manager.state != CBCentralManagerState.PoweredOn {
      scanWhenReady = true
      return
    }

    println("Scanning...")
    manager.scanForPeripheralsWithServices(serviceUUIDs, options: nil)
    isScanning = true
    scanWhenReady = false
  }

  func stopScanning() {
    println("Ending scan")
    manager.stopScan()
    isScanning = false
  }

  func connect() {
    println("Connecting...")
    for connection in connections {
      let peripheral = connection.peripheral
      manager.connectPeripheral(peripheral, options: nil)
    }
  }

  func disconnect() {
    println("Disconnecting...")
    for connection in connections {
      manager.cancelPeripheralConnection(connection.peripheral)
    }
  }

  // ==================================================
  // CENTRAL MANAGER DELEGATE
  // ==================================================
  func centralManagerDidUpdateState(central: CBCentralManager!) {
    switch central.state {
    case CBCentralManagerState.PoweredOn:
      println("centralManagerDidUpdateState: PoweredOn")
      if scanWhenReady {
        startScanning()
      }

    default:
      println("centralManagerDidUpdateState: \(central.state)")
    }
  }

  func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
    var name: String!
    if let localName: NSString? = advertisementData[CBAdvertisementDataLocalNameKey] as? NSString {
      name = localName
    } else {
      name = peripheral.name
    }

    if name != nil {
      let connection = BTConnection(peripheral: peripheral, name: name)
      println("Found a peripheral: \(name)")
      connections.append(connection)
      delegate.didDiscoverConnection(connection)
    }
  }

  func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
    let connection = connections.filter { $0.peripheral == peripheral }[0]
    println("didConnect: \(connection.name)")
    connection.isConnected = true
    delegate.didConnectConnection(connection)
  }

}
