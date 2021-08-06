//
//  ProductModel.swift
//  iWarung
//
//  Created by Miftahul Jihad on 06/08/21.
//

import UIKit
import CoreData

struct ProductModel {
    var desc: String?
    var price: Float
    var type_scan: String?
    var image_data: Data?
    var name: String?
    var stock: Int64
    var exp_date: Date?
    var barcode_value: String?
    var vision_value: String?
}

class CDManager: NSObject {
    var productItem = ProductModel(desc: "", price: 0.0, type_scan: "", image_data: Data(), name: "", stock: 0, exp_date: Date(), barcode_value: "", vision_value: "")
    
    override init() {
        super.init()
//        self.readData()
    }
    
//    func fetchProducts() -> [ProductItem] {
//        let request : NSFetchRequest<ProductItem> = ProductItem.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        var products: [ProductItem] = []
//        
//        do {
//            products = try context.fetch(request)
//        }
//        catch {
//            print("Error fetching data produk")
//        }
//        
//        return products
//    }
    
    func readData(){
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductItem")
        
        
        do{
            let res = try context.fetch(fetchRequest)
            
            
            if res.count > 0 {
                let a = res[0] as! NSManagedObject

                guard let name = a.value(forKey: "name") else{
                    return
                }
                self.productItem.name = name as? String

                guard let desc = a.value(forKey: "desc")else{
                    return
                }
                self.productItem.desc = desc as? String

                guard let imageData = a.value(forKey: "image_data") else {
                    return
                }
                self.productItem.image_data =  imageData as? Data

                guard let price = a.value(forKey: "price") else {
                    return
                }
                self.productItem.price =  (price as? Float)!

                guard let stock = a.value(forKey: "stock") else {
                    return
                }
                self.productItem.stock =  (stock as? Int64)!

                guard let date = a.value(forKey: "exp_date") else {
                    return
                }
                self.productItem.exp_date =  date as? Date

                guard let barcodeVal = a.value(forKey: "barcode_value") else {
                    return
                }
                self.productItem.barcode_value =  barcodeVal as? String

                guard let visionVal = a.value(forKey: "vision_value") else {
                    return
                }
                self.productItem.vision_value =  visionVal as? String

                print("Res ini apa sih",res)
                print("A ini apa sih",a)
            }else{
                saveData()
                print("Empty")
            }
            
        }
        catch{
            
        }
    }
    
//    func insertProduct(scanValue: String,  name: String, description: String, price: Float, image: Data, expired: Date, stock: Int64){
//        let app = UIApplication.shared.delegate as! AppDelegate
//        let context = app.persistentContainer.viewContext
//        let entity = NSEntityDescription.insertNewObject(forEntityName: "ProductItem", into: context)
//        let product = ProductModel(context: context)
//        product.barcode_value = scanValue
//        product.name = name
//        product.price = price
//        product.desc = description
//        product.stock = stock
//        product.exp_date = expired
//        product.image_data = image
//        do {
//
//            saveContext()
//        } catch {
//            print("Error insert data Produk")
//        }
//    }
    
    func saveData(){
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        let entity = NSEntityDescription.insertNewObject(forEntityName: "ProductItem", into: context)
        
        entity.setValue(productItem.name, forKey: "name")
        entity.setValue(productItem.desc, forKey: "desc")
        entity.setValue(productItem.barcode_value, forKey: "barcode_value")
        entity.setValue(productItem.vision_value, forKey: "vision_value")
        entity.setValue(productItem.price, forKey: "price")
        entity.setValue(productItem.stock, forKey: "stock")
        entity.setValue(productItem.image_data, forKey: "image_data")
        entity.setValue(productItem.exp_date, forKey: "exp_date")
        entity.setValue(productItem.type_scan, forKey: "type_scan")
    }
    
    func updateData(onSuccess:@escaping ()->Void, onError:@escaping ()->Void ){
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductItem")
        
        
        do{
            let res = try context.fetch(fetchRequest)
            
            if res.count > 0{
                let up = res[0] as! NSManagedObject
                up.setValue(productItem.name, forKey: "name")
                up.setValue(productItem.desc, forKey: "desc")
                up.setValue(productItem.barcode_value, forKey: "barcode_value")
                up.setValue(productItem.vision_value, forKey: "vision_value")
                up.setValue(productItem.price, forKey: "price")
                up.setValue(productItem.stock, forKey: "stock")
                up.setValue(productItem.image_data, forKey: "image_data")
                up.setValue(productItem.exp_date, forKey: "exp_date")
                up.setValue(productItem.type_scan, forKey: "type_scan")
                try context.save()
                onSuccess()
            }else{
                saveData()
            }
            
        }
        catch{
            onError()
        }
    }
}
