//
//  CoreDataManager.swift
//  TranslateApp
//
//  Created by Nik on 02.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataManager {
    
    private var nameBD = "TranslateApp"
    private var idKit = "com.nik.CoreDataKit"
    private var groupIdentifier: String? = nil
    
    public static let instance = CoreDataManager()
    
    private init() {}
    
    public func setGroupIdentifier(_ identifier: String? = nil) {
        if identifier != nil {
            groupIdentifier = identifier
        }
    }
    
    public func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: self.context)!
    }
    
    // Fetched Results Controller for Entity Name
    public func fetchedResultsController(entityName: String, keyForSort: String) -> NSFetchedResultsController<DBEntity> {
        
        let fetchRequest = NSFetchRequest<DBEntity>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    static public func loadFromDb<T: DBEntity>(clazz: T.Type, keyForSort: [NSSortDescriptor]) -> [T] {
        return self.loadFromDb(clazz: clazz, keyForSort: keyForSort, portion: Portion(limit: 0), predicate: nil)
    }
    
    static public func loadFromDb<T: DBEntity>(clazz: T.Type, keyForSort: [NSSortDescriptor], loadCount: Int) -> [T] {
        return self.loadFromDb(clazz: clazz, keyForSort: keyForSort, portion: Portion(limit: loadCount), predicate: nil)
    }
    
    /**
     - Returns: First object from DB or nil
     */
    static public func loadFirstFromDb<T: DBEntity>(clazz: T.Type, keyForSort: [NSSortDescriptor]) -> T? {
        let portion = Portion(limit: 1)
        let result = self.loadFromDb(clazz: clazz, keyForSort: keyForSort, portion: portion, predicate: nil)
        return result.isEmpty ? nil : result[0]
    }
    
    /**
     Fetches all objects of specified type to DB
     - Parameter limit: Number of objects to retrieve or 0 for all
     - Returns: Collection of fetched objects or empty collection
     */
    static public func loadFromDb<T: DBEntity>(clazz: T.Type, keyForSort: [NSSortDescriptor], portion: Portion?, predicate: NSPredicate?) -> [T] {
        let fetchRequest = NSFetchRequest<DBEntity>(entityName: String(describing: clazz))
        let sortDescriptor = keyForSort
        fetchRequest.sortDescriptors = sortDescriptor
        
        if (portion != nil) {
            fetchRequest.fetchOffset = (portion?.getOffset())!
            if portion?.getLimit() != 0 {
                fetchRequest.fetchLimit = (portion?.getLimit())!
            }
        }
        
        if (predicate != nil) {
            fetchRequest.predicate = predicate
        }
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
            let items = fetchedResultsController.fetchedObjects as! [T]
            return items
        } catch {
            print(error)
        }
        
        return [T]()
    }
    
    static public func loadFromDbById<T: DBEntity>(clazz: T.Type, id: String) -> T? {
        let items = loadFromDbByItems(clazz: clazz, itemField: "id", itemParametr: id)
        return items.isEmpty ? nil : items[0]
    }
    
    static public func loadFromDbByNameTitle<T: DBEntity>(clazz: T.Type, name: String) -> T? {
        let items = loadFromDbByItems(clazz: clazz, itemField: "title", itemParametr: name)
        return items.isEmpty ? nil : items[0]
    }
    
    static public func loadFromDbByKey<T: DBEntity>(clazz: T.Type, key: String) -> T? {
        let items = loadFromDbByItems(clazz: clazz, itemField: "key", itemParametr: key)
        return items.isEmpty ? nil : items[0]
    }
    
    static public func loadFromDbByItem<T: DBEntity>(clazz: T.Type, itemField: String, itemParametr: String) -> T? {
        let items = loadFromDbByItems(clazz: clazz, itemField: itemField, itemParametr: itemParametr)
        return items.isEmpty ? nil : items[0]
    }
    
    static public func loadCount<T: DBEntity>(clazz: T.Type) -> Int {
        let items = loadFromDb(clazz: clazz, keyForSort: [NSSortDescriptor(key: "id", ascending: true)])
        return items.count
    }

    static public func loadFromDb<T: DBEntity>(clazz: T.Type, keyForSort:  [NSSortDescriptor], predicate: NSPredicate?) -> [T] {
        let fetchRequest = NSFetchRequest<DBEntity>(entityName: String(describing: clazz))
        let sortDescriptor = keyForSort
        fetchRequest.sortDescriptors = sortDescriptor
        
        if (predicate != nil) {
            fetchRequest.predicate = predicate
        }
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
            let items = fetchedResultsController.fetchedObjects as! [T]
            return items
        } catch {
            print(error)
        }
        return [T]()
    }
    
    static public func loadFromDbByItems<T: DBEntity>(clazz: T.Type, itemField: String, itemParametr: String) -> [T] {
        let fetchRequest = NSFetchRequest<DBEntity>(entityName: String(describing: clazz))
        let sortDescriptor = NSSortDescriptor(key: itemField, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "\(itemField) == %@", itemParametr)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
            let items = fetchedResultsController.fetchedObjects as! [T]
            return items.isEmpty ? [T]() : items
        } catch {
            print(error)
        }
        
        return [T]()
    }

    static public func removeEntity<T: DBEntity>(_ clazz: T.Type) {
        let items = loadFromDb(clazz: clazz, keyForSort: [NSSortDescriptor(key: "id", ascending: true)])
        removeCollection(items)
    }
    
    static public func removeCollection<T: DBEntity>(_ entities: [T]) {
        for entity in entities {
            CoreDataManager.instance.context.delete(entity)
        }
    }
    
    // MARK: - Core Data stack
    
    public lazy var oldDataDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urls[urls.count-1]
        return url
    }()
    
    public func modelURL() -> URL {
        return (Bundle(identifier: idKit)?.url(forResource: nameBD, withExtension: "momd"))!
    }
    
    func dataDirectory(_ identifier: String) -> URL {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: identifier)!
    }
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: nameBD)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy public var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        do {
            if groupIdentifier == nil {
                fatalError("No Group Identifier")
            }
            
            return try NSPersistentStoreCoordinator.coordinator(name: nameBD, idKit: idKit, identifier: groupIdentifier!)
        } catch {
            print("CoreData: Unresolved error \(error)")
        }
        return nil
    }()
    
    open class func mainQueueContext() -> NSManagedObjectContext {
        return self.instance.managedObjectContext
    }
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    public var context: NSManagedObjectContext {
        get {
            return managedObjectContext
        }
    }
    
    public func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
            }
        }
    }
}

