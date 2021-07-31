import CoreData

public class Progress: NSManagedObject, Identifiable {
    @NSManaged public var day: NSString
    @NSManaged public var calories: NSNumber
    @NSManaged public var progressDate: NSNumber
}

extension Progress {
    static func getAll() -> NSFetchRequest<Progress> {
        let request: NSFetchRequest<Progress> = Progress.fetchRequest() as! NSFetchRequest<Progress>

        return request
    }
}
