//
//  Invoices+CoreDataProperties.swift
//  PurchaseOrderDemo
//
//  Created by Maulik on 6/3/2022.
//
//

import Foundation
import CoreData


extension Invoices {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Invoices> {
        return NSFetchRequest<Invoices>(entityName: "Invoices")
    }

    @NSManaged public var id: Int64
    @NSManaged public var invoiceNumber: String?
    @NSManaged public var purchaseOrderId: Int64
    @NSManaged public var receivedStatus: Int16

}

extension Invoices : Identifiable {

}
