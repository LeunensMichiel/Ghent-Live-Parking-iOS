import CoreData

struct CoreDataManager {
    static let sharedCoreData = CoreDataManager()

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ParkingDataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Loading of store failed \(error)")
            }
        }
        return container
    }()

    @discardableResult
    func createParking(parking: Parking) -> ParkingDM? {
        let context = persistentContainer.viewContext

        let localParking = NSEntityDescription.insertNewObject(forEntityName: "ParkingDM", into: context) as! ParkingDM // NSManagedObject

        localParking.name = parking.name
        localParking.address = parking.address
        localParking.id = parking.id
        localParking.latitude = parking.geo_location![0]
        localParking.longitude = parking.geo_location![1]
        localParking.isParked = true

        do {
            try context.save()
            return localParking
        } catch let createError {
            print("Failed to create: \(createError)")
        }

        return nil
    }

    func fetchParking(withId id: String) -> ParkingDM? {
        let context = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<ParkingDM>(entityName: "ParkingDM")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            let parkings = try context.fetch(fetchRequest)
            return parkings.first
        } catch let fetchError {
            print("Failed to fetch: \(fetchError)")
        }

        return nil
    }

    func fetchParkings() -> [ParkingDM]? {
        let context = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<ParkingDM>(entityName: "ParkingDM")

        do {
            let parkings = try context.fetch(fetchRequest)
            return parkings
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
        }
        return nil
    }

    func updateParking(parking: ParkingDM) {
        let context = persistentContainer.viewContext

        do {
            try context.save()
        } catch let createError {
            print("Failed to update: \(createError)")
        }
    }

    func deleteParking(parking: ParkingDM) {
        let context = persistentContainer.viewContext
        context.delete(parking)
        do {
            try context.save()
        } catch let saveError {
            print("Failed to delete: \(saveError)")
        }
    }

    func deleteAllEntities() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ParkingDM")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
}
