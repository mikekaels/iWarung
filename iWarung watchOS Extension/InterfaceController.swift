//
//  InterfaceController.swift
//  iWarung watchOS Extension
//
//  Created by Santo Michael Sihombing on 22/08/21.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    @IBOutlet weak var label: WKInterfaceLabel!
    
    var connectivityHandler = WatchSessionManager.shared
    var session : WCSession?
    var lastNumber: Int = 0
    var products = [Any]()
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        connectivityHandler.startSession()
        connectivityHandler.watchOSDelegate = self
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func buttonTapped() {
        
        do {
            try connectivityHandler.updateApplicationContext(applicationContext: ["row" : self.lastNumber as AnyObject])
        } catch {
            print("Error: \(error)")
        }
        
        lastNumber += 1
    }
    @IBAction func stokKurangButtonTapped() {
        print("TAPPED DATA: ",self.products)
        presentController(withName: "StokKurangInterfaceController", context: self.products)
    }
}

extension InterfaceController: WatchOSDelegate {
    func messageReceived(tuple: MessageReceived) {
        
    }
    
    func applicationContextReceived(tuple: ApplicationContextReceived) {
        DispatchQueue.main.async() {
            if let text = tuple.applicationContext["row"] as? Int {
                print("TEXT IN WATCHOS: ", text)
                self.label.setText(String(text))
                self.lastNumber = text
            }
            
            if let data = tuple.applicationContext["data"] as? Any {
//                self.label.setText(String(data[0].name))
                print("THE DATA: ",data)
                self.products = data as! [Any]
            }
        }
    }
    
    
}
