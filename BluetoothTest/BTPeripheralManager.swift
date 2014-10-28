//
//  BTPeripheralManager.swift
//  BluetoothTest
//
//  Created by Ian Hirschfeld on 10/24/14.
//  Copyright (c) 2014 Ian Hirschfeld. All rights reserved.
//

import UIKit
import CoreBluetooth

class BTPeripheralManager: NSObject, CBPeripheralManagerDelegate {

  // Properties
  var characteristicUUIDs = [CBUUID]()
  var characteristics = [CBMutableCharacteristic]()

  var delegate: BTPeripheralDelegate!
  var manager: CBPeripheralManager!
  var serviceUUID: CBUUID!
  var service: CBMutableService!

  var isAdvertising: Bool {
    return manager.isAdvertising
  }

  // Initialzer
  init(delegate: BTPeripheralDelegate) {
    super.init()

    self.delegate = delegate
    self.manager = CBPeripheralManager(delegate: self, queue: nil)
  }

  func enableService() {
    if service != nil {
      manager.removeService(service)
    }

    service = CBMutableService(type: serviceUUID, primary: true)

    for UUID in characteristicUUIDs {
      var characteristic = CBMutableCharacteristic(type: UUID, properties: CBCharacteristicProperties.Notify, value: nil, permissions: nil)
      characteristics.append(characteristic)
    }
    service.characteristics = characteristics

    manager.addService(service)
  }

  func disableService() {
    if service != nil {
      manager.removeService(service)
      service = nil
    }
    stopAdvertising()
  }

  func startAdvertising() {
    if manager.isAdvertising {
      stopAdvertising()
    }

    let advertisement = [
      CBAdvertisementDataServiceUUIDsKey: [service.UUID],
      CBAdvertisementDataLocalNameKey: UIDevice.currentDevice().name
    ]

    manager.startAdvertising(advertisement)
  }

  func stopAdvertising() {
    manager.stopAdvertising()
  }

  // ==================================================
  // PERIPHERAL MANAGER DELEGATE
  // ==================================================
  func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
    switch peripheral.state {
    case CBPeripheralManagerState.PoweredOn:
      println("peripheralManagerDidUpdateState: PoweredOn")
      enableService()

    case CBPeripheralManagerState.PoweredOff:
      println("peripheralManagerDidUpdateState: PoweredOff")
      disableService()

    default:
      println("peripheralManagerDidUpdateState: \(peripheral.state)")
    }
  }

  func peripheralManager(peripheral: CBPeripheralManager!, didAddService service: CBService!, error: NSError!) {
    println("Service added w/ \(service.characteristics.count) characteristics")
  }

  func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager!, error: NSError!) {
    if error != nil {
      println("Advertising error: \(error.localizedDescription)")
      return
    }

    println("Started advertising")
  }

  func peripheralManager(peripheral: CBPeripheralManager!, central: CBCentral!, didSubscribeToCharacteristic characteristic: CBCharacteristic!) {
    println("Central has subscribed to: \(characteristic.UUID)")
    delegate.didSubscribe()
  }

}
