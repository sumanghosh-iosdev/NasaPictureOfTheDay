//
//  Created by Suman Ghosh on 07/08/22.
//

import Foundation

protocol APODStorage {
    func store(apod: APOD)
    
    func updateImage(with data: Data, for date: String)
    func updateFavourite(for date: String, isFavourite: Bool)

    func getAPOD(for date: String) -> APODData?
    func getAllPictures() -> [APODData]
    func getFavourites() -> [APODData]
}


struct APODStorageImpl: APODStorage {
    
    let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController = PersistenceController.shared) {
        self.persistenceController = persistenceController
    }
}

// upsert operations on storage
extension APODStorageImpl {
    
    func store(apod: APOD) {
        let context = persistenceController.container.viewContext
        
        let podData = APODData(context: context)
        podData.title = apod.title
        podData.date = apod.date
        podData.explanation = apod.explanation
        podData.mediaType = apod.mediaType
        podData.imageURL = apod.url
        podData.isFavourite = false
        
        do {
            try context.save()
        } catch {
            print("Failed to save")
        }
    }
    
    func updateImage(with data: Data, for date: String) {
        let context = persistenceController.container.viewContext

        if let pod = getAPOD(for: date) {
            pod.image = data
            do {
                try context.save()
            } catch {
                print("Failed to save")
            }
        } else {
            print("No relevant data found")
        }
    }
    
    func updateFavourite(for date: String, isFavourite: Bool) {
        let context = persistenceController.container.viewContext

        if let pod = getAPOD(for: date) {
            pod.isFavourite = isFavourite
            do {
                try context.save()
            } catch {
                print("Failed to save")
            }
        } else {
            print("No relevant data found")
        }
    }
}

// Fetch operations on storage
extension APODStorageImpl {
    
    func getAPOD(for date: String) -> APODData? {
        let context = persistenceController.container.viewContext
        let fetchRequest = APODData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date = %@", date)
        
        do {
            let items = try context.fetch(fetchRequest)
            return items.first
        }
        catch {
            print(error)
            return nil
        }
    }
    
    func getAllPictures() -> [APODData] {
        let context = persistenceController.container.viewContext
        do {
            let items = try context.fetch(APODData.fetchRequest())
            return items
        }
        catch {
            print(error)
            return []
        }
    }
    
    func getFavourites() -> [APODData] {
        let context = persistenceController.container.viewContext
        let fetchRequest = APODData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavourite = %@", true)
        
        do {
            let items = try context.fetch(fetchRequest)
            return items
        }
        catch {
            print(error)
            return []
        }
    }
}