extension NSPersistentStoreCoordinator {
    /// NSPersistentStoreCoordinator error types
    public enum CoordinatorError: Error {
        /// .momd file not found
        case modelFileNotFound
        /// NSManagedObjectModel creation fail
        case modelCreationError
        /// Gettings document directory fail
        case storePathNotFound
    }
    
    /// Return NSPersistentStoreCoordinator object
    static func coordinator(name: String, idKit: String, identifier: String) throws -> NSPersistentStoreCoordinator? {
        
        let carKitBundle = Bundle(identifier: idKit)
        
        guard let modelURL = carKitBundle?.url(forResource: name, withExtension: "momd") else {
            throw CoordinatorError.modelFileNotFound
        }
        
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            throw CoordinatorError.modelCreationError
        }
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        guard let documents = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: identifier) else {
            throw CoordinatorError.storePathNotFound
        }
        
        do {
            let url = documents.appendingPathComponent("\(name).sqlite")
            
            let options = [NSMigratePersistentStoresAutomaticallyOption:true,
                           NSInferMappingModelAutomaticallyOption:true,
                           NSSQLitePragmasOption:["journal_mode" : "DELETE"]] as NSDictionary
            
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options as? [AnyHashable : Any])
        } catch {
            throw error
        }
        return coordinator
    }
}
