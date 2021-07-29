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
    
    func insertProduct(id: String, name: String, description: String, price: String, image: Data){
        
    
        
        do {
            let product = Item(context: context)
            product.id = Int32(truncating: productList.count as NSNumber)
            product.nama = name
            product.harga = price
            product.deskripsi = description
            product.imageD = image
            saveContext()
        }
        catch {
            print("Error insert data Produk")
        }
    }
    
    func fetchProducts() -> [Item] {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "nama", ascending: true)]
        var products: [Item] = []
        
        do {
            products = try context.fetch(request)
        }
        catch {
            print("Error fetching data produk")
        }
        
        return products
    }
    
    func deleteProduct(item: Item) {
        
        guard let itemcontext = item.managedObjectContext else { return }

        if itemcontext == context {
          itemcontext.delete(item)
        } else {
            itemcontext.perform {
                itemcontext.delete(item)
            }
      }

//          try? self.viewContext.save()
//        context.delete(item)
        saveContext()
    }
}
