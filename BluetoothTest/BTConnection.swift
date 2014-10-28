//
//  BTConnection.swift
//  BluetoothTest
//
//  Created by Ian Hirschfeld on 10/24/14.
//  Copyright (c) 2014 Ian Hirschfeld. All rights reserved.
//

import CoreBluetooth

class BTConnection: NSObject, CBPeripheralDelegate {

  // Properties
  var serviceUUIDs = [CBUUID]()
  var characteristicUUIDs = [CBUUID]()
  var services = [CBService]()
  var subscribeWhenReady = false
  var isConnected = false
  var isSubscribed = false

  var peripheral: CBPeripheral!
  var name: String!
  var delegate: BTConnectionDelegate!

  init(peripheral: CBPeripheral, name: String? = nil, delegate: BTConnectionDelegate? = nil) {
    super.init()

    self.peripheral = peripheral
    self.peripheral.delegate = self

    if name != nil {
      self.name = name!
    }

    if delegate != nil {
      self.delegate = delegate!
    }
  }

  func discoverServices() {
    println("discoverServices")
    peripheral.discoverServices(serviceUUIDs)
  }

  func discoverCharacteristics(service: CBService) {
    println("discoverCharacteristics")
    peripheral.discoverCharacteristics(characteristicUUIDs, forService: service)
  }

  func subscribeAll() {
    for service in services {
      subscribe(service)
    }
  }

  func subscribe(service: CBService) {
    if service.characteristics == nil || service.characteristics.count < 1 {
      subscribeWhenReady = true
      discoverCharacteristics(service)
    } else {
      println("Subscribing to \(service.UUID)")
      subscribeWhenReady = false
      for characteristic in service.characteristics {
        peripheral.setNotifyValue(true, forCharacteristic: characteristic as CBCharacteristic)
        delegate.didSubscribe()
      }
    }
  }

  func unsubscribeAll() {
    for service in services {
      unsubscribe(service)
    }
  }

  func unsubscribe(service: CBService) {
    println("Unsubscribing from \(service.UUID)")
    for characteristic in service.characteristics {
      peripheral.setNotifyValue(false, forCharacteristic: characteristic as CBCharacteristic)
      delegate.didUnsubscribe()
    }
  }

  // ==================================================
  // PERIPHERAL DELEGATE
  // ==================================================
  func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
    if error != nil {
      println("didDiscoverServices error: \(error.localizedDescription)")
      return
    }

    println("didDiscoverServices: \(peripheral.services.count)")
    for s in peripheral.services {
      let service: CBService = s as CBService
      if find(services, service) == nil {
        println("  service: \(service.UUID)")
        services.append(service)
      }
    }
    delegate.didDiscoverServices()
  }

  func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
    if error != nil {
      println("didDiscoverCharacteristicsForService error: \(service.UUID) - \(error.debugDescription) - \(error.code)")
      return
    }

    println("didDiscoverCharacteristicsForService: \(service.characteristics.count)")
    if subscribeWhenReady {
      subscribe(service)
    }
  }

}
