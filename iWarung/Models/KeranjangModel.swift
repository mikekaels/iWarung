//
//  KeranjangModel.swift
//  iWarung
//
//  Created by Miftahul Jihad on 04/08/21.
//

import Foundation
import CoreData

struct KeranjangModel {
    var id_trx: String
    var list_item: [ItemKeranjang]
    var trx_date: Date
    var bill: Float
    var change: Float
    var money: Float
    
//    init(idTrx: String, listItem: [ItemKeranjang], trxDate: Date, bill: Float, change: Float, money: Float) {
//        self.id_trx = idTrx
//        self.list_item = listItem
//        self.trx_date = trxDate
//        self.bill = bill
//        self.change = change
//        self.money = money
//    }
//
}


struct ItemKeranjang {
    var id: NSManagedObjectID
    var image: Data
    var name: String
    var expired: Date
    var price: Float
    var qty: Int
    var total: Float
}

struct KeranjangManager {
    var items : [ItemKeranjang] = []
    var totalBelanja: Float {
        var total: Float = 0.0
        for item in items {
            total += (Float(item.qty) * item.price)
        }
        return total
    }
    
    func fetchItems()-> [ItemKeranjang] {
        return self.items
    }
    
    mutating func addItem(item: ItemKeranjang) {
        self.items.append(item)
    }
    
    mutating func deleteItem(indexPath: Int) {
        self.items.remove(at: indexPath)
    }
    
    mutating func changeQty(indexPath: Int, qty: Int) {
        self.items[indexPath].qty = qty
    }
}
