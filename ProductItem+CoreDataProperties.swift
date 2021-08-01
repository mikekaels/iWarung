//
//  ProductItem+CoreDataProperties.swift
//  iWarung
//
//  Created by Miftahul Jihad on 30/07/21.
//
//

import Foundation
import CoreData


extension ProductItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductItem> {
        return NSFetchRequest<ProductItem>(entityName: "ProductItem")
    }

    @NSManaged public var desc: String?
    @NSManaged public var price: Float
    @NSManaged public var type_scan: String?
    @NSManaged public var image_data: Data?
    @NSManaged public var name: String?
    @NSManaged public var stock: Int64
    @NSManaged public var exp_date: Date?
    @NSManaged public var barcode_value: String?
    @NSManaged public var vision_value: String?

}

extension ProductItem : Identifiable {

}
