//
//  DetailsVC.swift
//  PurchaseOrderDemo
//
//  Created by Maulik on 6/3/2022.
//

import UIKit
import CoreData

class DetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var getPurchaseOrderID: Int64 = 0 // get purchase order id from purchase order view controller
    
    //View and tableview for show items list
    @IBOutlet var itemShowView: UIView!
    @IBOutlet var itemTable: UITableView!
    
    //View and tableview for show invoices list
    @IBOutlet var invoiceTable: UITableView!
    @IBOutlet var invoiceShowView: UIView!
    
    //Array for save items, invoices, and recepits from core data
    var itemsList:[Items]?
    var invoiceList:[Invoices]?
    var receipts:[Receipts]?
    
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate and datasource method for tableviews
        itemTable.delegate = self
        itemTable.dataSource = self
        invoiceTable.delegate = self
        invoiceTable.dataSource = self
        fetchItemsList()
        fetchInvoicesList()
        fetchReceiptsList()
    }
    
    //IB click events for buttons and segments
    @IBAction func clickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func clickSegmetChange(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            itemShowView.isHidden = false
            invoiceShowView.isHidden = true
        case 1:
            itemShowView.isHidden = true
            invoiceShowView.isHidden = false
        default:
            break;
        }
    }
    @IBAction func clickAddItem(_ sender: Any) {
        let alert = UIAlertController(title: "Add Item", message: "Add item id and quantity", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Item Id: "
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Item Quantity: "
        }
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            let textFieldItemId = alert.textFields![0].text
            let textFieldItemQuantity = alert.textFields![1].text
            let newItemOrder = Items(context: self.context)
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let updatedDate = formatter.string(from: date)
            newItemOrder.id = Int64(updatedDate)!
            newItemOrder.prodcutItemId = Int64 (textFieldItemId!)!
            newItemOrder.purchaseOrderId = self.getPurchaseOrderID
            newItemOrder.quantity = Int64(textFieldItemQuantity!)!
            do{
                try self.context.save()
            }catch{
            }
            self.fetchItemsList()
            
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        
        //add button
        alert.addAction(cancelButton)
        alert.addAction(submitButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Table view data source and delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.itemTable{
            return self.itemsList!.count
        }
        else{
            return self.invoiceList!.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.itemTable{
            let cell: ItemsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ItemsTableViewCell", for: indexPath) as! ItemsTableViewCell
            let item: Items = self.itemsList![indexPath.row]
            cell.itemIDLabel.text = "Item Id: " + String(item.prodcutItemId)
            cell.quantityLabel.text = "Quantity: " + String(item.quantity)
            return cell
        }
        else{
            let cell: InvoicesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "InvoicesTableViewCell", for: indexPath) as! InvoicesTableViewCell
            let invoiceItem: Invoices = self.invoiceList![indexPath.row]
            cell.invoiceNumberLabel.text = "Invoice Number: " + String(invoiceItem.id)
            cell.receivedStatusLabel.text = "Received Status: " + String(invoiceItem.receivedStatus)
            return cell
        }
        
    }
    
    // Fetch items list based on purchase order from databasae
    private func fetchItemsList(){
        do{
            let fetchRequest: NSFetchRequest<Items>
            fetchRequest = Items.fetchRequest()
            let pre = NSPredicate(format: "purchaseOrderId == %ld", getPurchaseOrderID)
            fetchRequest.predicate = pre
            itemsList = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.itemTable.reloadData()
            }
        }catch{
        }
    }
    
    // Fetch invoices list based on purchase order from databasae
    private func fetchInvoicesList(){
        do{
            let fetchRequest: NSFetchRequest<Invoices>
            fetchRequest = Invoices.fetchRequest()
            let pre = NSPredicate(format: "purchaseOrderId == %ld", getPurchaseOrderID)
            fetchRequest.predicate = pre
            invoiceList = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.invoiceTable.reloadData()
            }
        }catch{
        }
    }
    
    // Fetch receipts list from databasae // for future use
    func fetchReceiptsList(){
        do{
            receipts = try context.fetch(Receipts.fetchRequest())
        }catch{
        }
    }
}
