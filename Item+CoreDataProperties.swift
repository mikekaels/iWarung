//
//  Item+CoreDataProperties.swift
//  iWarung
//
//  Created by Miftahul Jihad on 25/07/21.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var deskripsi: String?
    @NSManaged public var harga: String?
    @NSManaged public var id: Int32
    @NSManaged public var nama: String?

}

extension Item : Identifiable {

}
