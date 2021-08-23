//
//  Persisten.swift
//  iWarung
//
//  Created by Miftahul Jihad on 29/07/21.
//

import UIKit
import CoreData


class Persisten {
    static let shared = Persisten()
    

    private static var persistenContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "iWarung")
        container.loadPersistentStores(completionHandler: { (storeDescription, error ) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return Persisten.persistenContainer.viewContext
    }
    
    func saveContext() {
        let context = context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func insertProduct(scanValue: String,  name: String, description: String, price: Float, image: Data, expired: Date, stock: Int64, min_stock: Int64){
        
        do {
            let product = ProductItem(context: context)
            product.barcode_value = scanValue
            product.name = name
            product.price = price
            product.desc = description
            product.stock = stock
            product.exp_date = expired
            product.image_data = image
            product.min_stock = min_stock
            saveContext()
        } catch {
            print("Error insert data Produk")
        }
    }
    
    func fetchProducts() -> [ProductItem] {
        let request : NSFetchRequest<ProductItem> = ProductItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        var products: [ProductItem] = []
        
        do {
            products = try context.fetch(request)
        }
        catch {
            print("Error fetching data produk")
        }
        
        return products
    }
    
    func fetchProductsByBarcode(with barcode: String) -> [ProductItem] {
        let request : NSFetchRequest<ProductItem> = ProductItem.fetchRequest()

        request.predicate = NSPredicate(format: "barcode_value CONTAINS[cd] %@", barcode)
        var products: [ProductItem] = []

        do{
            products = try Persisten.shared.context.fetch(request)
//            return products

        } catch let error{
            print("ga mencari \(error)")
        }
        return products
    }
    
    func fetchProductsByNonBarcode(with barcode: [String]) -> [ProductItem] {
        var resultProduct : [ProductItem] = []
        let request : NSFetchRequest<ProductItem> = ProductItem.fetchRequest()
        var products: [ProductItem] = []

        do {
            products = try Persisten.shared.context.fetch(request)
        } catch let error{
            print("ga mencari \(error)")
        }
        
        for value in products {
            let resultTextArray = value.barcode_value?.components(separatedBy: ",") ?? []
            for text in resultTextArray {
                if text.contains(barcode.first ?? "") {
                    resultProduct.append(value)
                }
            }
        }
        
        return resultProduct
    }
    
    func deleteProduct(item: ProductItem) {
        
        guard let itemcontext = item.managedObjectContext else { return }

        if itemcontext == context {
          itemcontext.delete(item)
        } else {
            itemcontext.perform {
                itemcontext.delete(item)
            }
      }

        saveContext()
    }
    
    
}
