//
//  ViewController.swift
//  MTBBarcodeScannerPOC
//
//  Created by mac on 26/10/1439 AH.
//  Copyright © 1439 mac. All rights reserved.
//

import UIKit
import MTBBarcodeScanner

class ViewController: UIViewController {
    // MARK: ~ Properties
    // Get reference of preview view in UI.
    @IBOutlet weak var previewView: UIView!
    // Define the scanner.
    var scanner: MTBBarcodeScanner?
    // Define dictionary to store the code views.
    var codeViews: [String: UIView] = Dictionary()
    // Define list to store the code strings.
    var codeStrings: [String] = [String]()
    
    // MARK: ~ Others
    override func viewDidLoad() {
        super.viewDidLoad()
        // Define the scanner to have "previewView" as its preview view.
        scanner = MTBBarcodeScanner(previewView: previewView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Request camera permission from the user.
        MTBBarcodeScanner.requestCameraPermission(success: { success in
            if success { // If the user give permission, start scanning.
                do {
                    try self.scanner?.startScanning(resultBlock: { codes in
                        if let codes = codes {
                            // // For all codes in the screen.
                            for code in codes {
                                self.drawCodeView(code: code)
                                //self.removeCodeView(code: code)
                                
                                // Get the codeString.
                                let stringValue = code.stringValue!
                                // Add the stringValue to the codeStrings list.
                                self.codeStrings.append(stringValue)
                                // Print the stringValue.
                                print("Scanned code: \(stringValue)")
                            }
                            self.codeStrings = [String]()
                        }
                    })
                } catch {
                    NSLog("Unable to start scanning")
                }
            } else { // If the user does not give permission, print scanning is not available due to not having permission.
                NSLog("This app does not have permission to access the camera")
            }
        })
    }
    
    // MARK: ~ Private Methods
    /*To draw squares that bound the codes*/
    private func drawCodeView(code: AVMetadataMachineReadableCodeObject) {
        
        // Bound the code
        let codeView: UIView = UIView(frame: code.bounds)
        codeView.backgroundColor = UIColor.green
        codeView.layer.borderWidth = 5.0
        
        // Add the created view to the codeViews.
        codeViews[code.stringValue!] = codeView
        
        // Add the created view to the previewView.
        self.previewView.addSubview(codeView)

    }
    
    /*To remove the code views that are not on the screen*/
    private func removeCodeView(code: AVMetadataMachineReadableCodeObject) {
        for codeString in codeViews.keys {
            if !codeStrings.contains(codeString) {
                codeViews[codeString]?.removeFromSuperview()
                codeViews[codeString] = nil
            }
        }
    }

}

