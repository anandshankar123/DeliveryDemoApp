// swiftlint:disable comma
import Foundation
import CoreData
import UIKit
let contextObj = CoreDataHelper.sharedManager.persistentContainer.viewContext
class CoreDataHelper {
    static let sharedManager = CoreDataHelper()
    private init() {}
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DeliveryData")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    func saveContext () {
        let context = contextObj
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func createNewEntity(entityNmae: String) -> NSManagedObject? {
        if let entity = NSEntityDescription.entity(forEntityName:
            entityNmae,in: contextObj) {
            return NSManagedObject(entity: entity, insertInto: contextObj)
        }
        return nil
    }
    func saveData() {
        do {
            try contextObj.save()
            #if DEBUG
            print("data saved")
            #endif
        } catch {
            #if DEBUG
            print("Failed saving")
            #endif
        }
    }
    func checkAndSaveData(saveUrl: String, dataToSave: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName:
            CoreDataEntityName.entityName)
        fetchRequest.predicate = NSPredicate(format: "saveUrl = %@", saveUrl)
        do {
            let dataArr = try contextObj.fetch(fetchRequest)
            if dataArr.count == 0 {
               //create entity and save data
                let deliveryEntity = self.createNewEntity(entityNmae: CoreDataEntityName.entityName) as? DeliveryData
                deliveryEntity?.saveUrl = saveUrl
                deliveryEntity?.deliveryData = dataToSave
                self.saveData()
            } else {
                guard let firstObj = dataArr[0] as? NSManagedObject else { return }
                checkAndReplaceUpadtedData(urls: saveUrl, dataToUpdate: dataToSave,saveObject: firstObj)
            }
        } catch {
            print("Failed to save data : \(error)")
        }
    }
    func checkAndReplaceUpadtedData(urls: String,dataToUpdate: String,saveObject: NSManagedObject) {
        guard let savedDeliveryData = saveObject as? DeliveryData else {
            return
       }
       savedDeliveryData.saveUrl = urls
       savedDeliveryData.deliveryData = dataToUpdate
       saveData()
  }
    func fetchDeliveryData(saveUrl: String, completion: (_ data: [DeliveryModel]?,_ dataFound: Bool) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityName.entityName)
        request.predicate = NSPredicate(format: "saveUrl = %@", saveUrl)
        do {
            let result = try contextObj.fetch(request) as? [NSManagedObject]
            if result?.count ?? 0 > 0 {
                if let entity = result?[0] as? DeliveryData {
                    guard let dataResponse = entity.deliveryData else {
                        return
                    }
                    let deliveryDataResponse = Data(dataResponse.utf8)
                    let stringObj = String.init(data: deliveryDataResponse, encoding: String.Encoding.utf8)
                    print("Fetch data : \(String(describing: stringObj))")
                    do {
                        let genericModel = try JSONDecoder().decode([DeliveryModel].self, from: deliveryDataResponse)
                        if let deliveryResponse  = genericModel as? [DeliveryModel] {
                            return completion(deliveryResponse,true)
                        }
                    } catch {
                        return completion(nil,true)
                    }
                }
            } else { completion(nil,false) }
        } catch {
            return completion(nil,true)
        }
    }
}
