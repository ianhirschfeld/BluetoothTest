//
//  CentralManagerViewController.swift
//  BluetoothTest
//
//  Created by Ian Hirschfeld on 10/24/14.
//  Copyright (c) 2014 Ian Hirschfeld. All rights reserved.
//

import UIKit
import CoreBluetooth

class CentralManagerViewController: UIViewController, BTCentralDelegate, BTConnectionDelegate, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet var tblView: UITableView!
  @IBOutlet var btnScan: UIButton!
  @IBOutlet var btnConnect: UIButton!

  var btcm: BTCentralManager!

  override func viewDidLoad() {
    super.viewDidLoad()

    tblView.dataSource = self
    tblView.delegate = self

    btcm = BTCentralManager(delegate: self)
    btcm.serviceUUIDs = [servicePlayerUUID]
  }

  @IBAction func btnScanPress(sender: UIButton) {
    if btcm.isScanning {
      btcm.stopScanning()
      btnScan.setTitle("Scan", forState: UIControlState.Normal)
    } else {
      btcm.startScanning()
      btnScan.setTitle("Stop Scanning", forState: UIControlState.Normal)
    }
  }

  @IBAction func btnConnect(sender: UIButton) {
    if btcm.hasConnections {
      btcm.disconnect()
      btnConnect.setTitle("Connect", forState: UIControlState.Normal)
    } else {
      btcm.connect()
      btnConnect.setTitle("Disconnect", forState: UIControlState.Normal)
    }
  }

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return btcm.connections.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("centralCell", forIndexPath: indexPath) as UITableViewCell

    var lbl: UILabel = cell.viewWithTag(10) as UILabel
    lbl.text = btcm.connections[indexPath.row].name

    return cell
  }

  func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    var peripheral = btcm.connections[indexPath.row].peripheral
  }

  func didDiscoverConnection(connecyion: BTConnection) {
    tblView.reloadData()
  }

  func didConnectConnection(connection: BTConnection) {
    connection.delegate = self
    connection.serviceUUIDs = btcm.serviceUUIDs
    connection.characteristicUUIDs = [characteristciPlayerNameUUID, characteristciPlayerBioUUID]
    connection.discoverServices()
  }

  func didDiscoverServices() {
    if btcm.connections.count == 1 {
      btcm.stopScanning()
      btnScan.setTitle("Scan", forState: UIControlState.Normal)
      performSegueWithIdentifier("centralSegue", sender: btcm.connections[0])
    }
  }

  func didSubscribe() {}
  func didUnsubscribe() {}
  func didUpdateValue(characteristic: CBCharacteristic) {}

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "centralSegue" {
      let nextViewController = segue.destinationViewController as CentralViewController
      nextViewController.btcm = btcm
      nextViewController.connection = sender as? BTConnection
    }
  }

}
