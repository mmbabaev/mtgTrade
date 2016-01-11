import UIKit
import CoreData

class CoreDataHelper: NSObject {
    //singleton
    class var instance: CoreDataHelper {
        struct Singleton {
            static let instance = CoreDataHelper()
        }
        return Singleton.instance
    }
    
    let coordinator: NSPersistentStoreCoordinator
    let model: NSManagedObjectModel
    let context: NSManagedObjectContext
    
    private override init() {
        let modelURL = NSBundle.mainBundle()
            .URLForResource("Model",
                withExtension: "momd")!
        model = NSManagedObjectModel(
            contentsOfURL: modelURL)!
        
        let fileManager = NSFileManager.defaultManager()
        let docsURL = fileManager.URLsForDirectory(
            .DocumentDirectory, inDomains: .UserDomainMask).last as NSURL!
        let storeURL = docsURL
            .URLByAppendingPathComponent("base.sqlite")
        
//        let localURL = NSBundle.mainBundle().URLForResource("base", withExtension: "sqlite")
//        NSFileManager.defaultManager().copyItemAtURL(localURL, toURL: storeURL, error: nil)
        
        
        print(storeURL)
        
        coordinator = NSPersistentStoreCoordinator(
            managedObjectModel: model)
        
        var error: NSError?
        
        let store: NSPersistentStore?
        do {
            store = try coordinator.addPersistentStoreWithType(
                        NSSQLiteStoreType, configuration: nil,
                        URL: storeURL, options: nil)
        } catch var error1 as NSError {
            error = error1
            store = nil
        }
        if store == nil {
            print(error?.localizedDescription)
            abort()
        }
        
        context = NSManagedObjectContext()
        context.persistentStoreCoordinator = coordinator
        super.init()
    }
    
    func save() {
        var error: NSError?
        do {
            try context.save()
        } catch let error1 as NSError {
            error = error1
        }
        if let error = error {  //if error != nil
            print(error.localizedDescription)
        }
    }
    
}
