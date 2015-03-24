//
//  SwiftViewController.swift
//  KioskScanner
//
//  Created by Kenny Pham on 3/17/15.
//  Copyright (c) 2015 InfinitePeripherals. All rights reserved.
//

import UIKit
import Foundation
//import "KioskScanner-Bridging-Header.h"

class SwiftViewController: UIViewController, DTDeviceDelegate
{
    // Outlets

    var productDatabase = [Product(name: "Water bottle", quantity: 1, UPC: "123456789", price: 2.49, imageReference: "water-bottle"), Product(name: "Camera", quantity: 1, UPC: "987654321", price: 199.99, imageReference: "camera"), Product(name: "Play Station 3", quantity: 1, UPC: "113456789", price: 249.99, imageReference: "ps3"), Product(name: "HD 650", quantity: 1, UPC: "223456789", price: 349.99, imageReference: "hd650"), Product(name: "Samsung 850 Pro SSD", quantity: 1, UPC: "123456788", price: 189.99, imageReference: "850pro"), Product(name: "TAZO Iced Tea Passion", quantity: 1, UPC: "0762111911643", price: 5.24, imageReference: "tazo"), Product(name: "Alka-seltzer Original", quantity: 1, UPC: "0016500040118", price: 3.99, imageReference: "alka"), Product(name: "Ghirardelli Chocolate", quantity: 1, UPC: "0747599302350", price: 2.70, imageReference: "ghirardelli"), Product(name: "Oxford Index Cards", quantity: 1, UPC: "0078787401563", price: 3.99, imageReference: "oxford"),Product(name: "Anker Dual Charger", quantity: 1, UPC: "X000MY9HDB", price: 12.99, imageReference: "anker"), Product(name: "Pretzel Chocolate", quantity: 1, UPC: "0038000124266", price: 0.99, imageReference: "chocolate"), Product(name: "Clever Cracker", quantity: 1, UPC: "0828408814377", price: 5.99, imageReference: "cracker"), Product(name: "Clorox Wipes", quantity: 1, UPC: "0078742344454", price: 3.98, imageReference: "wetwipes"), Product(name: "Sweet Pea Lotion", quantity: 1, UPC: "894539245", price: 3.49, imageReference: "lotion"), Product(name: "Daily Green Tea", quantity: 1, UPC: "0742676400776", price: 7.99, imageReference: "greentea")]
    
    //@IBOutlet weak var textView: UITextView!
    
   // @IBOutlet weak var textView: UITextView!
    var scannedString: String!
    // Global var
    let scanDevice: DTDevices! = DTDevices.sharedDevice() as DTDevices
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanDevice.barcodeSetScanMode(2, error: nil)
        scanDevice.barcodeStartScan(nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Make this view the delegate
        scanDevice.addDelegate(self)
        scanDevice.connect()
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        // set scan mode, motion used for kiosk
        scanDevice.barcodeSetScanMode(0, error: nil)
        //MODE_SINGLE_SCAN = 0
        scanDevice.barcodeStopScan(nil)
        
        // Remove this view as delegate
        scanDevice.removeDelegate(self)
    }
    
    func connectionState(state: Int32) {
        switch (state){
        case 2:
            // set scan mode, motion used for kiosk
        scanDevice.barcodeSetScanMode(2, error: nil)
        scanDevice.barcodeStartScan(nil)
        //MODE_MOTION_DETECT = 2
        
        default:
            println("")
        }
        
    }
    
    func checkItem(searchBarcode: String, database: Array<Product>) -> Bool{
        var foundItem = false
        
        for (var i=0; i<database.count; i++){
            if searchBarcode == database[i].UPC{
                foundItem = true
            }
        }
        
        return foundItem
    }
    
    // MARK: - DTDEVICES DELEGATE
    // Get barcodes
    func barcodeData(barcode: String!, type: Int32) {
        
        var itemArray = barcode.componentsSeparatedByString("!")
        if checkItem(itemArray[0], database: productDatabase) == true{
            scannedString = barcode
            //self.scannedProduct = searchDatabase(self.scannedString!, database: productDatabase)
            self.performSegueWithIdentifier("scanned", sender: self)
        }
        
        if checkItem(itemArray[0], database: productDatabase) == false{
            self.performSegueWithIdentifier("itemNotFound", sender: self)
        }
        
       // textView.text = barcode
    }
    
    // Get card swipe
    func magneticCardData(track1: String!, track2: String!, track3: String!) {
        //textView.text = "Track1: \(track1)\nTrack2: \(track2)\nTrack 3: \(track3)"
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        if segue.identifier == "scanned" {
            var itemToAdd = segue.destinationViewController as CartViewController
            itemToAdd.cartString = self.scannedString!
        }
        
    }

    
    
    
}

