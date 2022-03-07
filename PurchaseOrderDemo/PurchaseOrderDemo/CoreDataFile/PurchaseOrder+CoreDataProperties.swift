//
//  PurchaseOrder+CoreDataProperties.swift
//  PurchaseOrderDemo
//
//  Created by Maulik on 6/3/2022.
//
//

import Foundation
import CoreData


extension PurchaseOrder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PurchaseOrder> {
        return NSFetchRequest<PurchaseOrder>(entityName: "PurchaseOrder")
    }

    @NSManaged public var id: Int64
    @NSManaged public var lastUpdateDate: String?
    @NSManaged public var numberOfItems: Int64
    @NSManaged public var purchaseOrderNumber: String?

}

extension PurchaseOrder : Identifiable {

}
