//
//  ProductItem+CoreDataProperties.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 22/08/21.
//
//

import Foundation
import CoreData


extension ProductItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductItem> {
        return NSFetchRequest<ProductItem>(entityName: "ProductItem")
    }

    @NSManaged public var barcode_value: String?
    @NSManaged public var desc: String?
    @NSManaged public var exp_date: Date?
    @NSManaged public var image_data: Data?
    @NSManaged public var name: String?
    @NSManaged public var price: Float
    @NSManaged public var stock: Int64
    @NSManaged public var type_scan: String?
    @NSManaged public var vision_value: String?
    @NSManaged public var min_stock: Int64
}

extension ProductItem : Identifiable {

}
