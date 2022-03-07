//
//  Items+CoreDataProperties.swift
//  PurchaseOrderDemo
//
//  Created by Maulik on 6/3/2022.
//
//

import Foundation
import CoreData


extension Items {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Items> {
        return NSFetchRequest<Items>(entityName: "Items")
    }

    @NSManaged public var id: Int64
    @NSManaged public var prodcutItemId: Int64
    @NSManaged public var purchaseOrderId: Int64
    @NSManaged public var quantity: Int64

}

extension Items : Identifiable {

}
