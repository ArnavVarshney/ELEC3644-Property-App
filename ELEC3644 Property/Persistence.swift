//
//  Persistence.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 23/11/2024.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let uids = ["68b696d7-320b-4402-a412-d9cee10fc6a3"]
        let propertyIds = ["c96e735d-fd0b-48f1-a40e-5cafa57dab31", "86c46f5f-0ff0-438b-873d-9e4e40beede7", "0e287890-277c-47fb-aafc-ff92ca770852"]
        for uid in uids {
            for pid in propertyIds{
                let newItem = PropertyHistory(context: viewContext)
                newItem.userId = UUID(uuidString: uid)
                newItem.id = UUID()
                newItem.propertyId = UUID(uuidString: uid)
                var d = Date()
                d = d - Double.random(in: 0...60*60*24*30)
                newItem.dateTime = d
            }
        }

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "LocallyStored")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
