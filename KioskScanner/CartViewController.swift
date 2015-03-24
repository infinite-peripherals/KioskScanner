//
//  CartViewController.swift
//  KioskScanner
//
//  Created by Kenny Pham on 3/2/15.
//  Copyright (c) 2015 InfinitePeripherals. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cartTableView: UITableView!
    var cartString: String = ""
    var cartList: Array<AnyObject> = []
    
    @IBOutlet weak var totalLabel: UILabel!
    var theCart = [NSManagedObject]()
    
    var productDatabase = [Product(name: "Water bottle", quantity: 1, UPC: "123456789", price: 2.49, imageReference: "water-bottle"), Product(name: "Camera", quantity: 1, UPC: "987654321", price: 199.99, imageReference: "camera"), Product(name: "Play Station 3", quantity: 1, UPC: "113456789", price: 249.99, imageReference: "ps3"), Product(name: "HD 650", quantity: 1, UPC: "223456789", price: 349.99, imageReference: "hd650"), Product(name: "Samsung 850 Pro SSD", quantity: 1, UPC: "123456788", price: 189.99, imageReference: "850pro"), Product(name: "TAZO Iced Tea Passion", quantity: 1, UPC: "0762111911643", price: 5.24, imageReference: "tazo"), Product(name: "Alka-seltzer Original", quantity: 1, UPC: "0016500040118", price: 3.99, imageReference: "alka"), Product(name: "Ghirardelli Chocolate", quantity: 1, UPC: "0747599302350", price: 2.70, imageReference: "ghirardelli"), Product(name: "Oxford Index Cards", quantity: 1, UPC: "0078787401563", price: 3.99, imageReference: "oxford"),Product(name: "Anker Dual Charger", quantity: 1, UPC: "X000MY9HDB", price: 12.99, imageReference: "anker"), Product(name: "Pretzel Chocolate", quantity: 1, UPC: "0038000124266", price: 0.99, imageReference: "chocolate"), Product(name: "Clever Cracker", quantity: 1, UPC: "0828408814377", price: 5.99, imageReference: "cracker"), Product(name: "Clorox Wipes", quantity: 1, UPC: "0078742344454", price: 3.98, imageReference: "wetwipes"), Product(name: "Sweet Pea Lotion", quantity: 1, UPC: "894539245", price: 3.49, imageReference: "lotion"), Product(name: "Daily Green Tea", quantity: 1, UPC: "0742676400776", price: 7.99, imageReference: "greentea")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        println("viewDidload: \(self.cartString)")
        
        var nib = UINib(nibName: "itemTableCell", bundle: nil)
        cartTableView.registerNib(nib, forCellReuseIdentifier: "cell")
        
        var itemArray = cartString.componentsSeparatedByString("!")
        
        var toReturn = Product()
        //self.saveItem(productDatabase[1])
        
        for (var j=0; j<itemArray.count; j++){
            for (var i=0; i<productDatabase.count; i++){
                if itemArray[j] == productDatabase[i].UPC{
                    //toReturn = database[i]
                    
                    self.saveItem(productDatabase[i])
                }
            }
        }
        
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Cart")
        
        cartList = context.executeFetchRequest(request, error: nil)!
        
       // println("cartList \(cartList.count)")
        
        var totalPrice: Double = 0.0
        for (var i=0; i<cartList.count; i++){
            var currentQuantity = cartList[i].valueForKey("quantity") as Int!
            
            totalPrice += cartList[i].valueForKey("price") as Double! * Double(currentQuantity)
        }
        
        self.totalLabel.text = "Total: $\(totalPrice)"
        
        self.cartTableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        //self.cartTableView.editing = true;
        self.cartTableView.reloadData()
        
    }
    
    
    @IBAction func finishPressed(sender: UIButton) {
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Cart")
        
        cartList = context.executeFetchRequest(request, error: nil)!
        
        //self.totalLabel.text = "Total: $0.00"
        
        if let tv = cartTableView {
            
            var bas: NSManagedObject!
            
            for bas: AnyObject in cartList
            {
                context.deleteObject(bas as NSManagedObject)
            }
            
            cartList.removeAll(keepCapacity: false)
            tv.reloadData()
            context.save(nil)
            
        }
        
    }
    
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(cartTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList.count
    }
    
    func tableView(cartTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:itemCell = cartTableView.dequeueReusableCellWithIdentifier("cell") as itemCell
        let item = theCart[indexPath.row]
        var price: Double = 0.0
        var quantity: Int = 0
        
        cell.itemName.text = item.valueForKey("name") as String?
        price = item.valueForKey("price") as Double!
        cell.itemPrice.text = "$\(price)"
        var imageName = item.valueForKey("image") as String?
        cell.itemImage.image = UIImage(named: imageName!)
        quantity = item.valueForKey("quantity") as Int!
        cell.itemQuantity.text = "\(quantity)"
        var amount = price * Double(item.valueForKey("quantity") as Int!)
        cell.itemAmount.text = "$\(amount)"
        return cell
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.cartTableView.beginUpdates()
        self.cartTableView.insertRowsAtIndexPaths(theCart, withRowAnimation: UITableViewRowAnimation.Automatic)
        self.cartTableView.endUpdates()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 192
    }
    
    
    func saveItem(toAdd: Product) {
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity =  NSEntityDescription.entityForName("Cart",
            inManagedObjectContext:
            managedContext)
        
        
        
        // Search and update quantity if it an item exists in the database
        
        var fetchRequest = NSFetchRequest(entityName: "Cart")
        fetchRequest.predicate = NSPredicate(format: "upc = %@", toAdd.UPC)
        
        if let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: nil) as? [NSManagedObject] {
            if fetchResults.count != 0{
                
                var managedObject = fetchResults[0]
                var newQuantity = fetchResults[0].valueForKey("quantity") as Int + 1
                managedObject.setValue(newQuantity, forKey: "quantity")
                
                managedContext.save(nil)
            }
            
            
            if fetchResults.count == 0{
                let item = NSManagedObject(entity: entity!,
                    insertIntoManagedObjectContext:managedContext)
                
                //3
                item.setValue(toAdd.name, forKey: "name")
                item.setValue(toAdd.price, forKey: "price")
                item.setValue(1, forKey: "quantity")
                item.setValue(toAdd.imageReference, forKey: "image")
                item.setValue(toAdd.UPC, forKey: "upc")
                
                //4
                var error: NSError?
                if !managedContext.save(&error) {
                    println("Could not save \(error), \(error?.userInfo)")
                }
                //5
                theCart.append(item)
            }
        }
        
        
        

    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Cart")
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            theCart = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
