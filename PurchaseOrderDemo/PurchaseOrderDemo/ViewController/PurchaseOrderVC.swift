//
//  PurchaseOrderVC.swift
//  PurchaseOrderDemo
//
//  Created by Maulik on 6/3/2022.
//

import UIKit
import CoreData

class PurchaseOrderVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    //Tableview for purchase order
    @IBOutlet var purchaseOrderTable: UITableView!
        
    //Array for store purchase order list
    var purchaseOrderList:[PurchaseOrder]?
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchExistingPurchaseOrders()
        let url = "https://my-json-server.typicode.com/butterfly-systems/sample-data/purchase_orders"
        getData(from: url)
        purchaseOrderTable.dataSource = self
        purchaseOrderTable.delegate = self
    }
    
    //IBClick events
    @IBAction func addPurchaseOrder(_ sender: Any) {
        let alert = UIAlertController(title: "Add purchase order", message: "Add purchase order number", preferredStyle: .alert)
        alert.addTextField()
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            let textField = alert.textFields![0]
            
            let newPurchaseOrder = PurchaseOrder(context: self.context)
            let date = Date()
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            var updatedDate = formatter.string(from: date)
            newPurchaseOrder.numberOfItems = 0
            newPurchaseOrder.lastUpdateDate = updatedDate
            formatter.dateFormat = "yyyyMMddHHmmss"
            updatedDate = formatter.string(from: date)
            newPurchaseOrder.id =  Int64(updatedDate)!
            newPurchaseOrder.purchaseOrderNumber = textField.text
            do{
                try self.context.save()
            }catch{
                
            }
            self.fetchExistingPurchaseOrders()
            DispatchQueue.main.async {
                self.purchaseOrderTable.reloadData()
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        
        //add button
        alert.addAction(cancelButton)
        alert.addAction(submitButton)
        
        //show alert
        self.present(alert, animated: true, completion: nil)
    }
    
    //Tableview Datasource and delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.purchaseOrderList!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PurchaseOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PurchaseOrderTableViewCell", for: indexPath) as! PurchaseOrderTableViewCell
        let purchaseOrderItem: PurchaseOrder = self.purchaseOrderList![indexPath.row]
        cell.purchaseOrderIDLabel.text = "Purchase Order Id: " + String(purchaseOrderItem.id)
        cell.numberOfItemsLabel.text = "Number Of Items: " + String(purchaseOrderItem.numberOfItems)
        cell.lastUpdatedDateLabel.text = "Last Updated On: " + purchaseOrderItem.lastUpdateDate!
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        controller.modalPresentationStyle = .fullScreen
        controller.getPurchaseOrderID = self.purchaseOrderList![indexPath.row].id
        self.present(controller, animated: true, completion: nil)
        
    }
    // Fetch existing purchasae order list
    private func fetchExistingPurchaseOrders(){
        do{
            purchaseOrderList = try context.fetch(PurchaseOrder.fetchRequest())
        }catch{
        }
    }
    
    //web service calling
    //Check every time for data update
    //Add new data
    private func getData(from url: String){
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler:{ [self]data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let results: [Result] = try JSONDecoder().decode([Result].self, from: data)
                for result in results {
                    let fetchRequest: NSFetchRequest <PurchaseOrder>
                    fetchRequest = PurchaseOrder.fetchRequest()
                    let pre = NSPredicate(format: "id == %ld", result.id)
                    fetchRequest.predicate = pre
                    // Call existing purchase order through id and compare updated date
                    let existingPurchaseOrder:[PurchaseOrder] = try context.fetch(fetchRequest)
                    if existingPurchaseOrder.isEmpty == true {
                        //If there is not any object in database, then add new object for purchase order
                        let purchaseorder = PurchaseOrder(context: self.context)
                        purchaseorder.id = result.id
                        purchaseorder.numberOfItems = Int64 (truncatingIfNeeded:result.items.count)
                        purchaseorder.lastUpdateDate = result.last_updated
                        purchaseorder.purchaseOrderNumber = result.purchase_order_number
                        do{
                            try self.context.save()
                        }catch{
                            
                        }
                        for item in result.items{
                            //Add new object for product items
                            let itemOrder = Items(context: self.context)
                            itemOrder.id = item.id
                            itemOrder.prodcutItemId = item.product_item_id
                            itemOrder.quantity = item.quantity
                            itemOrder.purchaseOrderId = result.id
                            do{
                                try self.context.save()
                            }catch{
                            }
                            
                        }
                        for invoice in result.invoices{
                            //Add new invoice
                            let invoiceDetails = Invoices(context: self.context)
                            invoiceDetails.id = invoice.id
                            invoiceDetails.invoiceNumber = invoice.invoice_number
                            invoiceDetails.receivedStatus = invoice.received_status
                            invoiceDetails.purchaseOrderId = result.id
                            do{
                                try self.context.save()
                            }catch{
                                
                            }
                            for receipt in invoice.receipts{
                                //Add new receipt
                                let recepitDetails = Receipts(context: self.context)
                                recepitDetails.id = receipt.id
                                recepitDetails.receivedQuantity = receipt.received_quantity
                                recepitDetails.productItemId = receipt.product_item_id
                                recepitDetails.invoiceId = invoice.id
                                do{
                                    try self.context.save()
                                }catch{
                                    
                                }
                            }
                        }
                    }else{
                        //If object is already in purchase order table, then compare and update date,
                        let objPurchasaeorder = existingPurchaseOrder.first
                        if objPurchasaeorder?.lastUpdateDate != result.last_updated{
                            objPurchasaeorder?.lastUpdateDate = result.last_updated
                            do{
                                try self.context.save()
                            }catch{
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.fetchExistingPurchaseOrders()
                    self.purchaseOrderTable.reloadData()
                }
    
            }catch{
            }
            
        }).resume()
    }
}

// Structure for get data from json
struct Result: Codable{
    let id: Int64
    let purchase_order_number: String
    let items: [Item]
    let invoices: [Invoice]
    let last_updated: String
}
struct Item: Codable{
    let id: Int64
    let product_item_id: Int64
    let quantity: Int64
}
struct Invoice: Codable{
    let id: Int64
    let invoice_number: String
    let received_status: Int16
    let receipts: [Receipt]
}
struct Receipt: Codable{
    let id: Int64
    let product_item_id: Int64
    let received_quantity: Int64
}
