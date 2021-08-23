//
//  StokKurangInterfaceController.swift
//  iWarung watchOS Extension
//
//  Created by Santo Michael Sihombing on 23/08/21.
//

import WatchKit
import Foundation


class StokKurangInterfaceController: WKInterfaceController {
    @IBOutlet weak var stokKurangTable: WKInterfaceTable!
    
    let stokKurang = ["1", "2", "3", "4", "5", "6", "7"]
    var products = [Any]()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        print("CONTEXT: ",context!)
        products = context as! [Any]
        loadTable()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func loadTable() {
        stokKurangTable.setNumberOfRows(stokKurang.count, withRowType: "StokKurangTableController")

        for (index, labelText) in stokKurang.enumerated() {
            let row = stokKurangTable.rowController(at: index)
            as! StokKurangTableController
        }
    }
}
