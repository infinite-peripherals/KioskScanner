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
    //@IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textView: UITextView!
    var scannedString: String!
    // Global var
    let scanDevice: DTDevices! = DTDevices.sharedDevice() as DTDevices
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    // MARK: - DTDEVICES DELEGATE
    // Get barcodes
    func barcodeData(barcode: String!, type: Int32) {
        self.performSegueWithIdentifier("scanned", sender: self)
        scannedString = barcode
        textView.text = barcode
    }
    
    // Get card swipe
    func magneticCardData(track1: String!, track2: String!, track3: String!) {
        textView.text = "Track1: \(track1)\nTrack2: \(track2)\nTrack 3: \(track3)"
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

