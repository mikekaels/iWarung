//
//  KeranjangModel.swift
//  iWarung
//
//  Created by Miftahul Jihad on 04/08/21.
//

import Foundation


class KeranjangModel {
    var id_trx: String
    var list_item: [ItemKeranjang]
    var trx_date: Date
    var bill: Float
    var change: Float
    var money: Float
    
    init(idTrx: String, listItem: [ItemKeranjang], trxDate: Date, bill: Float, change: Float, money: Float) {
        self.id_trx = idTrx
        self.list_item = listItem
        self.trx_date = trxDate
        self.bill = bill
        self.change = change
        self.money = money
    }
    
}


struct ItemKeranjang {
    var image: Data
    var name: String
    var expired: Date
    var price: Float
    var qty: Int
    var total: Float
}
