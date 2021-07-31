//
//  UserDefaultsSettings.swift
//  Project17
//
//  Created by Evan Tu on 7/18/21.
//

import Foundation
import CoreData

public class Food: NSManagedObject, Identifiable {
    @NSManaged public var type: NSString
    @NSManaged public var foodName: NSString
    @NSManaged public var foodCalories: NSNumber
    @NSManaged public var date: Date
}

extension Food {
    static func getAll() -> NSFetchRequest<Food> {
        let request: NSFetchRequest<Food> = Food.fetchRequest() as! NSFetchRequest<Food>
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
}
