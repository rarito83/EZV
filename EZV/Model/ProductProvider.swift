//
//  ProductProvider.swift
//  EZV
//
//  Created by Rarito on 03/03/23.
//

import Foundation
import CoreData

class ProductProvider {
  
  lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "FavoriteProduct")

      container.loadPersistentStores { _, error in
          guard error == nil else {
              fatalError("Unresolved error \(error!)")
          }
      }
      container.viewContext.automaticallyMergesChangesFromParent = false
      container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
      container.viewContext.shouldDeleteInaccessibleFaults = true
      container.viewContext.undoManager = nil

      return container
  }()

  private func newTaskContext() -> NSManagedObjectContext {
      let taskContext = persistentContainer.newBackgroundContext()
      taskContext.undoManager = nil

      taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
      return taskContext
  }

  func getAllProduct(completion: @escaping(_ products: [Product]) -> Void) {
      let taskContext = newTaskContext()
      taskContext.perform {
          let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
          do {
              let results = try taskContext.fetch(fetchRequest)
              var products: [Product] = []
              for result in results {
                  let prod = Product(
                      id: result.value(forKeyPath: "prod_id") as! Int32,
                      title: result.value(forKeyPath: "title") as! String,
                      description: result.value(forKeyPath: "description") as! String,
                      price: result.value(forKeyPath: "price") as! Int32,
                      discount: result.value(forKeyPath: "discountPercentage") as! Double,
                      rating: result.value(forKeyPath: "rating") as! Double,
                      stock: result.value(forKeyPath: "stock") as! Int32,
                      brand: result.value(forKeyPath: "brand") as! String,
                      category: result.value(forKeyPath: "category") as! String,
                      thumbnail: result.value(forKeyPath: "thumbnail") as! String,
                      image: result.value(forKeyPath: "image") as! String
                  )
                  products.append(prod)
              }
              completion(products)
          } catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
          }
      }
  }

  func getProduct(_ id: Int, completion: @escaping(_ product: Product?) -> Void) {
      let taskContext = newTaskContext()
      taskContext.perform {
          let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
          fetchRequest.fetchLimit = 1
          fetchRequest.predicate = NSPredicate(format: "prod_id == \(id)")

          do {
            if let result = try taskContext.fetch(fetchRequest).first {
              let prod = Product(
                id: result.value(forKeyPath: "prod_id") as! Int32,
                title: result.value(forKeyPath: "title") as! String,
                description: result.value(forKeyPath: "description") as! String,
                price: result.value(forKeyPath: "price") as! Int32,
                discount: result.value(forKeyPath: "discountPercentage") as! Double,
                rating: result.value(forKeyPath: "rating") as! Double,
                stock: result.value(forKeyPath: "stock") as! Int32,
                brand: result.value(forKeyPath: "brand") as! String,
                category: result.value(forKeyPath: "category") as! String,
                thumbnail: result.value(forKeyPath: "thumbnail") as! String,
                image: result.value(forKeyPath: "image") as! String
              )
              completion(prod)
            } else {
                completion(nil)
            }
          } catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
          }
      }
  }

  func createProduct(_ input: Product, completion: @escaping() -> Void) {
      let taskContext = newTaskContext()
      taskContext.performAndWait {
          if let entity = NSEntityDescription.entity(forEntityName: "Product", in: taskContext) {
              let prod = NSManagedObject(entity: entity, insertInto: taskContext)
              self.getMaxId { id in
                prod.setValue(id+1, forKeyPath: "id")
                prod.setValue(input.id, forKeyPath: "prod_id")
                prod.setValue(input.title, forKeyPath: "title")
                prod.setValue(input.description, forKeyPath: "description")
                prod.setValue(input.price, forKeyPath: "price")
                prod.setValue(input.discount, forKeyPath: "discountPercentage")
                prod.setValue(input.rating, forKeyPath: "rating")
                prod.setValue(input.stock, forKeyPath: "stock")
                prod.setValue(input.brand, forKeyPath: "brand")
                prod.setValue(input.category, forKeyPath: "category")
                prod.setValue(input.thumbnail, forKeyPath: "thumbnail")
                prod.setValue(input.image, forKeyPath: "image")

                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
              }
          }
      }
  }

  func deleteProduct(_ id: Int, completion: @escaping() -> Void) {
      let taskContext = newTaskContext()
      taskContext.perform {
          let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
          fetchRequest.fetchLimit = 1
          fetchRequest.predicate = NSPredicate(format: "prod_id == \(id)")
          let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
          batchDeleteRequest.resultType = .resultTypeCount
          if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
              if batchDeleteResult.result != nil {
                  completion()
              }
          }
      }
  }

  func getMaxId(completion: @escaping(_ maxId: Int) -> Void) {
      let taskContext = newTaskContext()
      taskContext.performAndWait {
          let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
          let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
          fetchRequest.sortDescriptors = [sortDescriptor]
          fetchRequest.fetchLimit = 1
          do {
              let lastGame = try taskContext.fetch(fetchRequest)
              if let game = lastGame.first, let position = game.value(forKeyPath: "id") as? Int {
                  completion(position)
              } else {
                  completion(0)
              }
          } catch {
              print(error.localizedDescription)
          }
      }
  }
}
