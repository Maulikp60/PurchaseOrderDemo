//
//  Receipts+CoreDataProperties.swift
//  PurchaseOrderDemo
//
//  Created by Maulik on 6/3/2022.
//
//

import Foundation
import CoreData


extension Receipts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receipts> {
        return NSFetchRequest<Receipts>(entityName: "Receipts")
    }

    @NSManaged public var id: Int64
    @NSManaged public var invoiceId: Int64
    @NSManaged public var productItemId: Int64
    @NSManaged public var receivedQuantity: Int64

}

extension Receipts : Identifiable {

}
